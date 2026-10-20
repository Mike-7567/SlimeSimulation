//
//  Preferences.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 12/6/24.
//

import Foundation
import Metal

@MainActor
class Preferences {
    static let sizeOfScreen = 180
    
    static let mainColorFormat: MTLPixelFormat = .bgra8Unorm
    
    static let mainDepthFormat: MTLPixelFormat = .depth32Float
    
    static let mainStencilFormat: MTLPixelFormat = .stencil8
    
    static let viewSize = CGSize(width: 16*sizeOfScreen, height: 9*sizeOfScreen)
}
