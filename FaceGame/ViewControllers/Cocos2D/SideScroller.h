//
//  SideScroller.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Player.h"
#import "Cocos2DConnectorDelegate.h"

typedef enum
{
    backGroundTag = -1,
    scoreLabelTag = 0,
    grassBehindTag = 1,
    objectTag = 2,
    playerTag = 3,
    grassFrontTag = 4,
    
} SpriteTags;

@interface SideScroller : CCLayer <Cocos2DConnectorDelegate>

-(void) pauseAllObjects;
-(void) resetGame;
-(void) gameOver;
-(void) objectBelowScreen:(id)sender;

@end
