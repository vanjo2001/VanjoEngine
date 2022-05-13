//
//  GameNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import MetalKit


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
        
        rotation -= (velocity.y + velocity.x) * deltaTime
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
    
    func collidablePosition(sceneConstants: SceneConstants) -> simd_float4
}

extension Collidable {
    var size: simd_float3 {
        return ((2) / 2) * simd_float3(scale, 1)
    }
}


class GameNode: RenderableNode, Dynamicable, Collidable {
    
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
    
    func collidablePosition(sceneConstants: SceneConstants) -> simd_float4 {
        let clipStage = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * model.modelMatrix.position
        
        let afterRasterisationStage = clipStage / clipStage.w
        
        return afterRasterisationStage
    }
    
    init(mesh: BasicMeshProtocol, imageName: String? = nil, mass: Float = 1) {
        self.mass = mass
        super.init(mesh: mesh, imageName: imageName)
    }
    
    
    override func update(deltaTime: Float) {
        updatePhysicBody(deltaTime: deltaTime)
        
        // model matrix calculations, such as: translation, scale, rotate
        // and saving the result to uniform of the current node
        super.update(deltaTime: deltaTime)
    }
}
