//
//  Renderer.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/27/24.
//

import MetalKit

@MainActor
final class SlimeRenderer: NSObject, MTKViewDelegate {
    let numberOfAgents = 100000;
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let finalRenderPipelineState: MTLRenderPipelineState
    let quadVertexBuffer: MTLBuffer
    let agentBuffer: MTLBuffer
    let firstComputePipelineState: MTLComputePipelineState
    let secondComputePipelineState: MTLComputePipelineState
    
    var settings = Settings(wanderStrength: 0, speed: 0, rotationAngle: 0)
    
    override init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Default GPU")
        }
        self.device = device
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Could not create Command Queue")
        }
        commandQueue.label = "Command Queue"
        self.commandQueue = commandQueue
        
        let finalRenderVertexDescriptor = Vertex.buildDefaultVertexDescriptor()
        
        let library = device.makeDefaultLibrary()!
        
        let finalRenderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        finalRenderPipelineDescriptor.vertexFunction = library.makeFunction(name: "finalRenderVsh")!
        finalRenderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "finalRenderFsh")!
        finalRenderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.mainColorFormat
        finalRenderPipelineDescriptor.vertexDescriptor = finalRenderVertexDescriptor
        finalRenderPipelineDescriptor.label = "Final Render Pipeline"
        
        do {
            let pipelineState = try device.makeRenderPipelineState(descriptor: finalRenderPipelineDescriptor)
            self.finalRenderPipelineState = pipelineState
        } catch let error {
            fatalError("Could not create Render Pipeline State: \(error.localizedDescription)")
        }
        
        self.quadVertexBuffer = device.makeBuffer(bytes: Vertex.quadVertices, length: MemoryLayout<Vertex>.stride * Vertex.quadVertices.count, options: [])!
        
        self.agentBuffer = Agent.makeAgents(count: numberOfAgents, device: self.device)
        
        do {
            let computePipelineDescriptor = MTLComputePipelineDescriptor()
            computePipelineDescriptor.label = "Update and Draw Agents Compute Pipeline Descriptor"
            computePipelineDescriptor.computeFunction = library.makeFunction(name: "updateAgents")!
            let computePipelineState = try device.makeComputePipelineState(descriptor: computePipelineDescriptor, options: [])
            self.firstComputePipelineState = computePipelineState.0
        } catch let error {
            fatalError("Could not create Compute Pipeline State: \(error)")
        }
        
        do {
            let computePipelineDescriptor = MTLComputePipelineDescriptor()
            computePipelineDescriptor.label = "Blur and Fade Compute Pipeline Descriptor"
            computePipelineDescriptor.computeFunction = library.makeFunction(name: "blurAndFade")!
            let computePipelineState = try device.makeComputePipelineState(descriptor: computePipelineDescriptor, options: [])
            self.secondComputePipelineState = computePipelineState.0
        } catch let error {
            fatalError("Could not create Compute Pipeline State: \(error)")
        }
        
        MyLibrary.Slime.textures.load(device: device)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func updateSettings(wanderStrength: Float, speed: Float, rotationAngle: Float) {
        self.settings = Settings(wanderStrength: wanderStrength, speed: speed, rotationAngle: rotationAngle)
    }
    
    func draw(in view: MTKView) {
        if view.currentDrawable != nil && view.currentRenderPassDescriptor != nil {
            
            guard let commandBuffer = commandQueue.makeCommandBuffer() else {
                fatalError("Could not create Command Buffer")
            }
            commandBuffer.label = "Command Buffer"
            
            guard let firstBlitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else {
                fatalError("Could not create Blit Encoder")
            }
            firstBlitCommandEncoder.label = "First Blit Encoder"
            firstBlitCommandEncoder.copy(from: MyLibrary.Slime.textures[.color], to: MyLibrary.Slime.textures[.firstInput])
            firstBlitCommandEncoder.endEncoding()
            
            
            guard let firstComputeCommandEncoder = commandBuffer.makeComputeCommandEncoder() else {
                fatalError("Could not create Compute Encoder")
            }
            firstComputeCommandEncoder.label = "Agent Compute Encoder"
            firstComputeCommandEncoder.setComputePipelineState(firstComputePipelineState)
            firstComputeCommandEncoder.setBuffer(agentBuffer, offset: 0, index: 0)
            firstComputeCommandEncoder.setBytes(&settings, length: MemoryLayout<Settings>.stride, index: 1)
            var a = simd_int1(Preferences.sizeOfScreen)
            
            firstComputeCommandEncoder.setBytes(&a, length: MemoryLayout<simd_int1>.stride, index: 2)
            firstComputeCommandEncoder.setTexture(MyLibrary.Slime.textures[.firstInput], index: 0)
            firstComputeCommandEncoder.setTexture(MyLibrary.Slime.textures[.color], index: 1)
            firstComputeCommandEncoder.dispatchThreadgroups(MTLSize(width: numberOfAgents, height: 1, depth: 1), threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: 1))
            
            firstComputeCommandEncoder.endEncoding()
            
            
            guard let secondBlitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else {
                fatalError("Could not create Blit Encoder")
            }
            secondBlitCommandEncoder.label = "Second Blit Encoder"
            secondBlitCommandEncoder.copy(from: MyLibrary.Slime.textures[.color], to: MyLibrary.Slime.textures[.secondInput])
            secondBlitCommandEncoder.endEncoding()
            
            
            guard let secondComputeCommandEncoder = commandBuffer.makeComputeCommandEncoder() else {
                fatalError("Could not create Compute Encoder")
            }
            secondComputeCommandEncoder.label = "Blur and fade Compute Encoder"
            secondComputeCommandEncoder.setComputePipelineState(secondComputePipelineState)
            secondComputeCommandEncoder.setTexture(MyLibrary.Slime.textures[.secondInput], index: 0)
            secondComputeCommandEncoder.setTexture(MyLibrary.Slime.textures[.color], index: 1)
            var b = simd_int1(Preferences.sizeOfScreen)
            
            secondComputeCommandEncoder.setBytes(&b, length: MemoryLayout<simd_int1>.stride, index: 2)
            secondComputeCommandEncoder.dispatchThreadgroups(MTLSize(width: Int(Preferences.viewSize.width), height: Int(Preferences.viewSize.height), depth: 1), threadsPerThreadgroup: MTLSize(width: 8, height: 8, depth: 1))
            
            secondComputeCommandEncoder.endEncoding()
            
            
            guard let finalRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!) else {
                fatalError("Could not create Render Encoder")
            }
            finalRenderCommandEncoder.label = "Final render encoder"
            finalRenderCommandEncoder.setRenderPipelineState(finalRenderPipelineState)
            finalRenderCommandEncoder.setVertexBuffer(quadVertexBuffer, offset: 0, index: 0)
            finalRenderCommandEncoder.setFragmentTexture(MyLibrary.Slime.textures[.color], index: 0)
            finalRenderCommandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: Vertex.quadVertices.count)
            
            finalRenderCommandEncoder.endEncoding()
            
            commandBuffer.present(view.currentDrawable!)
            commandBuffer.commit()
        }
    }
}
