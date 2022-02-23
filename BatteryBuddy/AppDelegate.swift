//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by 苏晟 on 2022/2/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let statusBarButton = statusItem?.button {
            statusBarButton.image = NSImage(named: NSImage.Name("Unknown"))
        }
    }
}
