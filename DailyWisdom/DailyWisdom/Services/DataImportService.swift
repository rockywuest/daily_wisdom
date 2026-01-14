import Foundation
import SwiftData

@MainActor
final class DataImportService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var hasImportedQuotes: Bool {
        UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.hasImportedQuotes)
    }

    func importInitialQuotesIfNeeded() async {
        guard !hasImportedQuotes else {
            print("[DataImportService] Quotes already imported, skipping")
            return
        }

        print("[DataImportService] Starting initial quote import...")

        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else {
            print("[DataImportService] ERROR: quotes.json not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let seedQuotes = try JSONDecoder().decode([SeedQuote].self, from: data)

            print("[DataImportService] Found \(seedQuotes.count) quotes to import")

            for seedQuote in seedQuotes {
                let category = QuoteCategory(rawValue: seedQuote.category) ?? .wisdom
                let quote = Quote(
                    text: seedQuote.text,
                    author: seedQuote.author,
                    category: category,
                    note: seedQuote.note
                )
                modelContext.insert(quote)
            }

            try modelContext.save()
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKeys.hasImportedQuotes)

            print("[DataImportService] Successfully imported \(seedQuotes.count) quotes")
        } catch {
            print("[DataImportService] ERROR importing quotes: \(error)")
        }
    }

    func resetAndReimport() async {
        print("[DataImportService] Resetting quote database...")

        // Delete all existing quotes
        let descriptor = FetchDescriptor<Quote>()
        if let existingQuotes = try? modelContext.fetch(descriptor) {
            for quote in existingQuotes {
                modelContext.delete(quote)
            }
            try? modelContext.save()
        }

        // Reset the flag and reimport
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKeys.hasImportedQuotes)
        await importInitialQuotesIfNeeded()
    }
}
