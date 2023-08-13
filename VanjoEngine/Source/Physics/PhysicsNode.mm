//
//  PhysicsNode.m
//  VanjoEngine
//
//  Created by Ivan Lyuhtikov on 4.03.23.
//

#import "PhysicsNode.h"
#import "btBulletDynamicsCommon.h"

@implementation PhysicsNode {
	btCollisionShape* _shape;
	btRigidBody* _body;
}

- (void *)rigidBody {
	return _body;
}

- (instancetype)initWithMass:(float)mass
					  convex:(BOOL)convex
						 tag:(int)tag
					vertices:(Vertex *)vertices
				 vertexCount:(unsigned int)vertexCount
{
	//1
	if (self = [super init])
	{
		
		//2
		self.tag = tag;
		
		//3
		[self createShapeWithVertices:vertices count:vertexCount isConvex:convex];
		
		//4
		[self createBodyWithMass:mass];
	}
	return self;
}

-(void)createShapeWithVertices:(Vertex *)vertices count:(unsigned int)vertexCount isConvex:(BOOL)convex
{
	//1
	if (convex)
	{
		//2
		_shape = new btConvexHullShape();
		for (int i = 0; i < vertexCount; i++)
		{
			Vertex v = vertices[i];
			btVector3 btv = btVector3(v.position[0], v.position[1], v.position[2]);
			((btConvexHullShape*)_shape)->addPoint(btv);
		}
	}
	else
	{
		//3
		btTriangleMesh* mesh = new btTriangleMesh();
		for (int i=0; i < vertexCount; i += 3)
		{
			Vertex v1 = vertices[i];
			Vertex v2 = vertices[i+1];
			Vertex v3 = vertices[i+2];
			
			btVector3 bv1 = btVector3(v1.position[0], v1.position[1], v1.position[2]);
			btVector3 bv2 = btVector3(v2.position[0], v2.position[1], v2.position[2]);
			btVector3 bv3 = btVector3(v3.position[0], v3.position[1], v3.position[2]);
			
			mesh->addTriangle(bv1, bv2, bv3);
		}
		   _shape = new btBvhTriangleMeshShape(mesh, true);
	}
}

-(void)createBodyWithMass:(float)mass
{
	//1
	btQuaternion rotation;
	rotation.setEulerZYX(self.rotationZ, self.rotationY, self.rotationX);
	
	//2
	btVector3 position = btVector3(self.position.x, self.position.y, self.position.z);
	
	//3
	btDefaultMotionState* motionState = new btDefaultMotionState(btTransform(rotation, position));
	
	//4
	btScalar bodyMass = mass;
	btVector3 bodyInertia;
	_shape->calculateLocalInertia(bodyMass, bodyInertia);
	
	//5
	btRigidBody::btRigidBodyConstructionInfo bodyCI = btRigidBody::btRigidBodyConstructionInfo(bodyMass, motionState, _shape, bodyInertia);
	
	//6
	bodyCI.m_restitution = 1.0f;
	bodyCI.m_friction = 0.5f;
	
	//7
	_body = new btRigidBody(bodyCI);

	//8
	_body->setUserPointer((__bridge void*)self);
	
	//9
	_body->setLinearFactor(btVector3(1,1,0));
}

-(void)setPosition:(simd_float3)position
{
	
	//3
	if (_body)
	{
		btTransform trans = _body->getWorldTransform();
		trans.setOrigin(btVector3(position.x, position.y, position.z));
		_body->setWorldTransform(trans);
	}
}

-(simd_float3)position
{
	if (_body)
	{
		//5
		btTransform trans = _body->getWorldTransform();
		
		return simd_make_float3(trans.getOrigin().x(), trans.getOrigin().y(), trans.getOrigin().z());
	}
	else
	{
		//6
		return 0;
	}
}

-(void)setRotationX:(float)rotationX
{
	
	if (_body)
	{
		//3
		btTransform trans = _body->getWorldTransform();
		btQuaternion rot = trans.getRotation();
		
		//4
		float angleDiff = rotationX - self.rotationX;
		btQuaternion diffRot = btQuaternion(btVector3(1,0,0), angleDiff);
		rot = diffRot * rot;
		
		//5
		trans.setRotation(rot);
		_body->setWorldTransform(trans);
	}
}

-(float)rotationX
{
	if (_body)
	{
		//7
		btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
		float z,y,x;
		rotMatrix.getEulerZYX(z,y,x);
		return x;
	}
	
	//8
	return 0;
}

-(float)rotationY
{
	if (_body)
	{
		btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
		float z,y,x;
		rotMatrix.getEulerZYX(z,y,x);
		return y;
	}
	
	return 0;
}

-(float)rotationZ
{
	if (_body)
	{
		btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
		float z,y,x;
		rotMatrix.getEulerZYX(z,y,x);
		return z;
	}
	
	return 0;
}

-(void)applyImpulse {
	btVector3 impulse = btVector3(1.0, 5.0, 0.0);
	_body->setLinearVelocity(btVector3(0.0, 0.0, 0.0));
	_body->applyCentralImpulse(impulse);
}

- (void)dealloc
{
	if (_body)
	{
		delete _body->getMotionState();
		delete _body;
	}
	
	delete _shape;
}

@end
