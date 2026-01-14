# DailyWisdom

A macOS menubar app that displays inspirational quotes every time you unlock your Mac.

![macOS](https://img.shields.io/badge/macOS-14.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

DailyWisdom transforms every screen unlock into an opportunity for inspiration. A beautifully designed floating panel displays a carefully curated quote from history's greatest minds—then gracefully fades away, letting you start your session with renewed focus.

## Features

- **Automatic Quote Display** – Shows an inspirational quote every time you unlock your Mac
- **370+ Curated Quotes** – Wisdom from thinkers like Marcus Aurelius, Charlie Munger, Naval Ravikant, and more
- **8 Categories** – Mental Models, Stoicism, Leadership, Focus, Growth, Strategy, Business, Wisdom
- **Favorites System** – Save quotes that resonate with you
- **Smart Selection** – Prioritizes quotes you haven't seen, ensuring variety
- **Customizable** – Adjust display duration (5-30 seconds), toggle categories, launch at login
- **Privacy First** – Works entirely offline, no data collection

## Screenshots

| Quote Display | Menubar | Settings |
|---------------|---------|----------|
| ![Quote](DailyWisdom/fastlane/screenshots/en-US/quote_display.png) | ![Menu](DailyWisdom/fastlane/screenshots/en-US/menubar.png) | ![Settings](DailyWisdom/fastlane/screenshots/en-US/settings.png) |

*Note: Add screenshots to `DailyWisdom/fastlane/screenshots/en-US/` directory*

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later (for building from source)

## Installation

### From Mac App Store

[Download on the Mac App Store](https://apps.apple.com/app/dailywisdom) *(coming soon)*

### Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/rockywuest/daily_wisdom.git
   cd daily_wisdom
   ```

2. Open in Xcode:
   ```bash
   open DailyWisdom/DailyWisdom.xcodeproj
   ```

3. Build and run (⌘R)

## Architecture

```
DailyWisdom/
├── App/
│   ├── DailyWisdomApp.swift      # Main app entry, MenuBarExtra
│   ├── AppDelegate.swift          # Screen lock monitoring, panel management
│   └── Constants.swift            # App-wide constants
├── Models/
│   ├── Quote.swift                # SwiftData model
│   └── QuoteCategory.swift        # Category enum
├── ViewModels/
│   └── QuoteViewModel.swift       # @Observable business logic
├── Views/
│   ├── QuoteWindow/               # Floating quote panel
│   ├── MenuBar/                   # Menubar dropdown
│   ├── Settings/                  # Preferences window
│   └── Components/                # Reusable UI components
├── Services/
│   ├── ScreenLockMonitor.swift    # Lock/unlock detection
│   ├── QuoteService.swift         # Quote selection algorithm
│   └── DataImportService.swift    # JSON seed data import
└── Resources/
    ├── quotes.json                # 370+ quotes database
    └── Assets.xcassets/           # App icons, colors
```

## How It Works

### Screen Unlock Detection

DailyWisdom uses `DistributedNotificationCenter` to listen for the `com.apple.screenIsUnlocked` notification, which macOS broadcasts when the user unlocks their screen.

```swift
DistributedNotificationCenter.default().addObserver(
    self,
    selector: #selector(screenDidUnlock),
    name: Notification.Name("com.apple.screenIsUnlocked"),
    object: nil
)
```

### Floating Panel

The quote window uses `NSPanel` with specific configuration to appear above other windows without stealing focus:

- `.nonactivatingPanel` style mask – Won't activate the app or steal focus
- `.floating` window level – Appears above normal windows
- `.canJoinAllSpaces` collection behavior – Visible on all desktop spaces

### Quote Selection Algorithm

Quotes are selected using a weighted algorithm that:
1. Filters by enabled categories
2. Prioritizes never-seen quotes (`viewCount == 0`)
3. For seen quotes, weights by `daysSinceLastShown / viewCount`

This ensures variety while still allowing favorites to occasionally reappear.

## Customization

### Adding Custom Quotes

Edit `DailyWisdom/DailyWisdom/Resources/quotes.json`:

```json
{
  "id": "custom-1",
  "text": "Your custom quote here.",
  "author": "Author Name",
  "category": "wisdom"
}
```

Valid categories: `mental-model`, `stoicism`, `leadership`, `focus`, `growth`, `strategy`, `business`, `wisdom`

### Modifying Display Duration

Default is 15 seconds. Users can adjust from 5-30 seconds in Settings, or modify the default in `Constants.swift`:

```swift
static let defaultDisplayDuration: TimeInterval = 15.0
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Quote Contributions

We especially welcome high-quality quote contributions! When adding quotes:
- Ensure accurate attribution
- Verify the quote is correctly worded
- Choose the most appropriate category
- Avoid duplicates

## Privacy

DailyWisdom respects your privacy:
- **No network requests** – Works entirely offline
- **No analytics** – No tracking or telemetry
- **No accounts** – No sign-up required
- **Local storage only** – All data stays on your device

See [PRIVACY.md](PRIVACY.md) for our full privacy policy.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Quote sources include works from various philosophers, entrepreneurs, and thought leaders
- Built with SwiftUI and SwiftData
- Inspired by the practice of starting each day with intentional reflection
- This entire project was built with the help of [Claude](https://claude.ai) by Anthropic – from architecture and implementation to testing and CI/CD. Thank you, Claude!

## Support

- **Issues**: [GitHub Issues](https://github.com/rockywuest/DailyWisdom/issues)
- **Discussions**: [GitHub Discussions](https://github.com/rockywuest/DailyWisdom/discussions)

---

Made with contemplation by [Rocky Wuest](https://github.com/rockywuest)
