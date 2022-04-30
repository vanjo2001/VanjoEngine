//
//  GameNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import MetalKit


protocol Renderable {
    var mesh: BasicMeshProtocol { get }
    
    func render(renderEncoder: MTLRenderCommandEncoder?)
}

protocol Dynamicable: Nodable {
    var mass: Float { get set }
    var velocity: simd_float2 { get set }
    
    func makeImpulse()
    
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
    
    func makeImpulse() {
        velocity.y = 3
        velocity.x = 1
        //velocity.y += 10
    }
}

protocol Collidable: Nodable {
    var physicBox: MDLAxisAlignedBoundingBox { get }
    var size: simd_float3 { get }
    
    var collidablePosition: simd_float4 { get }
}

extension Collidable {
    var size: simd_float3 {
        return physicBox.maxBounds - physicBox.minBounds
    }
}


class GameNode: Node, Dynamicable, Collidable {
    
    // MARK: - Renderable protocol
    
    var mesh: BasicMeshProtocol
    
    
    // MARK: - Dynamicable protocol
    
    var mass: Float
    var velocity: simd_float2 = simd_float2(0, 0)
    
    
    // MARK: - Collidable protocol
    
    lazy var physicBox: MDLAxisAlignedBoundingBox = {
        var box = MDLAxisAlignedBoundingBox()
        
        let xAxeValues = mesh.vertices.map { $0.position.x }
        let yAxeValues = mesh.vertices.map { $0.position.y }
        let zAxeValues = mesh.vertices.map { $0.position.z }
        
        let maxX = xAxeValues.max() ?? 0.0
        let maxY = yAxeValues.max() ?? 0.0
        let maxZ = zAxeValues.max() ?? 0.0
        
        let minX = xAxeValues.min() ?? 0.0
        let minY = yAxeValues.min() ?? 0.0
        let minZ = zAxeValues.min() ?? 0.0
        
        box.minBounds = simd_float3(minX, minY, minZ)
        box.maxBounds = simd_float3(maxX, maxY, maxZ)
        
        return box
    }()
    
    var collidablePosition: simd_float4 {
        
        let clipStage = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * simd_float4(1, 1, 0, 1)
        
        let afterRasterisationStage = clipStage / clipStage.w
        
        //print(uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix.scale * simd_float4(size, 1))
        print(afterRasterisationStage)
        
        return afterRasterisationStage
    }
    
    init(mesh: BasicMeshProtocol, mass: Float = 1) {
        self.mesh = mesh
        self.mass = mass
    }
    
    override func update(deltaTime: Float) {
        var modelMatrix = matrix_identity_float4x4
        
        updatePhysicBody(deltaTime: deltaTime)
        
        modelMatrix.translation(vector: position)
        modelMatrix.rotate(angle: rotation)
        modelMatrix.scale(vector: scale)
        
        //print(modelMatrix)
        
        uniforms.modelMatrix = modelMatrix // TRS or (visa-versa SRT) - this is the sequence!
    }
}


extension GameNode: Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder?) {
        let verticesBuffer = VanjoEngine.shared.device.makeBuffer(bytes: mesh.vertices, length: mesh.length, options: [])
        let uniformBuffer = VanjoEngine.shared.device.makeBuffer(bytes: &uniforms, length: MemoryLayout<Uniforms>.stride, options: [])
        
        let rplsBuilder = RenderPipelineStateBuilder()
        
        renderEncoder?.setRenderPipelineState(rplsBuilder.getPipelineState(for: .basic)!)
        
        renderEncoder?.setVertexBuffer(verticesBuffer, offset: 0, index: 0)
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertices.count
        )
    }
}
