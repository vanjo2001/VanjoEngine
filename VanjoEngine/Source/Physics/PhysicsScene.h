//
//  PhysicsScene.h
//  VanjoEngine
//
//  Created by Ivan Lyuhtikov on 14.02.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhysicsSceneCollisionDelegate
- (void)collision;
@end

@interface PhysicsScene : NSObject

- (void)addNode:(void *)node;
- (void)updateWithDelta:(float)aDelta;

@property (nonatomic, weak) id<PhysicsSceneCollisionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
