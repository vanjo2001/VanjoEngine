//
//  BasicMesh.swift
//  BasicMesh
//
//  Created by Vanjo Lutik on 29.12.2021.
//

import MetalKit

private protocol BasicMeshPrivateProtocol {
    func makeVertecies() -> [Vertex]
}

protocol BasicMeshProtocol: AnyObject {
    var vertices: [Vertex] { get }
}

extension BasicMeshProtocol {
    var length: Int {
        vertices.count * MemoryLayout<Vertex>.stride
    }
}


class BasicMesh: BasicMeshProtocol {
    
    var vertices: [Vertex] = []
    
    init() {
        vertices = makeVertecies()
    }
    
    fileprivate func makeVertecies() -> [Vertex] {
        fatalError("MUST NOT be used as a mesh!!! USE INHERITORS")
    }
}

class TriangeMesh: BasicMesh {
    
    override fileprivate func makeVertecies() -> [Vertex] {
        return [
            Vertex(position: simd_float4(0, 1, 0, 1), color: simd_float4(0.9, 0, 0, 1)),
            Vertex(position: simd_float4(1, -1, 0, 1), color: simd_float4(0, 0.3, 0, 1)),
            Vertex(position: simd_float4(-1, -1, 0, 1), color: simd_float4(0, 0, 0.6, 1)),
        ]
    }
}

class SquareMesh: BasicMesh {
    
    override fileprivate func makeVertecies() -> [Vertex] {
        return [
            Vertex(position: simd_float4(-1, 1, 0, 1), color: simd_float4(0, 0, 0.6, 1)),
            Vertex(position: simd_float4(1, 1, 0, 1), color: simd_float4(0, 0.3, 0, 1)),
            Vertex(position: simd_float4(-1, -1, 0, 1), color: simd_float4(0.9, 0, 0, 1)),
            
            Vertex(position: simd_float4(1, -1, 0, 1), color: simd_float4(0, 0, 0.6, 1)),
            Vertex(position: simd_float4(-1, -1, 0, 1), color: simd_float4(0, 0.3, 0, 1)),
            Vertex(position: simd_float4(1, 1, 0, 1), color: simd_float4(0.9, 0, 0, 1)),
        ]
    }
}

class CircleMesh: BasicMesh {
    
    private let segments: Int
    
    init(segments: Int) {
        self.segments = segments
    }
    
    override fileprivate func makeVertecies() -> [Vertex] {
        var verices = [Vertex]()
        
        let byValue: Float = .pi * 2 / Float(segments) // 45 degrees
        var previous: Float = 0

        for degrees in stride(from: 0, to: .pi * 2, by: byValue) {
            previous = degrees
            verices.append(contentsOf: [
                Vertex(position: simd_float4(cos(previous), sin(previous), 0, 1), color: simd_float4(0, 0, 0.6, 1)),
                Vertex(position: simd_float4(cos(previous + byValue), sin(previous + byValue), 0, 1), color: simd_float4(0, 0.3, 0, 1)),
                Vertex(position: simd_float4(0, 0, 0, 1), color: simd_float4(0.9, 0, 0, 1)),
            ])
        }

        return verices
    }
}

struct Vertex {
    var position: simd_float4
    var color: simd_float4
}
