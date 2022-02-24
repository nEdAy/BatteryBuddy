//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by 苏晟 on 2022/2/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let statusBarButton = statusItem?.button {
            statusBarButton.image = NSImage(named: NSImage.Name("Unknown"))
        }
        constructMenu()
    }

    // MARK: - Private

    // MARK: - MenuConfig

    func constructMenu() {
        let menu = NSMenu()

        let groupMenuItem = NSMenuItem()
        groupMenuItem.title = "Group"
        menu.addItem(groupMenuItem)

        menu.addItem(NSMenuItem(title: "About BatteryBuddy", action: #selector(AppDelegate.openAboutView(_:)), keyEquivalent: "a"))
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.openAboutView(_:)), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit BatteryBuddy", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    // MARK: - Actions

    @objc private func openAboutView(_ sender: Any?) {

    }
}
