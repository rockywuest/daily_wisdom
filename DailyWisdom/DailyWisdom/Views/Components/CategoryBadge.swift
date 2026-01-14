import SwiftUI

struct CategoryBadge: View {
    let category: QuoteCategory

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.iconName)
                .font(.caption)
            Text(category.displayName)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(categoryColor.opacity(0.2))
        .foregroundStyle(categoryColor)
        .clipShape(Capsule())
    }

    private var categoryColor: Color {
        switch category.color {
        case "purple": return .purple
        case "blue": return .blue
        case "orange": return .orange
        case "red": return .red
        case "green": return .green
        case "indigo": return .indigo
        case "teal": return .teal
        case "yellow": return .yellow
        default: return .secondary
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        ForEach(QuoteCategory.allCases) { category in
            CategoryBadge(category: category)
        }
    }
    .padding()
}
