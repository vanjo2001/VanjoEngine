//
//  GameNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import MetalKit


protocol Dynamicable: Nodable {
	
	var physics: PhysicsNode { get }
    
    func makeImpulse()
    
    func updatePhysicBody(deltaTime: Float)
}

extension Dynamicable {
    func updatePhysicBody(deltaTime: Float) {
        position.x = physics.position().x
        position.y = physics.position().y
    }
    
    func makeImpulse() {
		physics.applyImpulse()
    }
}


class GameNode: RenderableNode, Dynamicable {
	
	var physics: PhysicsNode
    
    // MARK: - Collidable protocol
    
    func collidablePosition(sceneConstants: SceneConstants) -> simd_float4 {
        let clipStage = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * model.modelMatrix.position
        
        let afterRasterisationStage = clipStage / clipStage.w
        
        return afterRasterisationStage
    }
    
    init(mesh: BasicMeshProtocol, imageName: String? = nil, mass: Float = 1) {
		
		physics = PhysicsNode(
			mass: mass,
			convex: true,
			tag: 0,
			vertices: mesh.vertices.pointer(),
			vertexCount: UInt32(mesh.vertices.count)
		)
        super.init(mesh: mesh, imageName: imageName)
    }
    
    
    override func update(deltaTime: Float) {
        updatePhysicBody(deltaTime: deltaTime)
		debugPrint("physics.position(): \(physics.position())")
        // model matrix calculations, such as: translation, scale, rotate
        // and saving the result to uniform of the current node
        super.update(deltaTime: deltaTime)
    }
}


extension Array where Element == Vertex {
	func pointer() -> UnsafeMutablePointer<Element> {
		let pointer = UnsafeMutablePointer<Element>.allocate(capacity: count)
		pointer.initialize(from: self, count: count)
		return pointer
	}
}
