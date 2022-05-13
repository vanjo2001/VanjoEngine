//
//  SceneNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import Metal
import CoreGraphics


class SceneNode: Node, Renderable, InputControllerDelegate, CollisionControllerDelegate {
    
    private lazy var collisionController: CollisionController = {
        let controller = CollisionController(nodes: self.children, sceneNode: self)
        controller.delegate = self
        return controller
    }()
    
    var sceneConstants: SceneConstants = SceneConstants(
        viewMatrix: matrix_identity_float4x4,
        projectionMatrix: matrix_identity_float4x4
    )
    
    private(set) var sceneSize: CGSize = .zero
    
    private(set) var borders: [Border] = [.xBorder(.reverse(-1, 1)), .yBorder(.reverse(-1, 1))]
    
    var cameras: [CameraNode] = []
    
    var currentCameraIndex = 0
    
    var camera: CameraNode {
        return cameras[currentCameraIndex]
    }
    
    override init() {
        super.init()
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
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        cameras.forEach { $0.update(deltaTime: deltaTime) }
        
        updateSceneConstants()
        
        collisionController.detectSceneCollision()
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
    
    /// You can override this mehtod to handle collision nodes with scene borders. The default implementation does nothing
    func detected(collisions: [Collidable], _ axis: Border) {}
}


extension SceneNode {
    enum Border: CustomStringConvertible {
        
        case xBorder(Mode = .infinity)
        case yBorder(Mode = .infinity)
        case zBorder(Mode = .infinity)
        
        enum Mode {
            case infinity
            case solid(Float, Float)
            case reverse(Float, Float)
        }
        
        var description: String {
            switch self {
            case .xBorder(_):
                return "xBorder"
            case .yBorder(_):
                return "yBorder"
            case .zBorder(_):
                return "zBorder"
            }
        }
    }
}
