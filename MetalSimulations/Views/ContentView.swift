//
//  ContentView.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @State var wanderStrength: Float = 0.1
    @State var speed: Float = 2
    @State var rotationAngle: Float = 1.25
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                SlimeSimulationOutputView(wanderStrength: $wanderStrength, speed: $speed, rotationAngle: $rotationAngle)
                    .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                    .border(Color.white)
                
                HStack {
                    Text("Wander Strength")
                    Slider(value: $wanderStrength, in: -3...3) {
                        Text("\($wanderStrength.wrappedValue)")
                    }
                    
                    Text("Speed")
                    Slider(value: $speed, in: -3...5) {
                        Text("\($speed.wrappedValue)")
                        
                    }
                    
                    Text("Rotation Angle")
                    Slider(value: $rotationAngle, in: -3...3) {
                        Text("\($rotationAngle.wrappedValue)")
                    }
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
