//
//  Agent.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/5/24.
//

import simd
import Metal

@MainActor
func makeAgents(count: Int, device: MTLDevice) -> MTLBuffer {
    var agents: [Agent] = []
    for i in 0..<count {
        var position = simd_float3.zero
        let isRed = i >= count / 3
        
        let range = isRed ? 0...Preferences.sizeOfScreen.float() : Preferences.sizeOfScreen.float() * 2...Preferences.sizeOfScreen.float() * 3
        let disFromCenter = Float.random(in: range)
        let rot = Float.random(in: 0...Float.pi * 2)
        
        position.x = (cos(rot) * disFromCenter) + (Preferences.viewSize.width.float() / 2)
        position.y = (sin(rot) * disFromCenter) + (Preferences.viewSize.height.float() / 2)
            
        let angle = atan2f(Preferences.viewSize.width.float() / 2 - position.x, Preferences.viewSize.height.float() / 2 - position.y)
        
        let species: simd_float4 = isRed ? .red : .blue
            
        agents.append(Agent(position: position, angle: angle, speciesMask: species))
    }
    guard let buffer = device.makeBuffer(bytes: agents, length: MemoryLayout<Agent>.stride * agents.count, options: []) else {
        fatalError("Couldn't make agents buffer")
    }
    buffer.label = "Agents"
    return buffer
}
