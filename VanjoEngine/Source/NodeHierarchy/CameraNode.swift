//
//  CameraNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation

class CameraNode: Node {
    
    var fov: Float = 90 {
        didSet {
            updateProjectionMatrix()
        }
    }
    
    var aspectRatio: Float {
        didSet {
            updateProjectionMatrix()
        }
    }
    
    init(aspectRatio: Float) {
        self.aspectRatio = aspectRatio
    }
    
    override func update(deltaTime: Float) {
        var identity = matrix_identity_float4x4
        
        identity.translation(vector: position)
        identity.rotate(angle: rotation)
        identity.scale(vector: scale)
        identity.columns.3.z = -1.0
        
        uniforms.viewMatrix = identity.inverse
        updateProjectionMatrix()
    }
    
    private func updateProjectionMatrix() {
        uniforms.projectionMatrix = projectionMatrix(projectionFov: fov.radians, near: 0.001, far: 100.0, aspect: aspectRatio)
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
