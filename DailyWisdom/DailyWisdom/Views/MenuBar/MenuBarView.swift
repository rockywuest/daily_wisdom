import SwiftUI
import SwiftData

struct MenuBarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(QuoteViewModel.self) private var viewModel

    @State private var showingFavorites = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerSection

            Divider()
                .padding(.vertical, 8)

            // Quick actions
            actionsSection

            Divider()
                .padding(.vertical, 8)

            // Recent quotes
            if !viewModel.recentQuotes.isEmpty {
                recentQuotesSection

                Divider()
                    .padding(.vertical, 8)
            }

            // Footer
            footerSection
        }
        .padding(12)
        .frame(width: 320)
        .onAppear {
            viewModel.configure(with: modelContext)
            Task {
                await viewModel.loadInitialData()
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("DailyWisdom")
                .font(.headline)
            Text("\(viewModel.quoteCount) quotes • \(viewModel.favorites.count) favorites")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                viewModel.showRandomQuote()
            } label: {
                Label("Show Quote", systemImage: "quote.bubble")
            }
            .keyboardShortcut("q", modifiers: [.command])

            Button {
                showingFavorites = true
            } label: {
                Label("Favorites (\(viewModel.favorites.count))", systemImage: "heart")
            }
            .keyboardShortcut("f", modifiers: [.command])
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingFavorites) {
            FavoritesView()
                .environment(viewModel)
        }
    }

    private var recentQuotesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recent")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)

            ForEach(viewModel.recentQuotes.prefix(3)) { quote in
                RecentQuoteRow(quote: quote)
            }
        }
    }

    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            SettingsLink {
                Label("Settings...", systemImage: "gear")
            }
            .keyboardShortcut(",", modifiers: [.command])

            Divider()
                .padding(.vertical, 4)

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit DailyWisdom", systemImage: "power")
            }
            .keyboardShortcut("q", modifiers: [.command, .shift])
        }
        .buttonStyle(.plain)
    }
}

struct RecentQuoteRow: View {
    let quote: Quote

    @State private var isHovering = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(quote.text)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                Text("— \(quote.author)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isHovering {
                ShareButton(text: quote.shareText, size: .caption)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    MenuBarView()
        .modelContainer(for: Quote.self, inMemory: true)
        .environment(QuoteViewModel())
}
