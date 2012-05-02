//
//  SceneManager.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MainMenu.h"
#import "OptionsMenu.h"
#import "ChapterSelect.h"
#import "LevelSelect.h"
#import "MultiLayerScene.h"
#import "LoadingScene.h"

@interface SceneManager : NSObject {
    
}

+(void) goMainMenu;
+(void) goOptionsMenu;
+(void) goChapterSelect;
+(void) goLevelSelect;
+(void) goGameScene;

@end
