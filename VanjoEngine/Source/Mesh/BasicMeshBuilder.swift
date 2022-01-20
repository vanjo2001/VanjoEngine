//
//  BasicMeshBuilder.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 01.01.2022.
//

import Foundation

class BasicMeshBuilder {
    enum BasicShape {
        case triangle
        case square
        case flower
        case circle(segments: Int)
    }
    
    enum DynamicShape {
        case particle
    }
    
    func makeMesh(for type: BasicShape) -> BasicMesh {
        switch type {
        case .triangle:
            return TriangeMesh()
        case .square:
            return SquareMesh()
        case .circle(let segments):
            return CircleMesh(segments: segments)
        case .flower:
            return FlowerMesh()
        }
    }
}
