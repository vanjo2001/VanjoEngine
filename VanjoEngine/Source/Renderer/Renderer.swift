//
//  Renderer.swift
//  Renderer
//
//  Created by Vanjo Lutik on 27.12.2021.
//

import MetalKit


final class Renderer: NSObject, MTKViewDelegate {
    
    // instance for reuse buffers
    private(set) var bufferStorage = BufferStorageBuilder()
    
    // game logic
    private(set) var engine = VanjoEngine.shared
    private(set) var inputController = InputController()
    
    private var scene = SandboxScene()
    
    override init() {
        super.init()
        
        inputController.delegate = scene
    }
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.drawableSizeWillChange(aspectRatio: Float(size.width / size.height), actualSize: view.frame.size)
    }
    
    func draw(in view: MTKView) {
        
        bufferStorage.syncSemaphore.wait()
        
        guard
            let currentRenderPassDescriptor = view.currentRenderPassDescriptor,
            let currentDrawable = view.currentDrawable
        else { return }
        
        view.clearColor = .init(red: 0.1, green: 0.3, blue: 0.7, alpha: 1.0)
        
        let dt: Float = 1.0 / Float(view.preferredFramesPerSecond)
        
        let commandBuffer = VanjoEngine.shared.commandQueue.makeCommandBuffer()
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        
        scene.update(deltaTime: dt)
        scene.renderNodeTree(renderEncoder: renderCommandEncoder, buffer: bufferStorage.getBuffer(for: .vertex))
        
        renderCommandEncoder?.endEncoding()
        
        commandBuffer?.present(currentDrawable)
        
        commandBuffer?.addCompletedHandler { [weak self] _ in
            self?.bufferStorage.syncSemaphore.signal()
        }
        
        commandBuffer?.commit()
    }
}
