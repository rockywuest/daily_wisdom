import SwiftUI

struct QuoteWindowView: View {
    let quote: Quote
    let onDismiss: () -> Void
    let onFavoriteToggle: () -> Void

    @State private var isHovering = false
    @State private var remainingTime: TimeInterval
    @State private var isPaused = false

    private let totalTime: TimeInterval

    init(
        quote: Quote,
        displayDuration: TimeInterval = Constants.Defaults.displayDuration,
        onDismiss: @escaping () -> Void,
        onFavoriteToggle: @escaping () -> Void
    ) {
        self.quote = quote
        self.totalTime = displayDuration
        self._remainingTime = State(initialValue: displayDuration)
        self.onDismiss = onDismiss
        self.onFavoriteToggle = onFavoriteToggle
    }

    var body: some View {
        ZStack {
            // Blur background
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)

            // Content
            VStack(spacing: 0) {
                // Top bar with category and close
                HStack {
                    CategoryBadge(category: quote.category)
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .help("Dismiss (or tap anywhere)")
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                Spacer()

                // Quote text
                Text("\"\(quote.text)\"")
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 48)
                    .lineSpacing(6)

                // Author
                Text("— \(quote.author)")
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)

                Spacer()

                // Bottom bar with favorite, share, and timer
                HStack {
                    HStack(spacing: 12) {
                        FavoriteButton(isFavorite: quote.isFavorite, action: onFavoriteToggle)
                        ShareButton(text: quote.shareText)
                    }

                    Spacer()

                    // Progress indicator
                    if !isPaused {
                        TimerProgressView(
                            remainingTime: remainingTime,
                            totalTime: totalTime
                        )
                    } else {
                        Text("Paused")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .frame(width: Constants.Window.width, height: Constants.Window.height)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Window.cornerRadius))
        .onHover { hovering in
            isHovering = hovering
            isPaused = hovering
        }
        .onTapGesture {
            onDismiss()
        }
        .onAppear {
            startTimer()
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !isPaused {
                remainingTime -= 0.1
                if remainingTime <= 0 {
                    timer.invalidate()
                    onDismiss()
                }
            }
        }
    }
}

struct TimerProgressView: View {
    let remainingTime: TimeInterval
    let totalTime: TimeInterval

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .trim(from: 0, to: remainingTime / totalTime)
                .stroke(Color.secondary.opacity(0.5), lineWidth: 2)
                .frame(width: 12, height: 12)
                .rotationEffect(.degrees(-90))

            Text("\(Int(remainingTime))s")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }
}

#Preview {
    QuoteWindowView(
        quote: Quote(
            text: "The impediment to action advances action. What stands in the way becomes the way.",
            author: "Marcus Aurelius",
            category: .stoicism
        ),
        onDismiss: {},
        onFavoriteToggle: {}
    )
}
