//
//  SceneNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import Metal



class SceneNode: Node {
    
    private var nodes: [Node] = []
    
    private var cameras: [CameraNode] = []
    
    var currentCameraIndex = 0
    
    var camera: CameraNode {
        return cameras[currentCameraIndex]
    }
    
    override init() {
        super.init()
        setupScene()
    }
    
    private func setupScene() {
        let node = GameNode(mesh: CircleMesh(segments: 50))
        nodes = [node]
        
        let camera = CameraNode(aspectRatio: 1.0)
        cameras = [camera]
    }
    
    override func update(deltaTime: Float) {
        nodes.forEach { $0.update(deltaTime: deltaTime) }
        cameras.forEach { $0.update(deltaTime: deltaTime) }
    }
    
    func renderScene(renderEncoder: MTLRenderCommandEncoder?) {
        for node in nodes {
            node.uniforms.viewMatrix = camera.uniforms.viewMatrix
            node.uniforms.projectionMatrix = camera.uniforms.projectionMatrix
            if let node = node as? Renderable {
                node.render(renderEncoder: renderEncoder)
            }
        }
    }
    
    
    func drawableSizeWillChange(aspectRatio: Float) {
        cameras.forEach {
            $0.aspectRatio = aspectRatio
        }
    }
}
