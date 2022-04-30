//
//  BasicMeshBuilder.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 01.01.2022.
//

public enum BasicShape {
    case triangle
    case square
    case circle(segments: Int)
}

class BasicMeshBuilder {
    
    func makeMesh(for type: BasicShape) -> BasicMesh {
        switch type {
        case .triangle:
            return TriangeMesh()
        case .square:
            return SquareMesh()
        case .circle(let segments):
            return CircleMesh(segments: segments)
        }
    }
}
