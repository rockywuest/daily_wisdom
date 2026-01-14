import Foundation
import SwiftData

@MainActor
final class QuoteService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Quote Selection

    func selectNextQuote(enabledCategories: Set<QuoteCategory> = Set(QuoteCategory.allCases)) -> Quote? {
        let categoryStrings = enabledCategories.map { $0.rawValue }

        // Fetch all quotes in enabled categories
        let descriptor = FetchDescriptor<Quote>(
            predicate: #Predicate<Quote> { quote in
                categoryStrings.contains(quote.categoryRaw)
            },
            sortBy: [SortDescriptor(\.viewCount), SortDescriptor(\.lastShown)]
        )

        guard let quotes = try? modelContext.fetch(descriptor), !quotes.isEmpty else {
            return nil
        }

        // Priority 1: Never shown quotes
        let neverShown = quotes.filter { $0.viewCount == 0 }
        if !neverShown.isEmpty {
            return neverShown.randomElement()
        }

        // Priority 2: Weighted random based on recency and view count
        return weightedRandomSelection(from: quotes)
    }

    private func weightedRandomSelection(from quotes: [Quote]) -> Quote? {
        let now = Date()
        let weights = quotes.map { quote -> Double in
            let daysSinceShown = quote.lastShown.map {
                max(1, Calendar.current.dateComponents([.day], from: $0, to: now).day ?? 1)
            } ?? 365

            let recencyWeight = Double(daysSinceShown)
            let countWeight = 1.0 / Double(quote.viewCount + 1)
            return recencyWeight * countWeight
        }

        let totalWeight = weights.reduce(0, +)
        guard totalWeight > 0 else { return quotes.randomElement() }

        var random = Double.random(in: 0..<totalWeight)
        for (index, weight) in weights.enumerated() {
            random -= weight
            if random <= 0 {
                return quotes[index]
            }
        }

        return quotes.last
    }

    // MARK: - Quote Actions

    func markAsShown(_ quote: Quote) {
        quote.viewCount += 1
        quote.lastShown = Date()
        try? modelContext.save()
    }

    func toggleFavorite(_ quote: Quote) {
        quote.isFavorite.toggle()
        try? modelContext.save()
    }

    // MARK: - Queries

    func fetchFavorites() -> [Quote] {
        let descriptor = FetchDescriptor<Quote>(
            predicate: #Predicate<Quote> { $0.isFavorite },
            sortBy: [SortDescriptor(\.author)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchRecentQuotes(limit: Int = 5) -> [Quote] {
        var descriptor = FetchDescriptor<Quote>(
            predicate: #Predicate<Quote> { $0.lastShown != nil },
            sortBy: [SortDescriptor(\.lastShown, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchQuoteCount() -> Int {
        let descriptor = FetchDescriptor<Quote>()
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    func fetchQuote(by id: UUID) -> Quote? {
        let descriptor = FetchDescriptor<Quote>(
            predicate: #Predicate<Quote> { $0.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }
}
