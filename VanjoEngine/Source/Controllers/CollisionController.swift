//
//  CollisionController.swift
//  CollisionController
//
//  Created by Vanjo Lutik on 20.01.2022.
//

import Foundation
import UIKit

protocol CollisionControllerDelegate: AnyObject {
    func detected(collisions: [Collidable], _ axis: SceneNode.Border)
}

class CollisionController {
    weak var delegate: CollisionControllerDelegate?
    
    private var sceneNode: SceneNode
    private var nodes: [Node]
    
    
    init(nodes: [Node], sceneNode: SceneNode) {
        self.nodes = nodes
        self.sceneNode = sceneNode
    }
    
    func detectSceneCollision() {
        
        for node in nodes {
            if let collidable = node as? Collidable {
                
                let coordinates = collidable.collidablePosition(sceneConstants: sceneNode.sceneConstants)
                
                print("coordinates: \(coordinates.x)")
                
                for border in sceneNode.borders {
                    checkBorder(node: collidable, border, for: coordinates)
                }
            }
        }
        
        func checkBorder(node: Collidable, _ axis: SceneNode.Border, for coordinates: simd_float4) {
            
            switch axis {
            case .xBorder(let xMode):
                checkBorder(xMode, border: axis, positionValue: coordinates.x - node.size.x)
            case .yBorder(let yMode):
                checkBorder(yMode, border: axis, positionValue: coordinates.y)
            case .zBorder(let zMode):
                checkBorder(zMode, border: axis, positionValue: 0) // currently 0
            }
            
            func checkBorder(_ mode: SceneNode.Border.Mode, border: SceneNode.Border, positionValue: Float) {
                switch mode {
                case .infinity:
                    break
                case .reverse(let firstSide, let secondSide):
                    
                    if positionValue >= secondSide {
                        delegate?.detected(collisions: [node], axis)
                    }
                    
//                    if positionValue <= firstSide {
//                        delegate?.detected(collisions: [node], axis)
//                    }
                    
                case .solid(let firstSide, let secondSide):
                    break
                }
            }
        }
        
    }
}
