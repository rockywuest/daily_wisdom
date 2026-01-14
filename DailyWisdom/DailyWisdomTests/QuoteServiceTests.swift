import XCTest
import SwiftData
@testable import DailyWisdom

@MainActor
final class QuoteServiceTests: XCTestCase {

    private var container: ModelContainer!
    private var service: QuoteService!

    override func setUp() async throws {
        try await super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Quote.self, configurations: config)
        service = QuoteService(modelContext: container.mainContext)
    }

    override func tearDown() async throws {
        service = nil
        container = nil
        try await super.tearDown()
    }

    // Helper to create a test quote
    private func createQuote(
        text: String = "Test quote",
        author: String = "Test Author",
        category: QuoteCategory = .wisdom,
        viewCount: Int = 0,
        lastShown: Date? = nil,
        isFavorite: Bool = false
    ) -> Quote {
        let quote = Quote(
            text: text,
            author: author,
            category: category
        )
        quote.viewCount = viewCount
        quote.lastShown = lastShown
        quote.isFavorite = isFavorite
        container.mainContext.insert(quote)
        try? container.mainContext.save()
        return quote
    }

    // MARK: - Quote Selection Tests

    func testSelectNextQuoteReturnsNilWhenEmpty() {
        let result = service.selectNextQuote()
        XCTAssertNil(result)
    }

    func testSelectNextQuotePrioritizesNeverShown() {
        // Create a quote that has been shown
        _ = createQuote(
            text: "Shown quote",
            viewCount: 5,
            lastShown: Date()
        )

        // Create a quote that has never been shown
        let neverShownQuote = createQuote(
            text: "Never shown",
            viewCount: 0,
            lastShown: nil
        )

        // Run multiple times - should always get the never-shown quote
        for _ in 0..<10 {
            let result = service.selectNextQuote()
            XCTAssertEqual(result?.id, neverShownQuote.id, "Should return the never-shown quote")
        }
    }

    func testSelectNextQuoteFiltersByCategory() {
        // Create quotes in different categories
        let wisdomQuote = createQuote(text: "Wisdom", category: .wisdom)
        _ = createQuote(text: "Focus", category: .focus)

        // Only enable wisdom category
        let result = service.selectNextQuote(enabledCategories: [.wisdom])

        XCTAssertEqual(result?.id, wisdomQuote.id, "Should return quote from enabled category")
    }

    func testSelectNextQuoteReturnsNilWhenNoCategoryMatch() {
        // Create quote in wisdom category
        _ = createQuote(category: .wisdom)

        // Request only focus category (which has no quotes)
        let result = service.selectNextQuote(enabledCategories: [.focus])

        XCTAssertNil(result)
    }

    func testSelectNextQuoteWithMultipleCategories() {
        let wisdomQuote = createQuote(text: "Wisdom", category: .wisdom)
        let focusQuote = createQuote(text: "Focus", category: .focus)
        _ = createQuote(text: "Business", category: .business)

        // Enable only wisdom and focus
        let enabledCategories: Set<QuoteCategory> = [.wisdom, .focus]
        var selectedIds = Set<UUID>()

        for _ in 0..<20 {
            if let result = service.selectNextQuote(enabledCategories: enabledCategories) {
                selectedIds.insert(result.id)
            }
        }

        XCTAssertTrue(selectedIds.contains(wisdomQuote.id) || selectedIds.contains(focusQuote.id))
    }

    // MARK: - Mark As Shown Tests

    func testMarkAsShownIncrementsViewCount() {
        let quote = createQuote(viewCount: 0)
        let initialCount = quote.viewCount

        service.markAsShown(quote)

        XCTAssertEqual(quote.viewCount, initialCount + 1)
    }

    func testMarkAsShownSetsLastShownDate() {
        let quote = createQuote(lastShown: nil)
        XCTAssertNil(quote.lastShown)

        let beforeMark = Date()
        service.markAsShown(quote)
        let afterMark = Date()

        XCTAssertNotNil(quote.lastShown)
        XCTAssertGreaterThanOrEqual(quote.lastShown!, beforeMark)
        XCTAssertLessThanOrEqual(quote.lastShown!, afterMark)
    }

    func testMarkAsShownMultipleTimes() {
        let quote = createQuote(viewCount: 0)

        service.markAsShown(quote)
        service.markAsShown(quote)
        service.markAsShown(quote)

        XCTAssertEqual(quote.viewCount, 3)
    }

    // MARK: - Toggle Favorite Tests

    func testToggleFavoriteChangesFavoriteStatus() {
        let quote = createQuote(isFavorite: false)
        XCTAssertFalse(quote.isFavorite)

        service.toggleFavorite(quote)
        XCTAssertTrue(quote.isFavorite)

        service.toggleFavorite(quote)
        XCTAssertFalse(quote.isFavorite)
    }

    // MARK: - Fetch Favorites Tests

    func testFetchFavoritesReturnsOnlyFavorites() {
        _ = createQuote(text: "Not favorite", isFavorite: false)
        let favorite1 = createQuote(text: "Favorite 1", isFavorite: true)
        let favorite2 = createQuote(text: "Favorite 2", isFavorite: true)

        let favorites = service.fetchFavorites()

        XCTAssertEqual(favorites.count, 2)
        XCTAssertTrue(favorites.contains { $0.id == favorite1.id })
        XCTAssertTrue(favorites.contains { $0.id == favorite2.id })
    }

    func testFetchFavoritesReturnsEmptyWhenNoFavorites() {
        _ = createQuote(isFavorite: false)
        _ = createQuote(isFavorite: false)

        let favorites = service.fetchFavorites()

        XCTAssertTrue(favorites.isEmpty)
    }

    // MARK: - Fetch Quote Count Tests

    func testFetchQuoteCountReturnsCorrectCount() {
        XCTAssertEqual(service.fetchQuoteCount(), 0)

        _ = createQuote(text: "Quote 1")
        XCTAssertEqual(service.fetchQuoteCount(), 1)

        _ = createQuote(text: "Quote 2")
        XCTAssertEqual(service.fetchQuoteCount(), 2)
    }

    // MARK: - Fetch Quote By ID Tests

    func testFetchQuoteByIdReturnsCorrectQuote() {
        let quote = createQuote(text: "Find me")

        let result = service.fetchQuote(by: quote.id)

        XCTAssertEqual(result?.id, quote.id)
        XCTAssertEqual(result?.text, "Find me")
    }

    func testFetchQuoteByIdReturnsNilForUnknownId() {
        let result = service.fetchQuote(by: UUID())
        XCTAssertNil(result)
    }

    // MARK: - Fetch Recent Quotes Tests

    func testFetchRecentQuotesReturnsShownQuotes() {
        let quote1 = createQuote(text: "Quote 1", lastShown: Date().addingTimeInterval(-3600))
        let quote2 = createQuote(text: "Quote 2", lastShown: Date())
        _ = createQuote(text: "Never shown", lastShown: nil)

        let recent = service.fetchRecentQuotes()

        XCTAssertEqual(recent.count, 2)
        // Most recent should be first
        XCTAssertEqual(recent.first?.id, quote2.id)
        XCTAssertTrue(recent.contains { $0.id == quote1.id })
    }

    func testFetchRecentQuotesRespectsLimit() {
        for i in 0..<10 {
            _ = createQuote(text: "Quote \(i)", lastShown: Date().addingTimeInterval(Double(-i * 3600)))
        }

        let recent = service.fetchRecentQuotes(limit: 3)

        XCTAssertEqual(recent.count, 3)
    }
}
