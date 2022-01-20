//
//  Node.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation

protocol Nodable: AnyObject {
    var position: simd_float2 { get set }
    var scale: simd_float2 { get set }
    var rotation: Float { get set }
}


class Node: Nodable {
    var parent: Node?
    var children: [Node] = []
    
    var position = simd_float2(0, 0)
    var scale = simd_float2(x: 1, y: 1)
    var rotation: Float = 0.0
    
    var uniforms: Uniforms = Uniforms(
        modelMatrix: matrix_identity_float4x4,
        viewMatrix: matrix_identity_float4x4,
        projectionMatrix: matrix_identity_float4x4
    )
    
    final func add(childNode: Node) {
        children.append(childNode)
        childNode.parent = self
    }
    
    final func remove(childNode: Node) {
        for child in childNode.children {
            child.parent = self
            children.append(child)
        }
        
        childNode.children = []
        guard let index = children.firstIndex(where: { node in
            node === childNode
        }) else { return }
        children.remove(at: index)
        childNode.parent = nil
    }
    
    func update(deltaTime: Float) {
        fatalError("USE ANCESSTORS!!!")
    }
}
