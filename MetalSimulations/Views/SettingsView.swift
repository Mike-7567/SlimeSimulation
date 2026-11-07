//
//  Settings.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/6/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: SettingsStruct
    
    var body: some View {
        VStack {
            Button("Reset settings") {
                settings = DEFAULT_SETTINGS
            }
            Text("Wander Strength")
            Slider(value: $settings.wanderStrength, in: -3...3) {
                Text("\($settings.wanderStrength.wrappedValue)")
            }
            
            Text("Speed")
            Slider(value: $settings.speed, in: -3...5) {
                Text("\($settings.speed.wrappedValue)")
                
            }
            
            Text("Rotation Angle")
            Slider(value: $settings.rotationAngle, in: -3...3) {
                Text("\($settings.rotationAngle.wrappedValue)")
            }
        }
    }
}
