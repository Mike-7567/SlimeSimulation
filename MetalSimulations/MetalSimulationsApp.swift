//
//  MetalSimulationsApp.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

import SwiftUI

let DEFAULT_SETTINGS = SettingsStruct(wanderStrength: 0.1, speed: 2, rotationAngle: 1.25)

@main
struct MetalSimulationsApp: App {
    @State var settings: SettingsStruct = DEFAULT_SETTINGS
    
    var body: some Scene {
        WindowGroup {
            ContentView(settings: $settings)
        }
        Settings {
            SettingsView(settings: $settings)
        }
    }
}
