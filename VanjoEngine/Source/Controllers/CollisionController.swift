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
    
    /*
    private var gameNodes: [Node] {
        return nodes.compactMap { $0 as? GameNode }
    }
    */
    
    
    init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    func detectSceneCollision() {
        guard let scene = sceneNode else { return }
        
        for node in nodes {
            if let collidable = node as? Collidable {
                
                let coordinates = collidable.collidablePosition
                
                for border in scene.borders {
                    checkBorder(node: collidable, border, for: coordinates)
                }
            }
        }
        
        func checkBorder(node: Collidable, _ axis: SceneNode.Border, for coordinates: simd_float4) {
            
            switch axis {
            case .xBorder(let xMode):
                checkBorder(xMode, border: axis, positionValue: coordinates.x)
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
                    
                    //print(border, positionValue)
                    if positionValue >= secondSide {
                        delegate?.detected(collisions: [node], axis)
                    }
                    
                    if positionValue <= firstSide {
                        delegate?.detected(collisions: [node], axis)
                    }
                    
                case .solid(let firstSide, let secondSide):
                    break
                }
            }
        }
        
    }
}
