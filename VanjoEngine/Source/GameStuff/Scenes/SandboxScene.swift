//
//  SandboxScene.swift
//  Sandbox
//
//  Created by Vanjo Lutik on 18.01.2022.
//

import Foundation

class SandboxScene: SceneNode {
    override func setupScene() {
        let ball = GameNode(mesh: CircleMesh(segments: 50))
        ball.scale = .init(x: 0.4, y: 0.4)
        nodes = [ball]
        
        let camera = CameraNode(aspectRatio: 1.0)
        cameras = [camera]
    }
}
