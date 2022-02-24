//
//  BatteryBuddyApp.swift
//  BatteryBuddy
//
//  Created by 苏晟 on 2022/2/23.
//

import SwiftUI

@main
struct BatteryBuddyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
          EmptyView()
        }
    }
}
