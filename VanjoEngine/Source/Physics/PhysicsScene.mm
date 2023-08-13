//
//  PhysicsScene.m
//  VanjoEngine
//
//  Created by Ivan Lyuhtikov on 14.02.23.
//

#import "PhysicsScene.h"
#import "PhysicsNode.h"
#include "btBulletDynamicsCommon.h"

@implementation PhysicsScene {
	btBroadphaseInterface*                  _broadphase;
	btDefaultCollisionConfiguration*        _collisionConfiguration;
	btCollisionDispatcher*                  _dispatcher;
	btSequentialImpulseConstraintSolver*    _solver;
	btDiscreteDynamicsWorld*                _world;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initPhysics];
		return self;
	}
	return self;
}

-(void)initPhysics {
	//1
	_broadphase = new btDbvtBroadphase();
	
	//2
	_collisionConfiguration = new btDefaultCollisionConfiguration();
	_dispatcher = new btCollisionDispatcher(_collisionConfiguration);
	
	//3
	_solver = new btSequentialImpulseConstraintSolver();
	
	//4
	_world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase, _solver, _collisionConfiguration);
	
	//5
	_world->setGravity(btVector3(0, -9.8, 0));
}

- (void)updateWithDelta:(float)aDelta {
	_world->stepSimulation(aDelta);
	[self checkCollision];
	//NSLog(@"Ball height: %f", _ball.body->getWorldTransform().getOrigin().getY());
}

- (void)addNode:(void *)node {
	NSLog(@"addNode: %@", node);
	
	PhysicsNode *physics = (__bridge PhysicsNode *)node;
	_world->addRigidBody((btRigidBody *)physics.rigidBody);
}

- (void)checkCollision {
	int numManifolds = _world->getDispatcher()->getNumManifolds();
	for (int i=0;i<numManifolds;i++)
	{
		//2
		btPersistentManifold* contactManifold =  _world->getDispatcher()->getManifoldByIndexInternal(i);
		
		//3
		int numContacts = contactManifold->getNumContacts();
		if (numContacts > 0)
		{
			
			//5
			const btCollisionObject* obA = contactManifold->getBody0();
			const btCollisionObject* obB = contactManifold->getBody1();
			
			//6
//			PNode* pnA = (__bridge PNode*)obA->getUserPointer();
//			PNode* pnB = (__bridge PNode*)obB->getUserPointer();
//
//			//7
//			if (pnA.tag == kBrickTag) {
//				[self destroyBrickAndCheckVictory:pnA];
//			}
//
//			//8
//			if (pnB.tag == kBrickTag){
//				[self destroyBrickAndCheckVictory:pnB];
//			}
			
			[self.delegate collision];
		}
	}
}

- (void)dealloc {
	delete _world;
	delete _solver;
	delete _collisionConfiguration;
	delete _dispatcher;
	delete _broadphase;
}

@end
