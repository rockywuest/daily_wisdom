import XCTest
@testable import DailyWisdom

final class QuoteCategoryTests: XCTestCase {

    // MARK: - Display Name Tests

    func testAllCategoriesHaveDisplayNames() {
        for category in QuoteCategory.allCases {
            XCTAssertFalse(category.displayName.isEmpty, "Category \(category.rawValue) should have a display name")
        }
    }

    func testDisplayNamesAreProperlyFormatted() {
        XCTAssertEqual(QuoteCategory.mentalModel.displayName, "Mental Model")
        XCTAssertEqual(QuoteCategory.stoicism.displayName, "Stoicism")
        XCTAssertEqual(QuoteCategory.leadership.displayName, "Leadership")
        XCTAssertEqual(QuoteCategory.focus.displayName, "Focus")
        XCTAssertEqual(QuoteCategory.growth.displayName, "Growth")
        XCTAssertEqual(QuoteCategory.strategy.displayName, "Strategy")
        XCTAssertEqual(QuoteCategory.business.displayName, "Business")
        XCTAssertEqual(QuoteCategory.wisdom.displayName, "Wisdom")
    }

    // MARK: - Icon Tests

    func testAllCategoriesHaveIcons() {
        for category in QuoteCategory.allCases {
            XCTAssertFalse(category.iconName.isEmpty, "Category \(category.rawValue) should have an icon")
        }
    }

    func testIconNamesAreExpectedValues() {
        XCTAssertEqual(QuoteCategory.mentalModel.iconName, "brain.head.profile")
        XCTAssertEqual(QuoteCategory.stoicism.iconName, "mountain.2")
        XCTAssertEqual(QuoteCategory.leadership.iconName, "person.3")
        XCTAssertEqual(QuoteCategory.focus.iconName, "target")
        XCTAssertEqual(QuoteCategory.growth.iconName, "arrow.up.right")
        XCTAssertEqual(QuoteCategory.strategy.iconName, "chess")
        XCTAssertEqual(QuoteCategory.business.iconName, "briefcase")
        XCTAssertEqual(QuoteCategory.wisdom.iconName, "lightbulb")
    }

    // MARK: - Color Tests

    func testAllCategoriesHaveColors() {
        for category in QuoteCategory.allCases {
            XCTAssertFalse(category.color.isEmpty, "Category \(category.rawValue) should have a color")
        }
    }

    func testColorsAreUnique() {
        let colors = QuoteCategory.allCases.map { $0.color }
        let uniqueColors = Set(colors)
        XCTAssertEqual(colors.count, uniqueColors.count, "All categories should have unique colors")
    }

    func testColorValues() {
        XCTAssertEqual(QuoteCategory.mentalModel.color, "purple")
        XCTAssertEqual(QuoteCategory.stoicism.color, "blue")
        XCTAssertEqual(QuoteCategory.leadership.color, "orange")
        XCTAssertEqual(QuoteCategory.focus.color, "red")
        XCTAssertEqual(QuoteCategory.growth.color, "green")
        XCTAssertEqual(QuoteCategory.strategy.color, "indigo")
        XCTAssertEqual(QuoteCategory.business.color, "teal")
        XCTAssertEqual(QuoteCategory.wisdom.color, "yellow")
    }

    // MARK: - Identifiable Conformance

    func testIdMatchesRawValue() {
        for category in QuoteCategory.allCases {
            XCTAssertEqual(category.id, category.rawValue)
        }
    }

    // MARK: - Case Count

    func testHasExpectedCategoryCount() {
        XCTAssertEqual(QuoteCategory.allCases.count, 8)
    }

    // MARK: - Raw Value Format

    func testRawValuesAreKebabCase() {
        for category in QuoteCategory.allCases {
            let rawValue = category.rawValue
            XCTAssertFalse(rawValue.contains(" "), "Raw value should not contain spaces")
            XCTAssertEqual(rawValue, rawValue.lowercased(), "Raw value should be lowercase")
        }
    }

    // MARK: - Codable Conformance

    func testCategoryEncodesAndDecodes() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for category in QuoteCategory.allCases {
            let encoded = try encoder.encode(category)
            let decoded = try decoder.decode(QuoteCategory.self, from: encoded)
            XCTAssertEqual(category, decoded)
        }
    }
}
