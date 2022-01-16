//
//  MTLFunctionBuilder.swift
//  MTLFunctionBuilder
//
//  Created by Vanjo Lutik on 29.12.2021.
//

import Foundation
import Metal

class MTLFunctionBuilder {
    enum VertexFunction: String {
        case basic = "vertex_func"
    }
    
    enum FragmentFunction: String {
        case basic = "fragment_func"
    }
    
    private var vertexFunctions: [VertexFunction: MTLFunction] = [:]
    private var fragmentFunctions: [FragmentFunction: MTLFunction] = [:]
    
    func getVertexFunc(for type: VertexFunction) -> MTLFunction? {
        
        if let function = vertexFunctions[type] {
            return function
        }
        
        let newFunction = VanjoEngine.shared.defaultLibrary.makeFunction(name: type.rawValue)
        vertexFunctions[type] = newFunction
        
        return newFunction
    }
    
    func getFragmentFunc(for type: FragmentFunction) -> MTLFunction? {
        
        if let function = fragmentFunctions[type] {
            return function
        }
        
        let newFunction = VanjoEngine.shared.defaultLibrary.makeFunction(name: type.rawValue)
        fragmentFunctions[type] = newFunction
        
        return newFunction
    }
}
