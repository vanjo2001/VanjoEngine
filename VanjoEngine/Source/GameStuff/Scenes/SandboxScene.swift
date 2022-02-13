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
        nodes = [ball]
        
        let camera = CameraNode(aspectRatio: 1.0)
        cameras = [camera]
    }
    
    override func didTouch(for point: CGPoint) {
        //print(convertScreenToNDC(point: point, sceneSize: sceneSize))
        for one in nodes where one is Dynamicable {
            (one as! Dynamicable).makeImpulse()
        }
    }
    
    func convertScreenToNDC(point: CGPoint, sceneSize: CGSize) -> CGPoint {
        let x = (-1 + (point.x / (UIScreen.main.bounds.width / 2))) * CGFloat(camera.aspectRatio)
        let y = 1 - (point.y / (UIScreen.main.bounds.height / 2))
        //print(CGPoint(x: x, y: y))
        if let node = nodes.first as? Collidable {
            //print(node.size)
        }
        return CGPoint(x: x, y: y)
    }
}
