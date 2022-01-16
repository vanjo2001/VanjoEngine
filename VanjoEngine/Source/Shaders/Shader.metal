//
//  Shader.metal
//  Shader
//
//  Created by Vanjo Lutik on 29.12.2021.
//

#include <metal_stdlib>
#include "../Common.h"
using namespace metal;

struct Vertex {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};


struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};



vertex VertexOut vertex_func(Vertex vert [[ stage_in ]], constant Uniforms &uniforms [[ buffer(1) ]]) {
    VertexOut out;
    
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vert.position;
    
    out.color = vert.color;
    return out;
}

fragment float4 fragment_func(VertexOut vert [[ stage_in ]]) {
    return vert.color;
}
