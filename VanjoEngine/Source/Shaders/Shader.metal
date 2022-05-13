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
    float2 textureCoodinate [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoodinate;
};


vertex VertexOut vertex_func(Vertex vert [[ stage_in ]],
                             constant ModelConstant &model [[ buffer(ModelConstantIndex) ]],
                             constant SceneConstants &scene [[ buffer(SceneConstantsIndex) ]]
                             /*unsigned int vid [[ vertex_id ]]*/
) {
    VertexOut out;
    
    out.position = scene.projectionMatrix * scene.viewMatrix * model.modelMatrix * vert.position;
    
    out.color = vert.color;
    out.textureCoodinate = vert.textureCoodinate;
    
    return out;
}

fragment float4 fragment_func(VertexOut vert [[ stage_in ]],
                              texture2d<float> texture [[ texture(0) ]]) {
    
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    return texture.sample(textureSampler, vert.textureCoodinate);
}

// point stuff

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
