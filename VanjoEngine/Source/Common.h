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
  matrix_float4x4 modelMatrix;
  matrix_float4x4 viewMatrix;
  matrix_float4x4 projectionMatrix;
} Uniforms;


#endif /* Common_h */
