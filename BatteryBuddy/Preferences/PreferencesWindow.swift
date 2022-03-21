//
//  PreferencesWindow.swift
//  BatteryBuddy
//
//  Created by 苏晟 on 2022/3/8.
//

import Preferences

extension Preferences.PaneIdentifier {
    static let general = Self("general")
}

final class PreferencesWindow {
    
    private lazy var preferences: [PreferencePane] = [
        GeneralPreferenceViewController()
    ]

    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: .toolbarItems,
        animated: true,
        hidesToolbarForSingleItem: true
    )
}
