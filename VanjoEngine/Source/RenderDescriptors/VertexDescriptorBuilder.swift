//
//  VertexDescriptorBuilder.swift
//  VertexDescriptorBuilder
//
//  Created by Vanjo Lutik on 30.12.2021.
//

import Foundation
import Metal
import simd


public enum VertexDescriptor {
    case basic
    case point
}

class VertexDescriptorBuilder {
    
    func makeDescriptor(for type: VertexDescriptor) -> MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        descriptor.attributes[0].format = .float4
        descriptor.attributes[0].bufferIndex = 0
        descriptor.attributes[0].offset = 0
        
        descriptor.attributes[1].format = .float4
        descriptor.attributes[1].bufferIndex = 0
        descriptor.attributes[1].offset = MemoryLayout<simd_float4>.stride
        
        descriptor.attributes[2].format = .float2
        descriptor.attributes[2].bufferIndex = 0
        descriptor.attributes[2].offset = MemoryLayout<simd_float4>.stride * 2
        
        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return descriptor
    }
}
