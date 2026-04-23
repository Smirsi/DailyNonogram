import UserNotifications

/// Manages local daily reminder notifications.
final class NotificationManager: @unchecked Sendable {

    nonisolated(unsafe) static let shared = NotificationManager()
    private init() {}

    private let dailyNotificationID = "daily_nonogram_reminder"
    private let enabledKey = "notificationsEnabled"

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: enabledKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: enabledKey)
            if newValue { scheduleDailyNotification() } else { cancelNotifications() }
        }
    }

    /// Requests notification permission and schedules the daily reminder if enabled.
    func requestPermissionAndScheduleIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            if UserDefaults.standard.object(forKey: self.enabledKey) == nil {
                // First launch: enable by default
                UserDefaults.standard.set(true, forKey: self.enabledKey)
            }
            if self.isEnabled {
                self.scheduleDailyNotification()
            }
        }
    }

    func scheduleDailyNotification() {
        cancelNotifications()

        let content = UNMutableNotificationContent()
        content.title = "Daily Nonogram"
        content.body = "Dein Nonogramm für heute ist bereit 🎯"
        content.sound = .default

        var components = DateComponents()
        components.hour = 8
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: dailyNotificationID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyNotificationID])
    }
}
