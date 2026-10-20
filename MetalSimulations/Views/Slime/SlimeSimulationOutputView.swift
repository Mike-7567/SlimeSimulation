//
//  SimulationOutputView.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

import SwiftUI
import MetalKit

struct SlimeSimulationOutputView: NSViewRepresentable {
    @State var renderer = SlimeRenderer()
    
    @Binding var wanderStrength: Float
    @Binding var speed: Float
    @Binding var rotationAngle: Float
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        
        view.device = renderer.device
        view.delegate = renderer
        view.preferredFramesPerSecond = 60
        view.colorPixelFormat = Preferences.mainColorFormat
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        renderer.updateSettings(wanderStrength: wanderStrength, speed: speed, rotationAngle: rotationAngle)
    }
    
    
}
