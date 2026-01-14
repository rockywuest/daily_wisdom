import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @Environment(QuoteViewModel.self) private var viewModel

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            CategoriesSettingsView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }

            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 450, height: 300)
        .environment(viewModel)
    }
}

struct GeneralSettingsView: View {
    @Environment(QuoteViewModel.self) private var viewModel
    @State private var launchAtLogin = false

    var body: some View {
        @Bindable var vm = viewModel

        Form {
            Section {
                Toggle("Show quote on screen unlock", isOn: $vm.showOnUnlock)

                LabeledContent("Display duration") {
                    HStack {
                        Slider(value: $vm.displayDuration, in: 5...30, step: 1)
                            .frame(width: 150)
                        Text("\(Int(vm.displayDuration))s")
                            .monospacedDigit()
                            .frame(width: 35, alignment: .trailing)
                    }
                }
            } header: {
                Text("Quote Display")
            }

            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        setLaunchAtLogin(newValue)
                    }
            } header: {
                Text("Startup")
            }
        }
        .formStyle(.grouped)
        .onAppear {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("[Settings] Failed to set launch at login: \(error)")
        }
    }
}

struct CategoriesSettingsView: View {
    @Environment(QuoteViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel

        Form {
            Section {
                ForEach(QuoteCategory.allCases) { category in
                    Toggle(isOn: Binding(
                        get: { vm.enabledCategories.contains(category) },
                        set: { enabled in
                            if enabled {
                                vm.enabledCategories.insert(category)
                            } else {
                                vm.enabledCategories.remove(category)
                            }
                        }
                    )) {
                        Label(category.displayName, systemImage: category.iconName)
                    }
                }
            } header: {
                Text("Enabled Categories")
            } footer: {
                Text("Only quotes from enabled categories will be shown.")
            }
        }
        .formStyle(.grouped)
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "quote.bubble.fill")
                .font(.system(size: 60))
                .foregroundStyle(.accent)

            Text("DailyWisdom")
                .font(.title.bold())

            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Curated wisdom to inspire your day.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Text("Made with intention")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(40)
    }
}

#Preview {
    SettingsView()
        .environment(QuoteViewModel())
}
