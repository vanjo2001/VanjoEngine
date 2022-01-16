//
//  RenderPipelineStateBuilder.swift
//  RenderPipelineStateBuilder
//
//  Created by Vanjo Lutik on 29.12.2021.
//

import Foundation
import Metal


class RenderPipelineStateBuilder {
    enum RenderPipelineState {
        case basic
    }
    
    private var rpDescriptorBuilder = RenderPipelineDescriptorBuilder()
    private var storage: [RenderPipelineState: MTLRenderPipelineState] = [:]
    
    func getPipelineState(for type: RenderPipelineState) -> MTLRenderPipelineState? {
        
        if let rpso = storage[type] {
            return rpso
        }
        
        do {
            switch type {
            case .basic:
                let pipeline = try VanjoEngine.shared.device.makeRenderPipelineState(descriptor: rpDescriptorBuilder.getDescriptor(for: .basic))
                storage[type] = pipeline
                
                return pipeline
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
