//
//  Vertex.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/28/24.
//

import MetalKit

@MainActor
struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var texcoords: SIMD2<Float>
    
    static let quadVertices: [Vertex] = [
        Vertex(position: simd_float3(1, 1, 1), color: .black, texcoords: simd_float2(1, 1)),
        Vertex(position: simd_float3(1, -1, 1), color: .black, texcoords: simd_float2(1, 0)),
        Vertex(position: simd_float3(-1, 1, 1), color: .black, texcoords: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, -1, 1), color: .black, texcoords: simd_float2(0, 0))
    ]
    
    static func buildDefaultVertexDescriptor() -> MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].bufferIndex = 0
        descriptor.attributes[0].offset = 0
        
        descriptor.attributes[1].format = .float4
        descriptor.attributes[1].bufferIndex = 0
        descriptor.attributes[1].offset = MemoryLayout<Vertex>.offset(of: \.color)!
        
        descriptor.attributes[2].format = .float2
        descriptor.attributes[2].bufferIndex = 0
        descriptor.attributes[2].offset = MemoryLayout<Vertex>.offset(of: \.texcoords)!
        
        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return descriptor
    }
}
