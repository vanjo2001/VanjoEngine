//
//  SandboxScene.swift
//  Sandbox
//
//  Created by Vanjo Lutik on 18.01.2022.
//

import Foundation
import CoreGraphics
import UIKit

class SandboxScene: SceneNode {
    override func setupScene() {
        let ball = GameNode(mesh: CircleMesh(segments: 50))
        ball.scale = .init(x: 0.1, y: 0.1)
        add(childNode: ball)
        
        let camera = CameraNode(aspectRatio: 1.0)
        cameras = [camera]
    }
    
    func convertScreenToNDC(point: CGPoint, sceneSize: CGSize) -> CGPoint {
        let x = (-1 + (point.x / (UIScreen.main.bounds.width / 2))) * CGFloat(camera.aspectRatio)
        let y = 1 - (point.y / (UIScreen.main.bounds.height / 2))
        //print(CGPoint(x: x, y: y))
        if let node = children.first as? Collidable {
            //print(node.size)
        }
        return CGPoint(x: x, y: y)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        
        let gameNode = children.first! as! GameNode
        //print(gameNode.uniforms.modelMatrix * gameNode.physicBox.maxBounds.x)
    }
    
    // MARK: - Delegates Overriding
    
    override func didTouch(for point: CGPoint) {
        //print(convertScreenToNDC(point: point, sceneSize: sceneSize))
        for one in children where one is Dynamicable {
            (one as! Dynamicable).makeImpulse()
        }
    }
    
    override func detected(collisions: [Collidable], _ axis: SceneNode.Border) {
        guard let node = collisions.first else { return }
        
        switch axis {
        case .xBorder:
            node.position.x *= -1
        default:
            break
        }
    }
    
}
