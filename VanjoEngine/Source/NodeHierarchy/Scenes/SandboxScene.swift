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
		
		let ball = GameNode(id: "ball", mesh: CircleMesh(segments: 50), imageName: "basketball")
        add(childNode: ball)
		
		ball.scale = .init(x: 0.2, y: 0.2)
		ball.position = .init(x: 0, y: 3)
		
		let wall = GameNode(id: "wall", mesh: SquareMesh(), mass: 0.0)
		add(childNode: wall)
		
		// we should update
		wall.scale = .init(x: 3.0, y: 0.1)
		wall.position = .init(x: 0, y: -2.0)
		
		let rightWall = GameNode(id: "rightWall", mesh: SquareMesh(), mass: 0.0)
		add(childNode: rightWall)
		
		rightWall.scale = .init(x: 0.1, y: 3.0)
		rightWall.position = .init(x: 1.5, y: 0.0)
        
        // later in process aspectRatio changes in 'drawableSizeWillChange' method
        let camera = CameraNode(aspectRatio: 1.0)
		camera.distance = -3.0
        cameras = [camera]
    }
    
    func convertScreenToNDC(point: CGPoint, sceneSize: CGSize) -> CGPoint {
        let x = (-1 + (point.x / (UIScreen.main.bounds.width / 2))) * CGFloat(camera.aspectRatio)
        let y = 1 - (point.y / (UIScreen.main.bounds.height / 2))
        //print(CGPoint(x: x, y: y))
        return CGPoint(x: x, y: y)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
    }
    
    // MARK: - Delegates Overriding
    
    override func didTouch(for point: CGPoint) {
        //print(convertScreenToNDC(point: point, sceneSize: sceneSize))
        for one in children where one is Dynamicable {
            (one as! Dynamicable).makeImpulse()
        }
    }
    
//    override func detected(collisions: [Collidable], _ axis: SceneNode.Border) {
//        guard let node = collisions.first else { return }
//
//        switch axis {
//        case .xBorder:
//			node.position
//            node.position.x *= -1
//        default:
//            break
//        }
//    }
    
}
