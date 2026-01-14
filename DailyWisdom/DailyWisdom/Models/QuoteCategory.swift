import Foundation

enum QuoteCategory: String, Codable, CaseIterable, Identifiable {
    case mentalModel = "mental-model"
    case stoicism = "stoicism"
    case leadership = "leadership"
    case focus = "focus"
    case growth = "growth"
    case strategy = "strategy"
    case business = "business"
    case wisdom = "wisdom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .mentalModel: return "Mental Model"
        case .stoicism: return "Stoicism"
        case .leadership: return "Leadership"
        case .focus: return "Focus"
        case .growth: return "Growth"
        case .strategy: return "Strategy"
        case .business: return "Business"
        case .wisdom: return "Wisdom"
        }
    }

    var iconName: String {
        switch self {
        case .mentalModel: return "brain.head.profile"
        case .stoicism: return "mountain.2"
        case .leadership: return "person.3"
        case .focus: return "target"
        case .growth: return "arrow.up.right"
        case .strategy: return "chess"
        case .business: return "briefcase"
        case .wisdom: return "lightbulb"
        }
    }

    var color: String {
        switch self {
        case .mentalModel: return "purple"
        case .stoicism: return "blue"
        case .leadership: return "orange"
        case .focus: return "red"
        case .growth: return "green"
        case .strategy: return "indigo"
        case .business: return "teal"
        case .wisdom: return "yellow"
        }
    }
}
