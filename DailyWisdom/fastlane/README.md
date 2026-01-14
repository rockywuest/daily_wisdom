# Fastlane Configuration

This directory contains [fastlane](https://fastlane.tools) configuration for automated App Store submission.

## Setup

1. Install fastlane:
   ```bash
   brew install fastlane
   ```

2. Configure your credentials in `Appfile`:
   - Uncomment and set `apple_id`
   - Set `team_id` (Apple Developer Team ID)
   - Set `itc_team_id` (App Store Connect Team ID, if different)

3. Authenticate with App Store Connect:
   ```bash
   fastlane spaceauth -u your@email.com
   ```

## Available Lanes

| Lane | Description |
|------|-------------|
| `fastlane build` | Build the app for release |
| `fastlane release` | Build and upload to App Store Connect |
| `fastlane metadata` | Upload metadata only (no binary) |
| `fastlane screenshots` | Capture screenshots (requires UI tests) |
| `fastlane test` | Run tests |

## First-Time Setup

Before your first release:

1. **Create the app in App Store Connect:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Create a new macOS app
   - Bundle ID: `com.rockywuest.DailyWisdom`

2. **Add screenshots:**
   - Place screenshots in `screenshots/en-US/`
   - Required sizes: 1280x800, 1440x900, 2560x1600, 2880x1800

3. **Configure signing:**
   - Ensure you have a valid Distribution certificate
   - Create an App Store provisioning profile

## Metadata Structure

```
metadata/en-US/
├── name.txt              # App name (30 chars max)
├── subtitle.txt          # Subtitle (30 chars max)
├── description.txt       # Full description (4000 chars max)
├── keywords.txt          # Comma-separated (100 chars max)
├── promotional_text.txt  # Promotional text (170 chars max)
├── release_notes.txt     # What's New (4000 chars max)
├── privacy_url.txt       # Privacy policy URL
└── support_url.txt       # Support URL
```

## Tips

- Run `fastlane metadata` to test metadata upload before full release
- Use `fastlane precheck` to validate metadata before submission
- Keep `release_notes.txt` updated for each version
