//
//  PhysicsNode.h
//  VanjoEngine
//
//  Created by Ivan Lyuhtikov on 4.03.23.
//

#import <Foundation/Foundation.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhysicsNode : NSObject

- (instancetype)initWithMass:(float)mass
					  convex:(BOOL)convex
						 tag:(int)tag
					vertices:(Vertex *)vertices
				 vertexCount:(unsigned int)vertexCount;

@property (nonatomic, readonly) void *rigidBody;

@property (nonatomic, assign)   int tag;

-(simd_float3)position;
-(void)setPosition:(simd_float3)position;

-(void)setRotationX:(float)rotationX;
-(float)rotationX;

-(void)applyImpulse;

@end

NS_ASSUME_NONNULL_END
