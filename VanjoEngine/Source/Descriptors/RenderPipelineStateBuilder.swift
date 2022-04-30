//
//  RenderPipelineStateBuilder.swift
//  RenderPipelineStateBuilder
//
//  Created by Vanjo Lutik on 29.12.2021.
//

import Foundation
import Metal


public enum RenderPipelineState {
    case basic
    case point
}

class RenderPipelineStateBuilder {
    
    private var rpDescriptorBuilder = RenderPipelineDescriptorBuilder()
    private var storage: [RenderPipelineState: MTLRenderPipelineState] = [:]
    
    func getPipelineState(for type: RenderPipelineState) -> MTLRenderPipelineState? {
        
        if let rpso = storage[type] {
            return rpso
        }
        
        do {
            let pipeline = try VanjoEngine.shared.device.makeRenderPipelineState(
                descriptor: rpDescriptorBuilder.getDescriptor(for: type.toRenderPipelineDescriptor)
            )
            storage[type] = pipeline
            
            return pipeline
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

extension RenderPipelineState {
    var toRenderPipelineDescriptor: RenderPipelineDescriptorType {
        switch self {
        case .basic:
            return .basic
        case .point:
            return .point
        }
    }
}
