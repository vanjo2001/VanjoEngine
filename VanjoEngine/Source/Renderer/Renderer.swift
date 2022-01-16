//
//  Renderer.swift
//  Renderer
//
//  Created by Vanjo Lutik on 27.12.2021.
//

import MetalKit


final class Renderer: NSObject, MTKViewDelegate {
    
    private(set) var engine = VanjoEngine.shared
    
    private var scene = SceneNode()
    
    override init() {
        super.init()
    }
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.drawableSizeWillChange(aspectRatio: Float(size.width / size.height))
    }
    
    func draw(in view: MTKView) {
        
        guard
            let currentRenderPassDescriptor = view.currentRenderPassDescriptor,
            let currentDrawable = view.currentDrawable
        else { return }
        
        view.clearColor = .init(red: 0.1, green: 0.3, blue: 0.7, alpha: 1.0)
        
        let dt: Float = 1.0 / Float(view.preferredFramesPerSecond)
        
        let commandBuffer = VanjoEngine.shared.commandQueue.makeCommandBuffer()
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        
        scene.update(deltaTime: dt)
        scene.renderScene(renderEncoder: renderCommandEncoder)
        
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(currentDrawable)
        commandBuffer?.commit()
        
        /*
        character.scale = simd_float2(0.1, 0.1)
        
        let G: Float = 9.81
        
        
        if abs(character.position.y) > 1 - 0.1 {
            
            if -character.velocity.y < 1 {
                character.velocity.y = 0
            } else {
                character.velocity.y = -character.velocity.y
            }
            print("MARK", character.velocity.y)
        } //else {
            let force = simd_float2(0, character.mass * -G)
            let acceleration = simd_float2(force.x / character.mass, force.y / character.mass)
            
            character.velocity.x += acceleration.x * dt
            character.velocity.y += acceleration.y * dt
        //}

        let aspect = Float(view.frame.width / view.frame.height)
        let normalisedX = -aspect + 0.1
        
        character.position.x = normalisedX
        character.position.y += character.velocity.y * dt
        
        
        character.render(
            currentRenderPassDescriptor: currentRenderPassDescriptor,
            currentDrawable: currentDrawable
        )
         */
    }
}
