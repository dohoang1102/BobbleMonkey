//
//  ObjectFallingFromSky.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	BananaNode,
    StatueNode,
    BananaBunchNode,
    BackPackNode,
    CanteenNode,
    HatNode,
    PineappleNode,
    
} ObjectNodeTags;

@interface ObjectFallingFromSky : CCSprite {
    
}

@property (nonatomic, assign) BOOL doesCollisionKillPlayer;
@property (nonatomic, assign) int incrementScoreBy;

+(id) objectOfKind:(ObjectNodeTags) tag WithSender: (id) sender;

-(void) performCollisionAnimation;

@end
