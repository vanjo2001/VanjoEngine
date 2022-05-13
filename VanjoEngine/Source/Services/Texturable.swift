//
//  TextureLoader.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 03.05.2022.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func loadNewTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture?
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: "png") {
            do {
                texture = try textureLoader.newTexture(URL: textureURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return texture
    }
}
