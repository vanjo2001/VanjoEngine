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


vertex VertexOut vertex_func(
                             Vertex vert [[ stage_in ]],
                             constant Uniforms &uniforms [[ buffer(1) ]]
                             /*unsigned int vid [[ vertex_id ]]*/
) {
    VertexOut out;
    
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vert.position;
    
    out.color = vert.color;
    return out;
}

fragment float4 fragment_func(VertexOut vert [[ stage_in ]]) {
    return vert.color;
}

// point staff

struct Point {
    float4 position [[ position ]];
    float point_size [[ point_size ]];
};

vertex Point point_vertex(constant float4 &point_coord) {
    Point out;
    out.point_size = 4;
    return out;
}

fragment half4 point_fragment(float2 point_coord [[ point_coord ]]) {
    float dist = length(point_coord - float2(0.5));
    float4 out_color = float4(0.5);
    out_color.a = 1.0 - smoothstep(0.4, 0.5, dist);
    return half4(out_color);
}
