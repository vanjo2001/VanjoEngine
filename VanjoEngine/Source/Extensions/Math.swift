//
//  Math.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 08.01.2022.
//

import Foundation


extension matrix_float4x4 {
    mutating func translation(vector: simd_float2) {
        
        let rows = [
            simd_float4(1, 0, 0, vector.x),
            simd_float4(0, 1, 0, vector.y),
            simd_float4(0, 0, 1, 0),
            simd_float4(0, 0, 0, 1),
        ]
        
        self = matrix_multiply(self, matrix_float4x4(rows: rows))
    }
    
    mutating func scale(vector: simd_float2) {
        
        let rows = [
            simd_float4(vector.x,      0, 0, 0),
            simd_float4(     0, vector.y, 0, 0),
            simd_float4(     0,      0, 1, 0),
            simd_float4(     0,      0, 0, 1),
        ]
        
        self = matrix_multiply(self, matrix_float4x4(rows: rows))
    }
    
    mutating func rotate(angle: Float) {
        
        let rows = [
            simd_float4(cos(angle), -sin(angle), 0, 0),
            simd_float4(sin(angle), cos(angle),  0, 0),
            simd_float4(0,          0,           1, 0),
            simd_float4(0,          0,           0, 1)
        ]
        
        self = matrix_multiply(self, matrix_float4x4(rows: rows))
    }
}

extension Float {
    var radians: Float {
        (self / 180.0) * .pi
    }
}
