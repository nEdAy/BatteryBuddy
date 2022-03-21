//
// StatusIcon.swift
// Apple Juice
// https://github.com/raphaelhanneken/apple-juice
//

import Cocoa

final class StatusBarItem: NSObject {
    private let statusItem: NSStatusItem?
    private var statusBarIcon: StatusBarIcon?

    /// Creates a new battery status bar item object.
    ///
    /// - parameter action: The action to be triggered, when the user clicks on the status bar item.
    /// - parameter target: The target that implements the supplied action.
    init(forBattery battery: BatteryService?, forTarget target: AnyObject?) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusBarButton = statusItem?.button {
            statusBarButton.image = NSImage(named: NSImage.Name("Happy"))
            statusBarButton.target = target
        }
        statusItem?.menu = StatusItemMenu().statusItemMenu
        statusBarIcon = StatusBarIcon()
        super.init()
    }

    /// Creates a status bar item object for a specific error.
    ///
    /// - parameter error: The error that occured.
    /// - parameter action: The action to be triggered, when the user clicks on the status bar item.
    /// - parameter target: The target that implements the supplied action.
    convenience init(forError error: BatteryError?, forTarget target: AnyObject?) {
        self.init(forBattery: nil, forTarget: target)
        guard let statusBarButton = statusItem?.button else {
            return
        }
        statusBarButton.image = statusBarIcon?.drawBatteryImage(forError: error)
    }

    // MARK: Public

    /// Update the status bar items title and icon.
    ///
    /// - parameter battery: The battery object, to update the status bar item for.
    public func update(batteryInfo battery: BatteryService?) {
        setBatteryIcon(battery)
        setTitle(battery)
    }

    // MARK: Private

    /// Sets the status bar item's battery icon.
    ///
    /// - parameter batter: The battery to render the status bar icon for.
    private func setBatteryIcon(_ battery: BatteryService?) {
        guard let batteryState = battery?.state,
              let statusBarButton = statusItem?.button
            else {
            return
        }
        if UserPreferences.hideBatteryIcon {
            statusBarButton.image = nil
        } else {
            statusBarButton.image = statusBarIcon?.drawBatteryImage(forStatus: batteryState)
            statusBarButton.imagePosition = .imageRight
        }
    }

    /// Sets the status bar item's title
    ///
    /// - parameter battery: The battery to build the status bar title for.
    private func setTitle(_ battery: BatteryService?) {
        guard let statusBarButton = statusItem?.button,
              let percentage = battery?.percentage.formatted,
              let timeRemaining = battery?.timeRemaining.formatted
            else {
            return
        }
        let titleAttributes = [NSAttributedString.Key.font: NSFont.menuBarFont(ofSize: 11.0)]
        if UserPreferences.showTime {
            statusBarButton.attributedTitle = NSAttributedString(string: timeRemaining, attributes: titleAttributes)
        } else {
            statusBarButton.attributedTitle = NSAttributedString(string: percentage, attributes: titleAttributes)
        }
        if UserPreferences.hideMenubarInfo {
            statusBarButton.attributedTitle = NSAttributedString(string: "")
        }
    }
}
