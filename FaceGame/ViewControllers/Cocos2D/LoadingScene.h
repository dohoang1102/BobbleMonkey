//
//  LoadingScene.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	TargetSceneMultiLayerScene,
    TargetSceneMainMenu,
    
} TargetScenes;

@interface LoadingScene : CCScene
{
	TargetScenes targetScene_;
}

+(id) sceneWithTargetScene:(TargetScenes)targetScene;
-(id) initWithTargetScene:(TargetScenes)targetScene;

@end
