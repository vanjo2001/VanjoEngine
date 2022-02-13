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
    
    private var nodes: [Node]
    
    private var sceneNode: SceneNode? {
        return nodes.compactMap { $0 as? SceneNode }.first
    }
    
    
    init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    func detectSceneCollision() {
        guard let scene = sceneNode else { return }
        
        for node in nodes {
            if let collidable = node as? Collidable {
                for border in scene.borders {
                    checkBorder(border, for: collidable)
                }
            }
        }
        
        func checkBorder(_ axis: SceneNode.Border, for node: Collidable) {
            
            switch axis {
            case .xBorder(let xMode):
                checkBorder(xMode, border: axis, positionValue: abs(node.position.x) + node.size.x / 2)
            case .yBorder(let yMode):
                checkBorder(yMode, border: axis, positionValue: abs(node.position.y) + node.size.y / 2)
            case .zBorder(let zMode):
                checkBorder(zMode, border: axis, positionValue: 0) // currently 0
            }
            
            func checkBorder(_ mode: SceneNode.Border.Mode, border: SceneNode.Border, positionValue: Float) {
                switch mode {
                case .infinity:
                    break
                case .reverse(let firstSide, let secondSide):
                    
                    //print(border, positionValue)
                    if abs(positionValue) >= abs(firstSide) {
                        delegate?.detected(collisions: [], axis)
                    }
                    
                    if abs(positionValue) >= abs(secondSide) {
                        delegate?.detected(collisions: [], axis)
                    }
                    
                case .solid(let firstSide, let secondSide):
                    break
                }
            }
        }
        
        
    }
}
