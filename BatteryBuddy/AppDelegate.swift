//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by 苏晟 on 2022/2/23.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    private var statusItem: StatusBarItem?
    private var battery: BatteryService?

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserPreferences.registerDefaults()
        StatusNotification.requestAuthorization()
        do {
            battery = try BatteryService()
            statusItem = StatusBarItem(forBattery: battery, forTarget: self)
            statusItem?.update(batteryInfo: battery)
            // Register the ApplicationController as observer for power source and user preference changes
            UserDefaults.standard.addObserver(self, forKeyPath: PreferencesKey.showTime.rawValue, options: .new, context: nil)
            UserDefaults.standard.addObserver(self, forKeyPath: PreferencesKey.hideMenubarInfo.rawValue, options: .new, context: nil)
            UserDefaults.standard.addObserver(self, forKeyPath: PreferencesKey.hideBatteryIcon.rawValue, options: .new, context: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(powerSourceChanged(_:)),
                                                   name: NSNotification.Name(rawValue: powerSourceChangedNotification),
                                                   object: nil)
        } catch {
            statusItem = StatusBarItem(forError: error as? BatteryError, forTarget: self)
        }
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
        print("Application will terminate.")
    }

    // 用户点击弹窗后的回调
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("The notification was clicked.")
        completionHandler()
    }

    // 配置通知发起时的行为 banner -> 显示弹窗, sound -> 播放提示音
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // MARK: Public

    /// This message is sent to the receiver, when a powerSourceChanged message was posted. The receiver
    /// must be registered as an observer for powerSourceChangedNotification's.
    ///
    /// - parameter sender: The object that posted powerSourceChanged message.
    @objc public func powerSourceChanged(_: AnyObject) {
        statusItem?.update(batteryInfo: battery)
        if let notification = StatusNotification(forState: battery?.state) {
            notification.postNotification()
        }
    }

    // MARK: Internal

    /// This message is sent to the receiver when the value at the specified key path relative to the given object
    /// has changed. The receiver must be registered as an observer for the specified keyPath and object.
    ///
    /// - parameter keyPath: The key path, relative to object, to the value that has changed.
    /// - parameter object: The source object of the key path.
    /// - parameter change: A dictionary that describes the changes that have been made to
    ///                     the value of the property at the key path keyPath relative to object.
    ///                     Entries are described in Change Dictionary Keys.
    /// - parameter context: The value that was provided when the receiver was registered to receive key-value
    ///                      observation notifications.
    override func observeValue(forKeyPath _: String?,
                               of _: Any?,
                               change _: [NSKeyValueChangeKey: Any]?,
                               context _: UnsafeMutableRawPointer?) {
        statusItem?.update(batteryInfo: battery)
    }
}
