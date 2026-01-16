import SwiftUI
import AppKit

/// A share button that presents the system sharing service picker.
/// Matches the styling of FavoriteButton with spring animation.
struct ShareButton: View {
    let text: String
    var size: Font = .title2

    @State private var isAnimating = false

    var body: some View {
        SharingServiceButton(
            items: [text],
            isAnimating: $isAnimating
        ) {
            Image(systemName: "square.and.arrow.up")
                .font(size)
                .foregroundStyle(.secondary)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
        }
        .buttonStyle(.plain)
        .help("Share quote")
    }
}

/// NSViewRepresentable that wraps SwiftUI content and provides
/// an anchor view for NSSharingServicePicker presentation.
struct SharingServiceButton<Content: View>: NSViewRepresentable {
    let items: [Any]
    @Binding var isAnimating: Bool
    @ViewBuilder let content: () -> Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        let hostingView = NSHostingView(rootView: content())
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        let clickGesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.showPicker(_:))
        )
        hostingView.addGestureRecognizer(clickGesture)

        return hostingView
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        nsView.rootView = content()
        context.coordinator.items = items
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(items: items, isAnimating: $isAnimating)
    }

    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        var items: [Any]
        var isAnimating: Binding<Bool>

        init(items: [Any], isAnimating: Binding<Bool>) {
            self.items = items
            self.isAnimating = isAnimating
        }

        @objc func showPicker(_ sender: NSClickGestureRecognizer) {
            guard let view = sender.view else { return }

            // Trigger spring animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating.wrappedValue = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isAnimating.wrappedValue = false
            }

            let picker = NSSharingServicePicker(items: items)
            picker.delegate = self
            picker.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        ShareButton(text: "\"Test quote\" — Author")
        ShareButton(text: "\"Test quote\" — Author", size: .caption)
    }
    .padding()
}
