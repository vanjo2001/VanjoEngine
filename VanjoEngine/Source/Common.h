//
//  Common.h
//  VanjoEngine
//
//  Created by Vanjo Lutik on 03.01.2022.
//

#import<simd/simd.h>

#ifndef Common_h
#define Common_h

typedef struct {
	vector_float4 position;
	vector_float4 color;
	vector_float2 textureCoordinate; // uv coordinates or uv mapping or texture coordinates
} Vertex;

typedef struct {
	matrix_float4x4 modelMatrix;
} ModelConstant;


typedef struct {
	matrix_float4x4 viewMatrix;
	matrix_float4x4 projectionMatrix;
} SceneConstants;


typedef enum: int {
	ModelConstantIndex = 1,
	SceneConstantsIndex,
} VertexBufferIndex;

#endif /* Common_h */
