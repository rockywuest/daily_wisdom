import SwiftUI
import SwiftData

@main
struct DailyWisdomApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var viewModel = QuoteViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Quote.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .modelContainer(sharedModelContainer)
                .environment(viewModel)
                .onAppear {
                    // Connect the view model to the app delegate
                    appDelegate.setViewModel(viewModel)
                    // Configure with model context
                    viewModel.configure(with: sharedModelContainer.mainContext)
                    // Load initial data
                    Task {
                        await viewModel.loadInitialData()
                    }
                }
        } label: {
            Label("DailyWisdom", systemImage: "quote.bubble")
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .modelContainer(sharedModelContainer)
                .environment(viewModel)
        }
    }
}
