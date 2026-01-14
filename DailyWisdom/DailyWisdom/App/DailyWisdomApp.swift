import SwiftUI
import SwiftData

@main
struct DailyWisdomApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var viewModel: QuoteViewModel

    let sharedModelContainer: ModelContainer

    init() {
        // Create the model container
        let schema = Schema([Quote.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        self.sharedModelContainer = container

        // Create and configure the view model
        let vm = QuoteViewModel()
        vm.configure(with: container.mainContext)
        self._viewModel = State(initialValue: vm)

        // Connect ViewModel to AppDelegate immediately
        // Note: appDelegate is available here because @NSApplicationDelegateAdaptor
        // initializes the AppDelegate when the property wrapper is created
        appDelegate.setViewModel(vm)

        // Load initial data asynchronously
        Task { @MainActor in
            await vm.loadInitialData()
        }

        print("[DailyWisdomApp] Initialized with ModelContainer")
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .modelContainer(sharedModelContainer)
                .environment(viewModel)
                .onAppear {
                    // Fallback connection in case init() timing varies
                    if appDelegate.viewModel == nil {
                        appDelegate.setViewModel(viewModel)
                        print("[DailyWisdomApp] Connected ViewModel to AppDelegate via onAppear (fallback)")
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
