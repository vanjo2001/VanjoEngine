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
}

extension Dynamicable {
    func makeImpulse() {
		physics.applyImpulse()
    }
}


class GameNode: RenderableNode, Dynamicable {
	
	let physics: PhysicsNode
	
	override var position: simd_float2 {
		get {
			return simd_float2(physics.position().x, physics.position().y)
		}
		
		set {
			physics.setPosition(simd_float3(newValue.x, newValue.y, 0.0))
		}
	}
	
	
	override var scale: simd_float2 {
		get {
			simd_float2(physics.scale().x, physics.scale().y)
		}
		
		set {
			physics.setScale(simd_float3(x: newValue.x, y: newValue.y, z: 0.0))
		}
	}
    
    // MARK: - Collidable protocol
    
    func collidablePosition(sceneConstants: SceneConstants) -> simd_float4 {
        let clipStage = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * model.modelMatrix.position
        
        let afterRasterisationStage = clipStage / clipStage.w
        
        return afterRasterisationStage
    }
    
	init(id: String, mesh: BasicMeshProtocol, imageName: String? = nil, mass: Float = 1) {
		
		physics = PhysicsNode(
			mass: mass,
			convex: true,
			tag: 0,
			vertices: mesh.vertices.pointer(),
			vertexCount: UInt32(mesh.vertices.count)
		)
		super.init(id: id, mesh: mesh, imageName: imageName)
    }
    
    
    override func update(deltaTime: Float) {
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
