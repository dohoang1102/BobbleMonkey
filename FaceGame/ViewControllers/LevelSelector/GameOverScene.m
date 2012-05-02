//
//  GameOverScene.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "GameOverScene.h"
#import "SceneManager.h"
#import "Cocos2DConnectorDelegate.h"

@interface GameOverScene () 
{
    id <Cocos2DConnectorDelegate> gameInstance;
}
@end


@implementation GameOverScene

@synthesize highScore = _highScore;
@synthesize numOfStarsAchieved = _numOfStarsAchieved;
@synthesize nextLevelUnlocked = _nextLevelUnlocked;
@synthesize scoreAchieved = _scoreAchieved;

@synthesize iPad;

- (void)onBack: (id) sender {
    [SceneManager goLevelSelect];
}

- (void)rePlay: (id) sender {
    [gameInstance resetGame];
}


- (void)addBackButton 
{
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPad.png" 
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
        

    if (iPad) {
        back.position = ccp(size.width / 2, size.height * 0.75f);
    }
    else {
        back.position = ccp(size.width * 0.45f, size.height * 0.75f);
    }
   
        
        
    [self addChild: back];
   
}

-(id) initWithScoreAchieved: (int)scoreAchieved 
                  HighScore:(int) highScore 
     numOfStarsAchieved:(int)numOfStarsAchieved 
      nextLevelUnlocked:(BOOL) nextLevelUnlocked 
                 sender:(id) sender
{
    if( (self=[super init])) 
    {
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        scoreAchieved = self.scoreAchieved;
        highScore = self.highScore;
        numOfStarsAchieved = self.numOfStarsAchieved;
        nextLevelUnlocked = self.nextLevelUnlocked;
        gameInstance = sender;
        
        //NSString * scoreDisplay = [NSString stringWithFormat:@"Your Score: %i", self.scoreAchieved];
        //NSString * highScoreDisplay = [NSString stringWithFormat:@"Your High Score: %i", self.highScore];
        //NSString * starsAcheived = [NSString stringWithFormat:@"Stars Achieved: %i", self.numOfStarsAchieved];
        //NSString * nextLevelUnlocked = [NSString stringWithFormat:@"Is Next Level Unlocked: %i", self.nextLevelUnlocked];
        
        int largeFont;
        
        if (iPad) 
        {
            largeFont = [CCDirector sharedDirector].winSize.height / 15;
        }
        else
        {
            largeFont = [CCDirector sharedDirector].winSize.height / 10;
        }
        
        /*
		CCLabelTTF * scoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your Score: %i", self.scoreAchieved] fontName:@"Chalkduster" fontSize:largeFont];
		scoreDisplay.position = CGPointMake(size.width / 2, size.height - (size.height/9));
        [self addChild:scoreDisplay];
        
        CCLabelTTF * highScoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your High Score: %i", self.highScore] fontName:@"Chalkduster" fontSize:largeFont];
		highScoreDisplay.position = CGPointMake(size.width / 2, size.height - (size.height/8));
        [self addChild:highScoreDisplay];
        
        CCLabelTTF * starsAcheived = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars Achieved: %i", self.numOfStarsAchieved] fontName:@"Chalkduster" fontSize:largeFont];
		starsAcheived.position = CGPointMake(size.width / 2, size.height - (size.height/7));
        [self addChild:starsAcheived];
        
        CCLabelTTF * nextLevelUnlocked = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Is Next Level Unlocked: %i", self.nextLevelUnlocked] fontName:@"Chalkduster" fontSize:largeFont];
		nextLevelUnlocked.position = CGPointMake(size.width / 2, size.height - (size.height/6));
        [self addChild:nextLevelUnlocked];
         
        [scoreDisplay setColor:ccc3(0, 0, 255)];
        [highScoreDisplay setColor:ccc3(0, 0, 255)];
        [starsAcheived setColor:ccc3(0, 0, 255)];
        [nextLevelUnlocked setColor:ccc3(0, 0, 255)];
        */
        
        // Set font settings
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:largeFont];
        
        // Create font based items ready for CCMenu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"ReeePlaayyyy!" target:self selector:@selector(rePlay:)];
        [item1 setColor:ccc3(0, 0, 255)];
        
        CCMenu *menu = [CCMenu menuWithItems:item1, nil];
        [menu alignItemsVertically];
        [self addChild:menu];

        //  Put a 'back' button in the scene
        [self addBackButton];  
    }
    
    return self; 
}

-(void) dealloc
{
	NSLog(@"dealloc for GameOver Scene");
    
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
