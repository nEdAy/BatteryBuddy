//
//  BatteryBuddyApp.swift
//  BatteryBuddy
//
//  Created by 苏晟 on 2022/2/23.
//

import SwiftUI
import Sentry

@main
struct BatteryBuddyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var updaterViewModel = UpdaterViewModel()

    init() {
        SentrySDK.start { options in
            options.dsn = "https://3b8edac83c63433b8fc693c3df94606c@o1149022.ingest.sentry.io/6241838"
            options.debug = true // Enabled debug when first installing is always helpful

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
            options.enableNetworkTracking = true
            options.enableFileIOTracking = true
            options.enableAutoPerformanceTracking = true
        }
    }
    
    var body: some Scene {
        Settings {
          EmptyView()
        } .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updaterViewModel: updaterViewModel)
            }
        }
    }
}
