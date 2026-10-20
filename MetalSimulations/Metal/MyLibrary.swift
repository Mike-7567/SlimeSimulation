//
//  Library.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/5/24.
//

import Foundation
@preconcurrency import Metal
import MetalKit

@MainActor
class MyLibrary {
    
    @MainActor
    class Slime {
        static let textures = TexturesForSlimeSimulation()
    }
}

@MainActor
class TexturesForSlimeSimulation {
    enum SlimeTextureType {
        case firstInput
        case firstOutput
        case secondInput
        case secondOutput
        case noise
        case color
    }
    private var firstInput: MTLTexture?
    private var firstOutput: MTLTexture?
    private var secondInput: MTLTexture?
    private var secondOutput: MTLTexture?
    private var noiseTexture: MTLTexture?
    private var colorTexture: MTLTexture?
    
    func load(device: MTLDevice) {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: Preferences.mainColorFormat, width: Int(Preferences.viewSize.width), height: Int(Preferences.viewSize.height), mipmapped: false)
        textureDescriptor.usage = [.shaderRead, .shaderWrite]
        
        firstInput = device.makeTexture(descriptor: textureDescriptor)
        firstInput?.label = "First Input"
        firstOutput = device.makeTexture(descriptor: textureDescriptor)
        firstOutput?.label = "First Output"
        secondInput = device.makeTexture(descriptor: textureDescriptor)
        secondInput?.label = "Second Input"
        secondOutput = device.makeTexture(descriptor: textureDescriptor)
        secondOutput?.label = "Second Output"
        colorTexture = device.makeTexture(descriptor: textureDescriptor)
        colorTexture?.label = "Color"
        
        let textureLoader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: "noise", withExtension: "png")!
        let noise = try! textureLoader.newTexture(URL: url)
        noiseTexture = noise
        noiseTexture?.label = "Noise"
    }
    
    subscript (type: SlimeTextureType) -> MTLTexture {
        switch type {
        case .firstInput: return firstInput!
        case .firstOutput: return firstOutput!
        case .secondInput: return secondInput!
        case .secondOutput: return secondOutput!
        case .noise: return noiseTexture!
        case .color: return colorTexture!
        }
    }
}
