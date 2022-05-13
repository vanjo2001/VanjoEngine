//
//  Node.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import ModelIO
import Metal

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
        children.forEach { $0.update(deltaTime: deltaTime) }
    }
}

extension Node {
    func renderNodeTree(renderEncoder: MTLRenderCommandEncoder?, buffer: MTLBuffer) {
        if let node = self as? Renderable {
            node.render(renderEncoder: renderEncoder, buffer: buffer)
        }
        
        children.forEach {
            $0.renderNodeTree(renderEncoder: renderEncoder, buffer: buffer)
        }
    }
}
