//
//  StatusItemMenu.swift
//  BatteryBuddy
//
//  Created by 苏晟 on 2022/3/8.
//

import Cocoa
import MenuBuilder
import SwiftUI

class StatusItemMenu: NSObject, NSMenuDelegate {
    var statusItemMenu: NSMenu?

    override init() {
        super.init()
        constructMenu()
        statusItemMenu?.delegate = self
    }

    func menuWillOpen(_ menu: NSMenu) {
        updateBatteryInfoItem(menu.item(at: 0))
    }

    override func awakeFromNib() {
        do {
            batteryService = try BatteryService()
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    // MARK: Private

    private var batteryService: BatteryService?
    
    private var updaterViewModel = UpdaterViewModel()

    // MARK: - MenuConfig

    private func constructMenu() {
        statusItemMenu = NSMenu {
            MenuItem("StateMenuItemView")
            MenuItem("INHIBITED")
                .view(showsHighlight: false) {
                    InhibitedMenuItemView()
                }
            SeparatorItem()
            MenuItem("Notification") {
                for word in ["5%", "10%", "15%", "20%"] {
                    MenuItem(word)
                }
                SeparatorItem()
                for word in ["80%", "100%"] {
                    MenuItem(word)
                }
            }
            MenuItem("Preferences")
                .shortcut(",")
                .onSelect {
                    self.openPreferenceView(nil)
                }
            MenuItem("Check for Updates…")
                .disabled(!updaterViewModel.canCheckForUpdates)
                .onSelect {
                    self.updaterViewModel.checkForUpdates()
                }
            MenuItem("About")
                .onSelect {
                    NSApp.orderFrontStandardAboutPanel()
                }
            SeparatorItem()
            MenuItem("Quit")
                .shortcut("q")
                .onSelect {
                    NSApp.terminate(nil)
                }
        }
    }

    struct InhibitedMenuItemView: View {
        @State var value = 5.0
        var body: some View {
            HStack {
                Slider(value: $value, in: 0 ... 9, step: 1)
                Text("Value: \(value)").font(Font.body.monospacedDigit())
            }
            .padding(.horizontal)
            .frame(minWidth: 250)
        }
    }

    private func updateBatteryInfoItem(_ batteryInfoItem: NSMenuItem?) {
        guard let item = batteryInfoItem else {
            return
        }
        item.attributedTitle = getAttributedMenuItemTitle()
        if #available(OSX 11.0, *) {
            let hostingView = NSHostingView(rootView: MenuInfoView())
            hostingView.frame = NSRect(x: 0,
                                       y: 0,
                                       width: hostingView.intrinsicContentSize.width,
                                       height: hostingView.intrinsicContentSize.height)
            item.view = hostingView
        } else {
            item.attributedTitle = getAttributedMenuItemTitle()
        }
    }

    private func getAttributedMenuItemTitle() -> NSAttributedString {
        guard let capacity = batteryService?.capacity,
              let charge = batteryService?.charge,
              let amperage = batteryService?.amperage,
              let percentage = batteryService?.percentage,
              let timeRemaining = batteryService?.timeRemaining,
              let powerSource = batteryService?.powerSource
        else {
            return NSAttributedString(string: NSLocalizedString("Unknown", comment: "Information missing"))
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 3.0
        let remaining = UserPreferences.showTime ? percentage.formatted : timeRemaining.formatted
        let powerSourceLabel = NSMutableAttributedString(
            string: powerSource.localizedDescription,
            attributes: [.font: NSFont.menuFont(ofSize: 13.0), .paragraphStyle: paragraphStyle])
        let details = NSAttributedString(
            string: "\n\(remaining)  \(charge) / \(capacity) mAh (\(amperage) mA)",
            attributes: [.font: NSFont.menuFont(ofSize: 13.0)])
        powerSourceLabel.append(details)
        return powerSourceLabel
    }

    // MARK: - Actions

    @objc private func openPreferenceView(_ sender: Any?) {
        PreferencesWindow().preferencesWindowController.show()
    }
}
