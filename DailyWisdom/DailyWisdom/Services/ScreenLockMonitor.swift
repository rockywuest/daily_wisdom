import Foundation

protocol ScreenLockMonitorDelegate: AnyObject {
    func screenDidLock()
    func screenDidUnlock()
}

final class ScreenLockMonitor {
    private weak var delegate: ScreenLockMonitorDelegate?
    private var isMonitoring = false

    init(delegate: ScreenLockMonitorDelegate? = nil) {
        self.delegate = delegate
    }

    func setDelegate(_ delegate: ScreenLockMonitorDelegate) {
        self.delegate = delegate
    }

    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenDidLock),
            name: Notification.Name("com.apple.screenIsLocked"),
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenDidUnlock),
            name: Notification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screensaverDidStart),
            name: Notification.Name("com.apple.screensaver.didstart"),
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screensaverDidStop),
            name: Notification.Name("com.apple.screensaver.didstop"),
            object: nil
        )

        print("[ScreenLockMonitor] Started monitoring screen lock events")
    }

    func stopMonitoring() {
        guard isMonitoring else { return }
        isMonitoring = false
        DistributedNotificationCenter.default().removeObserver(self)
        print("[ScreenLockMonitor] Stopped monitoring screen lock events")
    }

    @objc private func screenDidLock(_ notification: Notification) {
        print("[ScreenLockMonitor] Screen locked")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.screenDidLock()
        }
    }

    @objc private func screenDidUnlock(_ notification: Notification) {
        print("[ScreenLockMonitor] Screen unlocked")
        // Add a small delay to ensure the desktop is fully visible
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Defaults.unlockDelay) { [weak self] in
            self?.delegate?.screenDidUnlock()
        }
    }

    @objc private func screensaverDidStart(_ notification: Notification) {
        print("[ScreenLockMonitor] Screensaver started")
    }

    @objc private func screensaverDidStop(_ notification: Notification) {
        print("[ScreenLockMonitor] Screensaver stopped")
        // Treat screensaver stop as potential unlock
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Defaults.unlockDelay) { [weak self] in
            self?.delegate?.screenDidUnlock()
        }
    }

    deinit {
        stopMonitoring()
    }
}
