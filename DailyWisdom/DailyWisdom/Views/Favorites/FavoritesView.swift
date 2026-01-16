import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(QuoteViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedCategory: QuoteCategory?

    private var filteredFavorites: [Quote] {
        viewModel.favorites.filter { quote in
            let matchesSearch = searchText.isEmpty ||
                quote.text.localizedCaseInsensitiveContains(searchText) ||
                quote.author.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                quote.category == selectedCategory

            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                categoryFilterView

                // Favorites list
                if filteredFavorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search favorites")
        }
        .frame(width: 500, height: 600)
    }

    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }

                ForEach(QuoteCategory.allCases) { category in
                    FilterChip(
                        title: category.displayName,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(nsColor: .separatorColor).opacity(0.1))
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Favorites", systemImage: "heart.slash")
        } description: {
            if searchText.isEmpty {
                Text("Tap the heart on any quote to add it to your favorites.")
            } else {
                Text("No favorites match your search.")
            }
        }
    }

    private var favoritesListView: some View {
        List(filteredFavorites) { quote in
            FavoriteQuoteRow(quote: quote) {
                viewModel.toggleFavorite(for: quote)
            }
        }
        .listStyle(.inset)
    }
}

struct FavoriteQuoteRow: View {
    let quote: Quote
    let onUnfavorite: () -> Void

    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                CategoryBadge(category: quote.category)
                Spacer()
                if isHovering {
                    Button(action: onUnfavorite) {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("\"\(quote.text)\"")
                .font(.body)
                .foregroundStyle(.primary)

            HStack {
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 8) {
                    ShareButton(text: quote.shareText, size: .caption)

                    Button {
                        copyToClipboard()
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .help("Copy to clipboard")
                }
                .opacity(isHovering ? 1 : 0)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private func copyToClipboard() {
        let text = "\"\(quote.text)\" — \(quote.author)"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.1))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FavoritesView()
        .environment(QuoteViewModel())
}
