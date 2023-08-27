//
//  SceneNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import Metal

class SceneNode: Node, Renderable, InputControllerDelegate {
	private let physics: PhysicsScene = .init()
    
    var sceneConstants: SceneConstants = SceneConstants(
        viewMatrix: matrix_identity_float4x4,
        projectionMatrix: matrix_identity_float4x4
    )
    
    private(set) var sceneSize: CGSize = .zero
    
    var cameras: [CameraNode] = []
    
    var currentCameraIndex = 0
    
    var camera: CameraNode {
        return cameras[currentCameraIndex]
    }
    
	override init(id: String) {
		super.init(id: id)
		physics.delegate = self
		
        setupScene()
    }
    
    func setupScene() {
        fatalError("USE ANCESTORS!!!")
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder?, buffer: MTLBuffer) {
        renderEncoder?.setVertexBytes(
            &sceneConstants,
            length: MemoryLayout<SceneConstants>.stride,
            index: Int(SceneConstantsIndex.rawValue)
        )
    }
	
	override func add(childNode: Node) {
		super.add(childNode: childNode)
		
		if let node = childNode as? Dynamicable {
			
			node.physics.world = self.physics
			
//			//convert self to unmanaged object
			let anUnmanaged = Unmanaged<PhysicsNode>.passUnretained(node.physics)
			//get raw data pointer
			let opaque = anUnmanaged.toOpaque()
			
			self.physics.addNode(opaque)
		}
	}
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
		
		physics.update(withDelta: deltaTime)
		
        cameras.forEach { $0.update(deltaTime: deltaTime) }
        
        updateSceneConstants()
    }
    
    func drawableSizeWillChange(aspectRatio: Float, actualSize: CGSize) {
        sceneSize = actualSize
        cameras.forEach {
            $0.aspectRatio = aspectRatio
        }
    }
    
    private func updateSceneConstants() {
        sceneConstants.viewMatrix = camera.viewMatrix
        sceneConstants.projectionMatrix = camera.projectionMatix
    }
    
    
    // MARK: - Delegates Implementations
    
    /// You can override this mehtod to handle touch events. The default implementation does nothing
    func didTouch(for point: CGPoint) {}
}

extension SceneNode: PhysicsSceneCollisionDelegate {
	func collision() {
		print("collision")
	}
}
