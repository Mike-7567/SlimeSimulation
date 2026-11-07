//
//  ContentView.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @Binding var settings: SettingsStruct
    
    var body: some View {
        ZStack {
            Color.black
            SlimeSimulationOutputView(settings: $settings)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                .border(.quaternary)
        }
    }
}

//#Preview {
//    ContentView()
//}
