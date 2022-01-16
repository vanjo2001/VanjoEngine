//
//  GameNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 09.01.2022.
//

import Foundation
import MetalKit


protocol Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder?)
}


class GameNode: Node, Renderable {
    
    var mesh: BasicMeshProtocol
    
    init(mesh: BasicMeshProtocol) {
        self.mesh = mesh
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder?) {
        let buffer = VanjoEngine.shared.device.makeBuffer(bytes: mesh.vertices, length: mesh.length, options: [])
        let uniformBuffer = VanjoEngine.shared.device.makeBuffer(bytes: &uniforms, length: MemoryLayout<Uniforms>.stride, options: [])
        
        let rplsBuilder = RenderPipelineStateBuilder()
        
        renderEncoder?.setRenderPipelineState(rplsBuilder.getPipelineState(for: .basic)!)
        
        renderEncoder?.setVertexBuffer(buffer, offset: 0, index: 0)
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertices.count
        )
    }
    
    override func update(deltaTime: Float) {
        var modelMatrix = matrix_identity_float4x4
        
        modelMatrix.translation(vector: position)
        modelMatrix.rotate(angle: rotation)
        modelMatrix.scale(vector: scale)
        
        print(uniforms.projectionMatrix * uniforms.viewMatrix * modelMatrix)
        
        uniforms.modelMatrix = modelMatrix // TRS or (visa-versa SRT) - this is the sequence!
    }
}
