//
//  PhysicsScene.m
//  VanjoEngine
//
//  Created by Ivan Lyuhtikov on 14.02.23.
//

#import "PhysicsScene.h"
#include "btBulletDynamicsCommon.h"

@implementation PhysicsScene {
	btBroadphaseInterface*                  _broadphase;
	btDefaultCollisionConfiguration*        _collisionConfiguration;
	btCollisionDispatcher*                  _dispatcher;
	btSequentialImpulseConstraintSolver*    _solver;
	btDiscreteDynamicsWorld*                _world;
}

-(void)initPhysics
{
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

@end
