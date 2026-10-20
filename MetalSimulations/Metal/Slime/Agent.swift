//
//  Agent.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/5/24.
//

import simd
import Metal

@MainActor
struct Agent {
    var position: simd_float3
    var angle: Float
    
    init(position: simd_float3, angle: Float) {
        self.position = position
        self.angle = angle
    }
    
    static func makeAgents(count: Int, device: MTLDevice) -> MTLBuffer {
        var agents: [Agent] = []
        for _ in 0..<count {
            var position = simd_float3.zero
            position.x = Float.random(in: 1...Preferences.viewSize.width.float() - 1)
            position.y = Float.random(in: 1...Preferences.viewSize.height.float() - 1)
            
            position.x = Preferences.viewSize.width.float() / 2
            position.y = Preferences.viewSize.height.float() / 2
            
            var angle = atan2f(Preferences.viewSize.width.float() / 2 - position.x, Preferences.viewSize.height.float() / 2 - position.y)
            
            agents.append(Agent(position: position, angle: angle))
        }
        guard let buffer = device.makeBuffer(bytes: agents, length: MemoryLayout<Agent>.stride * agents.count, options: []) else {
            fatalError("Couldn't make agents buffer")
        }
        buffer.label = "Agents"
        return buffer
    }
}
