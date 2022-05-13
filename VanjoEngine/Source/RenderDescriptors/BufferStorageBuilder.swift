//
//  BufferStorageBuilder.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 02.05.2022.
//

import Foundation
import MetalKit

final class BufferStorageBuilder {
    
    enum BufferType: Int, CaseIterable {
        case vertex
        case color
        //case texture
    }
    
    private typealias Index = Int
    
    private static let maxBuffers = 3
    private var currentFrameIndex = 0
    private var dynamicDataBuffers = [BufferType: [MTLBuffer]]()
    private(set) var syncSemaphore = DispatchSemaphore(value: maxBuffers)
    
    init() {
        for type in BufferType.allCases {
            
            var buffers = [MTLBuffer]()
            
            for _ in 0..<Self.maxBuffers {
                let buffer = VanjoEngine.shared.device.makeBuffer(
                    length: MemoryLayout<Vertex>.stride * 1000,
                    options: [.storageModeShared]
                )
                
                buffers.append(buffer!)
            }
            
            dynamicDataBuffers.updateValue(buffers, forKey: type)
        }
    }
    
    func getBuffer(for type: BufferType) -> MTLBuffer {
        currentFrameIndex = (currentFrameIndex + 1) % Self.maxBuffers
        
        return dynamicDataBuffers[type]![currentFrameIndex]
    }
}
