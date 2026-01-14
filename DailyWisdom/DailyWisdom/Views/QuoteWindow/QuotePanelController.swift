import AppKit
import SwiftUI

final class QuotePanelController {
    private var panel: NSPanel?
    private var hostingView: NSHostingView<AnyView>?

    var isVisible: Bool {
        panel?.isVisible ?? false
    }

    func showQuote(
        _ quote: Quote,
        displayDuration: TimeInterval,
        onDismiss: @escaping () -> Void,
        onFavoriteToggle: @escaping () -> Void
    ) {
        // Don't show if already visible
        guard !isVisible else {
            print("[QuotePanelController] Panel already visible, skipping")
            return
        }

        // Create the SwiftUI view
        let quoteView = QuoteWindowView(
            quote: quote,
            displayDuration: displayDuration,
            onDismiss: { [weak self] in
                self?.dismiss()
                onDismiss()
            },
            onFavoriteToggle: onFavoriteToggle
        )

        // Create the panel
        let panel = createPanel()
        self.panel = panel

        // Set the content
        let hostingView = NSHostingView(rootView: AnyView(quoteView))
        hostingView.frame = panel.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        panel.contentView?.addSubview(hostingView)
        self.hostingView = hostingView

        // Center on main screen
        centerOnMainScreen(panel)

        // Show with animation
        panel.alphaValue = 0
        panel.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1
        }

        print("[QuotePanelController] Showing quote panel")
    }

    func dismiss() {
        guard let panel = panel else { return }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().alphaValue = 0
        } completionHandler: { [weak self] in
            panel.orderOut(nil)
            self?.panel = nil
            self?.hostingView = nil
            print("[QuotePanelController] Dismissed quote panel")
        }
    }

    private func createPanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: Constants.Window.width,
                height: Constants.Window.height
            ),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isMovableByWindowBackground = false
        panel.hidesOnDeactivate = false
        panel.titlebarAppearsTransparent = true
        panel.titleVisibility = .hidden
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true

        return panel
    }

    private func centerOnMainScreen(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }

        let screenRect = screen.visibleFrame
        let panelSize = panel.frame.size

        let x = screenRect.midX - panelSize.width / 2
        let y = screenRect.midY - panelSize.height / 2

        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
