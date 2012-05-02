//
//  SceneManager.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "SceneManager.h"

@interface SceneManager ()

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager

+(void) goMainMenu {
    [SceneManager go:[MainMenu node]];
}

+(void) goOptionsMenu {
    [SceneManager go:[OptionsMenu node]];
}

+(void) goChapterSelect {
    [SceneManager go:[ChapterSelect node]];
}

+(void) goLevelSelect {
    [SceneManager go:[LevelSelect node]];
}

+(void) goGameScene {
    //[SceneManager go:[GameScene node]];
    LoadingScene * scene = [LoadingScene sceneWithTargetScene: TargetSceneMultiLayerScene];
    [SceneManager goWithScene:scene];
    
}
+(void) goWithScene: (CCScene *) newScene {
    CCDirector *director = [CCDirector sharedDirector];

    if ([director runningScene]) {
        NSLog(@"director runningScene");
        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
        NSLog(@"director runWithScene:newScene");
    }
}

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
