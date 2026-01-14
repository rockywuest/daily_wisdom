import Foundation

enum Constants {
    static let appName = "DailyWisdom"
    static let bundleIdentifier = "com.rockywuest.DailyWisdom"

    enum Defaults {
        static let displayDuration: TimeInterval = 15.0
        static let showOnUnlock = true
        static let unlockDelay: TimeInterval = 0.5
    }

    enum Window {
        static let width: CGFloat = 600
        static let height: CGFloat = 400
        static let cornerRadius: CGFloat = 20
    }

    enum UserDefaultsKeys {
        static let hasImportedQuotes = "hasImportedQuotes"
        static let displayDuration = "displayDuration"
        static let showOnUnlock = "showOnUnlock"
        static let enabledCategories = "enabledCategories"
        static let launchAtLogin = "launchAtLogin"
    }

    enum Notifications {
        static let showQuote = Notification.Name("com.dailywisdom.showQuote")
        static let hideQuote = Notification.Name("com.dailywisdom.hideQuote")
    }
}
