//
//  VanjoEngine.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 27.12.2021.
//

import Foundation
import Metal

final class VanjoEngine {
    
    static var shared = VanjoEngine()
    
    private(set) var device: MTLDevice!
    private(set) var commandQueue: MTLCommandQueue!
    
    private(set) var defaultLibrary: MTLLibrary!
    
    private init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("cannot create DEVICE (MTLCreateSystemDefaultDevice())")
        }
        
        self.device = device
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("cannot create MTLCommandQueue (MTLCreateSystemDefaultDevice())")
        }
        
        self.commandQueue = commandQueue
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("cannot create MTLLibrary (makeDefaultLibrary())")
        }
        
        self.defaultLibrary = library
    }
}
