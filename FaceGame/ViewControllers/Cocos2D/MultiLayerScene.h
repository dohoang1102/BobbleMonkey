//
//  MultiLayerScene.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Using an enum to define tag values has the upside that you can select
// tags by name instead of having to remember each individual number.
typedef enum
{
    MultiLayerParentScene,
    SideScrollerGameLayerTag,
} MultiLayerSceneTags;


// Class forwards: if a class is used in a header file only to define a member variable or return value,
// then it's more effective to use the @class keyword rather than #import the class header file.
// When projects grow large this helps to reduce the time it takes to compile the project.

@class SideScroller;

@interface MultiLayerScene : CCLayer  
{
	bool isTouchForUserInterface;
}

// Accessor methods to access the various layers of this scene
+(MultiLayerScene*) sharedLayer;

@property (nonatomic, assign) BOOL iPad;

@property (readonly) SideScroller* sideScrollerGameLayer;

+(id) scene;

@end
