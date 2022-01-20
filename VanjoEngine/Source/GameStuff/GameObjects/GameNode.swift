//
//  GameNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import MetalKit


protocol Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder?)
}

protocol Dynamicable: Nodable {
    var mass: Float { get set }
    var velocity: simd_float2 { get set }
    
    func updatePhysicBody(deltaTime: Float)
}

extension Dynamicable {
    func updatePhysicBody(deltaTime: Float) {
        
        let G: Float = 9.81
        
        let force = simd_float2(0, mass * -G)
        let acceleration = simd_float2(force.x / mass, force.y / mass)
        
        velocity.x += acceleration.x * deltaTime
        velocity.y += acceleration.y * deltaTime
        
        position.x += velocity.x * deltaTime
        position.y += velocity.y * deltaTime
    }
}


class GameNode: Node, Renderable, Dynamicable {
    
    var mesh: BasicMeshProtocol
    
    var mass: Float
    var velocity: simd_float2 = simd_float2(0, 0)
    
    init(mesh: BasicMeshProtocol, mass: Float = 1.0) {
        self.mesh = mesh
        self.mass = mass
    }
    
    override func update(deltaTime: Float) {
        var modelMatrix = matrix_identity_float4x4
        
        updatePhysicBody(deltaTime: deltaTime)
        
        modelMatrix.translation(vector: position)
        modelMatrix.rotate(angle: rotation)
        modelMatrix.scale(vector: scale)
        
        uniforms.modelMatrix = modelMatrix // TRS or (visa-versa SRT) - this is the sequence!
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder?) {
        let buffer = VanjoEngine.shared.device.makeBuffer(bytes: mesh.vertices, length: mesh.length, options: [])
        let uniformBuffer = VanjoEngine.shared.device.makeBuffer(bytes: &uniforms, length: MemoryLayout<Uniforms>.stride, options: [])
        
        let rplsBuilder = RenderPipelineStateBuilder()
        
        renderEncoder?.setRenderPipelineState(rplsBuilder.getPipelineState(for: .basic)!)
        
        renderEncoder?.setVertexBuffer(buffer, offset: 0, index: 0)
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertices.count
        )
    }
}
