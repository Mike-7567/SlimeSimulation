//
//  Extentions.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/29/24.
//

import Foundation
import simd

extension simd_float4 {
    static let black = simd_float4(0, 0, 0, 0)
    static let red = simd_float4(1, 0, 0, 1)
    static let green = simd_float4(0, 1, 0, 1)
    static let blue = simd_float4(0, 0, 1, 1)
    static let yellow = simd_float4(1, 1, 0, 1)
    static let white = simd_float4(1, 1, 1, 1)
}

extension CGFloat {
    static let one = CGFloat(1)
    
    func float() -> Float {
        return Float(self)
    }
}

extension Int {
    func float() -> Float {
        return Float(self)
    }
}
