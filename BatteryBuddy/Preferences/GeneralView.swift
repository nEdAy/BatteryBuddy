//
//  GeneralView.swift
//  BatteryBuddy
//
//  Created by 苏晟 on 2022/2/23.
//

import LaunchAtLogin
import Preferences
import SwiftUI

/**
 Function wrapping SwiftUI into `PreferencePane`, which is mimicking view controller's default construction syntax.
 */
let GeneralPreferenceViewController: () -> PreferencePane = {
    /// Wrap your custom view into `Preferences.Pane`, while providing necessary toolbar info.
    let paneView = Preferences.Pane(
        identifier: .general,
        title: "General",
        toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
    ) {
        GeneralView()
    }
    return Preferences.PaneHostingController(pane: paneView)
}

/**
 The main view of “General” preference pane.
 */
struct GeneralView: View {
    @State private var isOn1 = true
    @State private var isOn2 = false
    @State private var isOn3 = true
    @State private var selection1 = 1
    @State private var selection2 = 0
    @State private var selection3 = 0
    private let contentWidth: Double = 450.0

    @State var value = 80.0

    var body: some View {
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "Permissions:") {
                Toggle("Allow user to administer this computer", isOn: $isOn1)
                Text("Administrator has root access to this machine.")
                    .preferenceDescription()
                LaunchAtLogin.Toggle {
                    Text("Launch at login")
                }
            }
            Preferences.Section(title: "电池:") {
                HStack { Image(systemName: "sun.max")
                    Slider(value: $value, in: 20
                        ... 100, step: 1) { item in
                        print(item)
                    }.accentColor(.pink).colorInvert()
                }
                .padding(.horizontal)
                .frame(minWidth: 250, maxWidth: 250)
                Text("Value: \(value)").font(Font.body.monospacedDigit())
            }
            Preferences.Section(title: "Notification:") {
                HStack {
                    Toggle("5%", isOn: $isOn1)
                    Toggle("10%", isOn: $isOn1)
                    Toggle("15%", isOn: $isOn1)
                    Toggle("20%", isOn: $isOn1)
                }
            }
            Preferences.Section(title: "Show scroll bars:") {
                Picker("", selection: $selection1) {
                    Text("When scrolling").tag(0)
                    Text("Always").tag(1)
                }
                .labelsHidden()
                .pickerStyle(RadioGroupPickerStyle())
            }
            Preferences.Section(label: {
                Toggle("Some toggle", isOn: $isOn3)
            }) {
                Picker("", selection: $selection2) {
                    Text("Automatic").tag(0)
                    Text("Manual").tag(1)
                }
                .labelsHidden()
                .frame(width: 120.0)
                Text("Automatic mode can slow things down.")
                    .preferenceDescription()
            }
            Preferences.Section(title: "Preview mode:") {
                Picker("", selection: $selection3) {
                    Text("Automatic").tag(0)
                    Text("Manual").tag(1)
                }
                .labelsHidden()
                .frame(width: 120.0)
                Text("Automatic mode can slow things down.")
                    .preferenceDescription()
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}

extension NSApplication {
    /// Relaunch the app.
    func relaunch() {
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.createsNewApplicationInstance = true
        NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: configuration) { _, _ in
            DispatchQueue.main.async {
                NSApp.terminate(nil)
            }
        }
    }
}
