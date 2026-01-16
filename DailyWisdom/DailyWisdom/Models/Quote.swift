import Foundation
import SwiftData

@Model
final class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var categoryRaw: String
    var note: String?
    var isFavorite: Bool
    var viewCount: Int
    var lastShown: Date?
    var createdAt: Date

    var category: QuoteCategory {
        get { QuoteCategory(rawValue: categoryRaw) ?? .wisdom }
        set { categoryRaw = newValue.rawValue }
    }

    /// Formatted text for sharing via system share sheet
    var shareText: String {
        "\"\(text)\" — \(author)"
    }

    init(
        id: UUID = UUID(),
        text: String,
        author: String,
        category: QuoteCategory,
        note: String? = nil,
        isFavorite: Bool = false,
        viewCount: Int = 0,
        lastShown: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.text = text
        self.author = author
        self.categoryRaw = category.rawValue
        self.note = note
        self.isFavorite = isFavorite
        self.viewCount = viewCount
        self.lastShown = lastShown
        self.createdAt = createdAt
    }
}

// MARK: - Seed Data Structure
struct SeedQuote: Codable {
    let id: String
    let text: String
    let author: String
    let category: String
    let note: String?
}
