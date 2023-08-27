//
//  CameraNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation

class CameraNode: Node {
    
    var viewMatrix: matrix_float4x4 {
        var identity = matrix_identity_float4x4
        identity.translation(vector: position)
        identity.rotate(angle: rotation)
        identity.scale(vector: scale)
        identity.columns.3.z = distance
        return identity.inverse
    }
    
    var projectionMatix: matrix_float4x4 {
        projectionMatrix(projectionFov: fov.radians, near: 0.001, far: 100.0, aspect: aspectRatio)
    }
    
    var fov: Float = 90
    
    var aspectRatio: Float
    
    var distance: Float = -3.0
    
    init(aspectRatio: Float) {
        self.aspectRatio = aspectRatio
		super.init(id: "camera")
    }
    
    private func projectionMatrix(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) -> matrix_float4x4 {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = lhs ? far / (far - near) : far / (near - far)
        let X = simd_float4(x, 0,  0,  0)
        let Y = simd_float4(0,  y,  0,  0)
        let Z = lhs ? simd_float4(0,  0,  z, 1) : simd_float4( 0,  0,  z, -1)
        let W = lhs ? simd_float4(0,  0,  z * -near,  0) : simd_float4( 0,  0,  z * near,  0)
        
        return matrix_float4x4(columns:(X, Y, Z, W))
     }
}
