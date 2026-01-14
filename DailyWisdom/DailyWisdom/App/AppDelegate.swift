import AppKit
import SwiftUI
import SwiftData

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var screenLockMonitor: ScreenLockMonitor?
    private(set) weak var viewModel: QuoteViewModel?

    func setViewModel(_ viewModel: QuoteViewModel) {
        self.viewModel = viewModel
        print("[AppDelegate] ViewModel connected")
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("[AppDelegate] Application did finish launching")

        // Set up screen lock monitoring
        screenLockMonitor = ScreenLockMonitor(delegate: self)
        screenLockMonitor?.startMonitoring()

        // Hide the dock icon (menubar app only)
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationWillTerminate(_ notification: Notification) {
        print("[AppDelegate] Application will terminate")
        screenLockMonitor?.stopMonitoring()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

// MARK: - ScreenLockMonitorDelegate

extension AppDelegate: ScreenLockMonitorDelegate {
    func screenDidLock() {
        print("[AppDelegate] Screen locked")
    }

    func screenDidUnlock() {
        print("[AppDelegate] Screen unlocked - triggering quote display")

        Task { @MainActor in
            viewModel?.handleScreenUnlock()
        }
    }
}
