//
// StatusNotification.swift
// Apple Juice
// https://github.com/raphaelhanneken/apple-juice
//

import UserNotifications

/// Posts user notifications about the current charging status.
struct StatusNotification {
    // MARK: Lifecycle

    /// Initializes a new StatusNotification.
    ///
    /// - parameter key: The notification key which to display a user notification for.
    /// - returns: An optional StatusNotification; Return nil when the notificationKey
    ///            is invalid or nil.
    init?(forState state: BatteryState?) {
        guard let state = state, state != .charging(percentage: Percentage(numeric: 0)) else {
            return nil
        }
        guard let key = NotificationKey(rawValue: state.percentage.numeric ?? 0), key != .invalid else {
            return nil
        }
        notificationKey = key
    }

    // MARK: Internal

    /// Explicitly request authorization in context
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error = error {
                // Handle the error here.
                print(error)
            }
            // Enable or disable features based on the authorization.
        }
    }

    /// Present a notification for the current battery status to the user
    func postNotification() {
        if shouldPresentNotification() {
            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                                                content: createUserNotification(),
                                                trigger: nil)
            // Schedule the request with the system.
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // Handle the error here.
                    print(error)
                }
            }
            UserPreferences.lastNotified = notificationKey
        }
    }

    // MARK: Private

    /// The current notification's key.
    private let notificationKey: NotificationKey

    /// Check whether to present a notification to the user or not. Depending on the
    /// users preferences and whether the user already got notified about the current
    /// percentage.
    ///
    /// - returns: Whether to present a notification for the current battery percentage
    private func shouldPresentNotification() -> Bool {
        (notificationKey != UserPreferences.lastNotified
            && UserPreferences.notifications.contains(notificationKey))
    }

    /// Create a user notification for the current battery status
    ///
    /// - returns: The user notification to display
    private func createUserNotification() -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = getNotificationTitle()
        notification.body = getNotificationText()
        notification.sound = UNNotificationSound.default
        return notification
    }

    /// Get the corresponding notification title for the current battery state
    ///
    /// - returns: The notification title
    private func getNotificationTitle() -> String {
        if notificationKey == .hundredPercent {
            return NSLocalizedString("Charged Notification Title", comment: "")
        }
        return String.localizedStringWithFormat(NSLocalizedString("Low Battery Notification Title", comment: ""),
                                                formattedPercentage())
    }

    /// Get the corresponding notification text for the current battery state
    ///
    /// - returns: The notification text
    private func getNotificationText() -> String {
        if notificationKey == .hundredPercent {
            return NSLocalizedString("Charged Notification Message", comment: "")
        }
        return NSLocalizedString("Low Battery Notification Message", comment: "")
    }

    /// The current percentage, formatted according to the selected client locale, e.g.
    /// en_US: 42% fr_FR: 42 %
    ///
    /// - returns: The localised percentage
    private func formattedPercentage() -> String {
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.generatesDecimalNumbers = false
        percentageFormatter.localizesFormat = true
        percentageFormatter.multiplier = 1.0
        percentageFormatter.minimumFractionDigits = 0
        percentageFormatter.maximumFractionDigits = 0
        return percentageFormatter.string(from: notificationKey.rawValue as NSNumber)
            ?? "\(notificationKey.rawValue) %"
    }
}
