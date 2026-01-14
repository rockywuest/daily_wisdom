import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class QuoteViewModel {
    // MARK: - Published State
    var currentQuote: Quote?
    var isShowingQuote = false
    var favorites: [Quote] = []
    var recentQuotes: [Quote] = []
    var quoteCount: Int = 0

    // MARK: - Settings
    var displayDuration: TimeInterval {
        get { UserDefaults.standard.double(forKey: Constants.UserDefaultsKeys.displayDuration).nonZero ?? Constants.Defaults.displayDuration }
        set { UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.displayDuration) }
    }

    var showOnUnlock: Bool {
        get { UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.showOnUnlock) as? Bool ?? Constants.Defaults.showOnUnlock }
        set { UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.showOnUnlock) }
    }

    var enabledCategories: Set<QuoteCategory> {
        get {
            if let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.enabledCategories),
               let categories = try? JSONDecoder().decode(Set<String>.self, from: data) {
                return Set(categories.compactMap { QuoteCategory(rawValue: $0) })
            }
            return Set(QuoteCategory.allCases)
        }
        set {
            let strings = Set(newValue.map { $0.rawValue })
            if let data = try? JSONEncoder().encode(strings) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKeys.enabledCategories)
            }
        }
    }

    // MARK: - Dependencies
    private var quoteService: QuoteService?
    private var dataImportService: DataImportService?
    private let panelController = QuotePanelController()

    // MARK: - Initialization

    func configure(with modelContext: ModelContext) {
        self.quoteService = QuoteService(modelContext: modelContext)
        self.dataImportService = DataImportService(modelContext: modelContext)
    }

    // MARK: - Data Loading

    func loadInitialData() async {
        await dataImportService?.importInitialQuotesIfNeeded()
        refreshData()
    }

    func refreshData() {
        guard let service = quoteService else { return }
        favorites = service.fetchFavorites()
        recentQuotes = service.fetchRecentQuotes()
        quoteCount = service.fetchQuoteCount()
    }

    // MARK: - Quote Display

    func showRandomQuote() {
        guard let service = quoteService else { return }
        guard let quote = service.selectNextQuote(enabledCategories: enabledCategories) else {
            print("[QuoteViewModel] No quotes available")
            return
        }

        currentQuote = quote
        isShowingQuote = true

        service.markAsShown(quote)

        panelController.showQuote(
            quote,
            displayDuration: displayDuration,
            onDismiss: { [weak self] in
                self?.isShowingQuote = false
                self?.refreshData()
            },
            onFavoriteToggle: { [weak self] in
                self?.toggleCurrentQuoteFavorite()
            }
        )
    }

    func dismissQuote() {
        panelController.dismiss()
        isShowingQuote = false
    }

    // MARK: - Favorites

    func toggleCurrentQuoteFavorite() {
        guard let quote = currentQuote, let service = quoteService else { return }
        service.toggleFavorite(quote)
        refreshData()
    }

    func toggleFavorite(for quote: Quote) {
        quoteService?.toggleFavorite(quote)
        refreshData()
    }

    // MARK: - Screen Lock Handling

    func handleScreenUnlock() {
        guard showOnUnlock else {
            print("[QuoteViewModel] Show on unlock disabled")
            return
        }
        showRandomQuote()
    }
}

// MARK: - Helpers

private extension Double {
    var nonZero: Double? {
        self != 0 ? self : nil
    }
}
