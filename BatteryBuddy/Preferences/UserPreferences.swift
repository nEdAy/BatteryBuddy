//
// UserPreferences.swift
// Apple Juice
// https://github.com/raphaelhanneken/apple-juice
//

import Foundation

/// Manages the user preferences.
final class UserPreferences: NSObject {
    // MARK: Internal

    /// True if the user wants the remaining time to be displayed within the menu bar.
    static var showTime: Bool {
        userDefaults.bool(forKey: PreferencesKey.showTime.rawValue)
    }

    /// Hide all menu bar information
    static var hideMenubarInfo: Bool {
        userDefaults.bool(forKey: PreferencesKey.hideMenubarInfo.rawValue)
    }

    /// Hide all menu bar information
    static var hideBatteryIcon: Bool {
        userDefaults.bool(forKey: PreferencesKey.hideBatteryIcon.rawValue)
    }

    /// True if the user wants a notification at five percent.
    static var fivePercentNotification: Bool {
        userDefaults.bool(forKey: PreferencesKey.fivePercentNotification.rawValue)
    }

    /// True if the user wants a notification at ten percent.
    static var tenPercentNotification: Bool {
        userDefaults.bool(forKey: PreferencesKey.tenPercentNotification.rawValue)
    }

    /// True if the user wants a notification at fifteen percent.
    static var fifteenPercentNotification: Bool {
        userDefaults.bool(forKey: PreferencesKey.fifteenPercentNotification.rawValue)
    }

    /// True if the user wants a notification at twenty percent.
    static var twentyPercentNotification: Bool {
        userDefaults.bool(forKey: PreferencesKey.twentyPercentNotification.rawValue)
    }

    /// True if the user wants a notification at hundred percent.
    static var hundredPercentNotification: Bool {
        userDefaults.bool(forKey: PreferencesKey.hundredPercentNotification.rawValue)
    }

    /// Keeps the percentage the user was last notified.
    static var lastNotified: NotificationKey? {
        get {
            NotificationKey(rawValue: userDefaults.integer(forKey: PreferencesKey.lastNotification.rawValue))
        }
        set {
            guard let notificationKey = newValue else {
                return
            }
            userDefaults.set(notificationKey.rawValue, forKey: PreferencesKey.lastNotification.rawValue)
        }
    }

    /// A set of all percentages where the user is interested.
    static var notifications: Set<NotificationKey> {
        // Create an empty set.
        var result: Set<NotificationKey> = []
        // Check the users notification settings and
        // add enabled notifications to the result set.
        if fivePercentNotification {
            result.insert(.fivePercent)
        }
        if tenPercentNotification {
            result.insert(.tenPercent)
        }
        if fifteenPercentNotification {
            result.insert(.fifteenPercent)
        }
        if twentyPercentNotification {
            result.insert(.twentyPercent)
        }
        if hundredPercentNotification {
            result.insert(.hundredPercent)
        }
        return result
    }

    /// Register user defaults.
    static func registerDefaults() {
        let defaultPreferences = [
            PreferencesKey.showTime.rawValue: true,
            PreferencesKey.fivePercentNotification.rawValue: false,
            PreferencesKey.tenPercentNotification.rawValue: false,
            PreferencesKey.fifteenPercentNotification.rawValue: true,
            PreferencesKey.twentyPercentNotification.rawValue: false,
            PreferencesKey.hundredPercentNotification.rawValue: true,
            PreferencesKey.lastNotification.rawValue: 0,
            PreferencesKey.hideMenubarInfo.rawValue: false,
        ] as [String: Any]

        userDefaults.register(defaults: defaultPreferences)
    }

    // MARK: Private

    /// Holds a reference to the standard user defaults.
    private static let userDefaults = UserDefaults.standard
}
