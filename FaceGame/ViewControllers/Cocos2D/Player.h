//
//  Player.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    bananaCaughtAnimationTag,
    monkeyDiedAnimationTag,
    monkeyRunningAnimationTag,
    
} PlayerAnimationTags;

@interface Player : CCSprite {
    
}

@property (nonatomic, assign) BOOL isActionRunning;

+(id) playerWithSender: (id) sender;

-(void) resetPlayer;

// List of Animations
-(void) incentiveCaughtAnimation;
-(void) monkeyDiedAnimation;
-(void) startMonkeyRunningAnimation;
-(void) stopMonkeyRunningAnimation;

@end
