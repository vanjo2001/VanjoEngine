//
//  SceneNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import Metal
import CoreGraphics


class SceneNode: Node, InputControllerDelegate, CollisionControllerDelegate {
    
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
    
    override func update(deltaTime: Float) {
        children.forEach { $0.update(deltaTime: deltaTime) }
        cameras.forEach { $0.update(deltaTime: deltaTime) }
    }
    
    func renderScene(renderEncoder: MTLRenderCommandEncoder?) {
        for node in children {
            node.uniforms.viewMatrix = camera.uniforms.viewMatrix
            node.uniforms.projectionMatrix = camera.uniforms.projectionMatrix
            if let node = node as? Renderable {
                node.render(renderEncoder: renderEncoder)
            }
        }
    }
    
    
    func drawableSizeWillChange(aspectRatio: Float, actualSize: CGSize) {
        sceneSize = actualSize
        cameras.forEach {
            $0.aspectRatio = aspectRatio
        }
    }
    
    func gpuDidRenderFrame() {
    }
    
    
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
    
    
    // MARK: - Delegates Implementations
    
    /// You can override this mehtod to handle touch events. The default implementation does nothing
    func didTouch(for point: CGPoint) {}
    
    /// You can override this mehtod to handle collision nodes with scene borders. The default implementation does nothing
    func detected(collisions: [Collidable], _ axis: Border) {}
}
