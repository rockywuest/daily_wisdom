# Changelog

All notable changes to DailyWisdom will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-14

### Added
- Initial release of DailyWisdom
- 370+ carefully curated quotes across 8 categories:
  - Mental Models (54 quotes)
  - Stoicism (46 quotes)
  - Leadership (35 quotes)
  - Focus (53 quotes)
  - Growth (82 quotes)
  - Strategy (31 quotes)
  - Business (26 quotes)
  - Wisdom (43 quotes)
- Automatic quote display on Mac screen unlock
- Beautiful floating panel with vibrancy blur background
- Large, readable serif typography
- Auto-dismiss with customizable duration (5-30 seconds)
- Favorites system to save meaningful quotes
- Smart quote selection algorithm prioritizing unseen quotes
- Category filtering in settings
- Launch at login option
- Menubar interface with quick actions:
  - Show Quote Now
  - View Favorites
  - Access Settings
- Complete offline functionality
- SwiftData persistence for favorites and view history
- Privacy-first design with zero data collection

### Technical
- Built with SwiftUI and SwiftData
- Requires macOS 14.0 (Sonoma) or later
- App Sandbox enabled for Mac App Store distribution
- Uses DistributedNotificationCenter for screen unlock detection
- NSPanel with non-activating style for non-intrusive display

---

## Future Plans

- [ ] Widget support for desktop quotes
- [ ] Keyboard shortcut to show/dismiss quotes
- [ ] Quote sharing to social media
- [ ] Custom quote import from text files
- [ ] Additional quote categories
- [ ] Localization for additional languages
