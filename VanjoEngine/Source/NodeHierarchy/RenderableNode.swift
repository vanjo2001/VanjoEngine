//
//  RenderableNode.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 03.05.2022.
//

import MetalKit

protocol Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder?, buffer: MTLBuffer)
}

class RenderableNode: Node, Renderable, Texturable {
    
    // MARK: - Renderable protocol
    
    var mesh: BasicMeshProtocol
    var texture: MTLTexture?
    
    var model = ModelConstant(modelMatrix: matrix_identity_float4x4)
    
    init(mesh: BasicMeshProtocol, imageName: String? = nil) {
        self.mesh = mesh
        super.init()
        
        guard let imageName = imageName else { return }
        self.texture = loadNewTexture(device: VanjoEngine.shared.device, imageName: imageName)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        
        var modelMatrix = matrix_identity_float4x4
        
        modelMatrix.translation(vector: position)
        modelMatrix.rotate(angle: rotation)
        modelMatrix.scale(vector: scale)
        
        model.modelMatrix = modelMatrix // TRS or (visa-versa SRT) - this is the sequence!
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder?, buffer: MTLBuffer) {
        
        renderEncoder?.setRenderPipelineState(VanjoEngine.shared.rplsBuilder.getPipelineState(for: .basic)!)
        
        //let verticesBuffer = VanjoEngine.shared.device.makeBuffer(bytes: mesh.vertices, length: mesh.length, options: [])
        
        // reusing vertex buffer insted of creating MTLBuffer (makeBuffer(bytes:...) each frame
        let bufferPointer = buffer.contents()
        let verticesPointer = bufferPointer.bindMemory(to: Vertex.self, capacity: mesh.vertices.count)
        
        let verticesBuffer = UnsafeMutableBufferPointer(start: verticesPointer, count: mesh.vertices.count)
        
        for index in verticesBuffer.startIndex ..< verticesBuffer.endIndex {
            verticesBuffer[index] = mesh.vertices[index]
        }
        
        renderEncoder?.setVertexBuffer(buffer, offset: 0, index: 0)
        
        //let uniformBuffer = VanjoEngine.shared.device.makeBuffer(bytes: &model, length: MemoryLayout<ModelConstant>.stride, options: [])
        
        //renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        // becuse of law data (< 4 KB) we use setVertexBytes instead of setVertexBuffer
        // and this way we avoid overhead of creating a buffer each call
        renderEncoder?.setVertexBytes(
            &model,
            length: MemoryLayout<ModelConstant>.stride,
            index: Int(ModelConstantIndex.rawValue)
        )
        
        renderEncoder?.setFragmentTexture(texture, index: 0)
        
        renderEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertices.count
        )
    }
}
