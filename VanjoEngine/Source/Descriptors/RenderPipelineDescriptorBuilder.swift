//
//  RenderPipelineDescriptorBuilder.swift
//  RenderPipelineDescriptorBuilder
//
//  Created by Vanjo Lutik on 29.12.2021.
//

import Foundation
import Metal

class RenderPipelineDescriptorBuilder {
    
    enum RenderPipelineDescriptorType: String {
        case basic
    }
    
    private var functionBuilder = MTLFunctionBuilder()
    private var vertexDescriptorBuilder = VertexDescriptorBuilder()
    
    private(set) var storage: [RenderPipelineDescriptorType: MTLRenderPipelineDescriptor] = [:]
    
    private func makeDescriptor(for type: RenderPipelineDescriptorType) -> MTLRenderPipelineDescriptor {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        switch type {
        case .basic:
            renderPipelineDescriptor.vertexFunction = functionBuilder.getVertexFunc(for: .basic)
            renderPipelineDescriptor.fragmentFunction = functionBuilder.getFragmentFunc(for: .basic)
            
            renderPipelineDescriptor.vertexDescriptor = vertexDescriptorBuilder.makeDescriptor(for: .basic)
        }
        
        return renderPipelineDescriptor
    }
    
    func getDescriptor(for type: RenderPipelineDescriptorType) -> MTLRenderPipelineDescriptor {
        if let descriptor = storage[type] {
            return descriptor
        }
        
        let newDescriptor = makeDescriptor(for: type)
        storage[type] = newDescriptor
        
        return newDescriptor
    }
}
