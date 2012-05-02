//
//  GameOverScene.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCLayer {
    
}

-(id) initWithScoreAchieved: (int)scoreAchieved 
                  HighScore:(int) highScore 
         numOfStarsAchieved:(int)numOfStarsAchieved 
          nextLevelUnlocked:(BOOL) nextLevelUnlocked 
                     sender:(id) sender;

@property (nonatomic, assign) BOOL iPad;

@property (nonatomic, assign) int scoreAchieved;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) int numOfStarsAchieved;
@property (nonatomic, assign) BOOL nextLevelUnlocked;

@end
