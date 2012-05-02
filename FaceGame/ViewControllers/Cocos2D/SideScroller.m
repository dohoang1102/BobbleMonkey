//
//  SideScroller.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "SideScroller.h"
#import "Player.h"
#import "ObjectFallingFromSky.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "LevelParser.h"
#import "Levels.h"
#import "Level.h"
#import "GameOverScene.h"

static NSString *deviceFile(NSString * file, NSString * ext) 
{
    UIDevice* thisDevice = [UIDevice currentDevice];
    
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        NSString* myImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-iPad", file] ofType:ext];
        
        if (myImagePath == nil) {
            NSLog(@"Using iPhone Version");
            return ([NSString stringWithFormat:@"%@.%@", file, ext]);
        }
        else {
            NSLog(@"Using iPad Version");
            return ([NSString stringWithFormat:@"%@-iPad.%@", file, ext]);
        }
    }
    else {
        NSLog(@"Using iPhone Version");
        return ([NSString stringWithFormat:@"%@.%@", file, ext]);
    }
};

@interface SideScroller ()
{
    float percentStatue;
    float percentBananaBunch;
    float percentBackPack;
    float percentCanteen;
    float percentHat;
    float percentPineapple;
    
    CCArray * objects;
    CCArray * positionOfObjects; 
    
    float objectMoveDuration;
    int numObjectsMoved;
    
    // Used for Scores
	ccTime totalTime;
	int score;
	CCLabelTTF * scoreLabel;
    
    BOOL isPlayerRunning; 
    
    CGPoint playerVelocity;
    Player * player;
    
    GameOverScene * gameOverScene;
    
    CCSprite * grassFront;
    
}

-(void) initObjects;
-(void) resetObjects;
-(void) objectsUpdate:(ccTime)delta;
-(void) runObjectsMoveSequence:(CCSprite*)object;
-(void) objectBelowScreen:(id)sender;
-(void) checkForCollision;

@end

@implementation SideScroller

#pragma mark - Life-Cycle Methods

-(id) init
{
	if ((self = [super init]))
	{
        //This is the only place where I do addSpriteFramesWithFile
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:deviceFile(@"artifacts", @"plist")];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:deviceFile(@"monkeyAtlas", @"plist")];
        
        /*
        //Need explicit casting in Objective-C!! 
        percentStatue = ((1.0f/11.0f) *100.0f);
        percentBananaBunch = ((1.0f/11.0f) *100.0f);
        percentBackPack = ((1.0f/11.0f) *100.0f);
        percentCanteen = ((1.0f/11.0f) *100.0f);
        percentHat = ((1.0f/11.0f) *100.0f);
        percentPineapple = ((1.0f/11.0f) *100.0f);
        */
        
        GameData *gameData = [GameDataParser loadData];
        
        int selectedChapter = gameData.selectedChapter;
        
        NSLog(@"selectedChapter = %i", selectedChapter);
        
        int selectedLevel = gameData.selectedLevel;
        
        Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        for (Level *level in levels.levels) 
        {
            if (level.number == selectedLevel) 
            {
                NSLog(@"level.number = %i", level.number);
                
                percentStatue = level.pStatue;
                percentBananaBunch = level.pBananaBunch;
                percentBackPack = level.pBackPack;
                percentCanteen = level.pCanteen;
                percentHat = level.pHat;
                percentPineapple = level.pPineapple;
                objectMoveDuration = level.setSpeed;
            }
        }
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CCSprite * backGround =[CCSprite spriteWithFile:deviceFile(@"bg_jungle", @"png")];
        [backGround setPosition:CGPointMake(backGround.boundingBox.size.width/2, backGround.boundingBox.size.height/2)];
        [backGround setScale:1.0];
        [backGround setOpacity:190];
        [self addChild:backGround z:backGroundTag];
        
        CCSprite * grassBehind =[CCSprite spriteWithFile:deviceFile(@"bg_grassbehind", @"png")];
        [grassBehind setPosition:CGPointMake(grassBehind.boundingBox.size.width/2, grassBehind.boundingBox.size.height/2)];
        [self addChild:grassBehind z:grassBehindTag];

        player = [Player playerWithSender: self];
		[self addChild:player z:3 tag:playerTag];
        
        grassFront=[CCSprite spriteWithFile:deviceFile(@"bg_grassfront", @"png")];
        [grassFront setPosition:CGPointMake(grassFront.boundingBox.size.width/2, grassFront.boundingBox.size.height/2)];
        [grassFront setScale:1.0];
        [grassFront setOpacity:255];
        [self addChild:grassFront z:grassFrontTag];
        
        // scheduling the update method in order to adjust the player's speed every frame
		[self scheduleUpdate];
		
		[self initObjects];
        
        glClearColor(0.0, 0.0, 0.0, 0.0);
        
        gameOverScene = [[GameOverScene alloc] initWithScoreAchieved:0 HighScore:0 numOfStarsAchieved:0 nextLevelUnlocked:NO sender:self] ;
        gameOverScene.visible = NO;
        [self addChild:gameOverScene];
        
		// Add the score label with z value of -1 so it's drawn below everything else
		scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:48];
		scoreLabel.position = CGPointMake(screenSize.width / 2, screenSize.height);
		scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
        scoreLabel.color = ccc3(240, 160, 0);
		[self addChild:scoreLabel z:scoreLabelTag];
        
        [self resetPlayer];
        
        //Once the game has started, we start the game
        NSMutableDictionary* gameStatus = [NSMutableDictionary dictionary];
        [gameStatus setObject:[NSNumber numberWithBool:YES] forKey:@"gameStatus"];
        //[gameStatus setObject:[NSNumber numberWithBool:YES] forKey:@"isGameStarted"]; 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Cocos2DNotification" 
                                                            object:self
                                                          userInfo:gameStatus];
        
	}
    
	return self;
}

-(void) dealloc
{
	NSLog(@"Dealloc for SideScroller got called!");
    
    //The director may be paused to pause the game. If this view goes away, the director should not be paused anymore
    if([[CCDirector sharedDirector] isPaused])
    {
        [[CCDirector sharedDirector] resume];
    }
    
	[objects release];
    [positionOfObjects release];
    [gameOverScene release];
	
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
	[super dealloc];
    
    
}

#pragma mark - Objects-Falling-From-The-Sky

-(void) initObjects
{
    
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSpriteFrame * tempSprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"object_statue.png"];
    float imageWidth = tempSprite.rect.size.width;
   
    //number of objectsFallingFromSky scales to the width of the screen
	int numObjects = screenSize.width / imageWidth;
    
    NSLog(@"NumObjects: %i", numObjects);
    
	// Make sure an objects array does not already exist
	NSAssert(objects == nil, @"%@: Objects array already initialized!", NSStringFromSelector(_cmd));
	objects = [[CCArray alloc] initWithCapacity:numObjects] ;
	
    // ---------------------------------------------------------------------------------------
    
    int totalNumOfObstacles = 0; 
    
    int numOfStatue = (int)((percentStatue/100.0f) * numObjects);
    totalNumOfObstacles += numOfStatue;
    
    int numOfBananaBunch = (int)((percentBananaBunch/100.0f) * numObjects);
    totalNumOfObstacles += numOfBananaBunch;
    
    int numOfBackPack = (int)((percentBackPack/100.0f) * numObjects);
    totalNumOfObstacles += numOfBackPack;
    
    int numOfCanteen = (int)((percentCanteen/100.0f) * numObjects);
    totalNumOfObstacles += numOfCanteen;
    
    int numOfHat = (int)((percentHat/100.0f) * numObjects);
    totalNumOfObstacles += numOfHat;
    
    int numOfPineapple = (int)((percentPineapple/100.0f) * numObjects);
    totalNumOfObstacles += numOfPineapple;
    
    int numOfBananas = numObjects - totalNumOfObstacles; 
    
    NSLog(@"numOfBananas: %i", numOfBananas);
    NSLog(@"totalNumOfObstacles: %i", totalNumOfObstacles);
    NSLog(@"numObjects: %i", numObjects);
    
    NSMutableDictionary *dictOfObjectNums = [NSMutableDictionary dictionary];

    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfBananas] forKey:@"BananaNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfStatue] forKey:@"StatueNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfBananaBunch] forKey:@"BananaBunchNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfBackPack] forKey:@"BackPackNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfCanteen] forKey:@"CanteenNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfHat] forKey:@"HatNode"];
    [dictOfObjectNums  setObject:[NSNumber numberWithInt:numOfPineapple] forKey:@"PineappleNode"];
    
    for (NSString *key in dictOfObjectNums) 
    {
        ObjectNodeTags tag; 
        
        if (key == @"BananaNode") 
        {
            tag = BananaNode;
        }         
        if (key == @"StatueNode") 
        {
            tag = StatueNode;
        }
        if (key == @"BananaBunchNode") 
        {
            tag = BananaBunchNode;
        }  
        if (key == @"BackPackNode") 
        {
            tag = BackPackNode;
        }  
        if (key == @"CanteenNode") 
        {
            tag = CanteenNode;
        }  
        if (key == @"HatNode") 
        {
            tag = HatNode;
        }  
        if (key == @"PineappleNode") 
        {
            tag = PineappleNode;
        }  
        
        for (int i = 0; i < [[dictOfObjectNums objectForKey:key] intValue]; i++) 
        {
            ObjectFallingFromSky * object = [ObjectFallingFromSky objectOfKind:tag WithSender:self];
            [self addChild:object z:objectTag];
            [objects addObject:object];
        }
    }
    
	[self resetObjects];
}

-(void) pauseAllObjects
{
    [self unschedule:@selector(objectsUpdate:)];
    
    for (CCSprite * object in objects)
    {
        [object stopAllActions];
    }
}

-(void) resetObjects
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    int numObjects = [objects count];
    
    float totalWidthOfAllObjectsSideBySide = 0.0f;
    for (CCSprite * object in objects) 
    {
        totalWidthOfAllObjectsSideBySide += object.boundingBox.size.width;
    }
    
    NSLog(@" totalWidthOfAllObjectsSideBySide %f", totalWidthOfAllObjectsSideBySide);
    NSLog(@" screenSize.width %f", screenSize.width);
    
    int spriteOffset = (screenSize.width - totalWidthOfAllObjectsSideBySide)/2.0f;
    
    positionOfObjects = [[CCArray alloc] initWithCapacity:numObjects];
    
    float distanceInPointsFromFirstObject = 0.0f;
    
	for (int i = 0; i < numObjects; i++)
	{
        
        ObjectFallingFromSky * object = [objects objectAtIndex:i];
        
        if (i > 0) 
        {
             distanceInPointsFromFirstObject += object.boundingBox.size.width;
        }
       
        CGPoint position = CGPointMake(distanceInPointsFromFirstObject + object.boundingBox.size.width * 0.5f + spriteOffset, 
                                       screenSize.height + (object.boundingBox.size.height * 2));

        [positionOfObjects addObject:[NSValue valueWithCGPoint:position]];
        object.position = position;
        
        [object stopAllActions];
	}
	
	// Unschedule the selector just in case. If it isn't scheduled it won't do anything.
	[self unschedule:@selector(objectsUpdate:)];
	// Schedule the object update logic to run at the given interval.
	[self schedule:@selector(objectsUpdate:) interval:0.6f];
	
	numObjectsMoved = 0;
}

-(void) objectsUpdate:(ccTime)delta
{
	// Try to find an object which isn't currently moving for an arbitrary number of times.
	// If one isn't found within 10 tries we'll just try again next time objects is called.
	int numObjects = [objects count];
    
    for (int i = 0; i < 10; i++)
	{
		int randomObjectIndex = CCRANDOM_0_1() * numObjects;
		CCSprite* object = [objects objectAtIndex:randomObjectIndex];
        
        int randomPositionIndex = CCRANDOM_0_1() * numObjects;
        CGPoint position = [[positionOfObjects objectAtIndex:randomPositionIndex] CGPointValue];
        
        if ([object numberOfRunningActions] == 0)
		{
			if (i > 0)
			{
				CCLOG(@"Dropping an object after %i retries.", i);
			}
            
            object.position = position;
            
			[self runObjectsMoveSequence:object];
			
			break;
		}
	}
}

-(void) runObjectsMoveSequence:(CCSprite*)object
{
	numObjectsMoved++;
    
	CGPoint belowScreenPosition = CGPointMake(object.position.x, - object.boundingBox.size.height);
	CCMoveTo* move = [CCMoveTo actionWithDuration:objectMoveDuration position:belowScreenPosition];
	CCCallFuncN* call = [CCCallFuncN actionWithTarget:self selector:@selector(objectBelowScreen:)];
	CCSequence* sequence = [CCSequence actions:move, call, nil];
	[object runAction:sequence];
}

// Called by CCCallFuncN whenever an object has ended sequence of actions. 
-(void) objectBelowScreen:(id)sender
{
	// Make sure sender is of the right class.
	NSAssert([sender isKindOfClass:[CCSprite class]], @"sender is not of class CCSprite!");
	CCSprite* object = (CCSprite*)sender;
	
	// move the object up to top of the screen
	CGPoint pos = object.position;
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	pos.y = screenSize.height + object.boundingBox.size.height;
	object.position = pos;
}

#pragma mark - Player Life-Cycle

-(void) resetPlayer
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float imageHeight = player.boundingBox.size.height;
    player.position = CGPointMake(screenSize.width / 2.0f, imageHeight/2.0f + grassFront.boundingBox.size.height * 0.17f);
    [player resetPlayer];
    NSLog(@"%f", player.position.y);
}

#pragma mark - Raw Data Input

-(void) receivedRawDetectorData: (float) data;
{
    
    NSLog(@"Data Received");
    
    // how quickly the velocity decelerates (lower = quicker to change direction)
	float deceleration = -0.1f;
	// how sensitive the dataSource reacts (higher = more sensitive)
	float sensitivity = 40.0f;
	// how fast the velocity can be at most
	float maxVelocity = 100;
    
	// adjust velocity based on current data
	playerVelocity.x = playerVelocity.x * deceleration + data * sensitivity;
	
	// we must limit the maximum velocity of the player sprite, in both directions (positive & negative values)
	if (playerVelocity.x > maxVelocity)
	{
		playerVelocity.x = maxVelocity;
	}
	else if (playerVelocity.x < -maxVelocity)
	{
		playerVelocity.x = -maxVelocity;
	}
}

#pragma mark - Update

-(void) update:(ccTime)delta
{
    if (!player.isActionRunning)
    {
	
	CGPoint pos = player.position;
	pos.x += playerVelocity.x;
	
    /*
        if (!isPlayerRunning && playerVelocity.x >= 10.0f ) 
        {
            isPlayerRunning = YES;
            [player startMonkeyRunningAnimation];
        }
        if (isPlayerRunning && playerVelocity.x < 10.0f) 
        {
            isPlayerRunning = NO;
            [player stopMonkeyRunningAnimation];
        }
     */
        
    // Stopping the player object from going outside the screen bounds
	
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float imageWidthHalved = player.boundingBox.size.width * 0.5f;
        float leftBorderLimit = imageWidthHalved;
        float rightBorderLimit = screenSize.width - imageWidthHalved;
    
	// the left/right border check is performed against half the player image's size so that the sides of the actual
	// sprite are blocked from going outside the screen because the player sprite's position is at the center of the image
	
        if (pos.x < leftBorderLimit)
        {
            pos.x = leftBorderLimit;
		
            // also set velocity to zero because the player is still accelerating towards the border
            playerVelocity = CGPointZero;
        }
        else if (pos.x > rightBorderLimit)
        {
            pos.x = rightBorderLimit;
        
            // also set velocity to zero because the player is still accelerating towards the border
            playerVelocity = CGPointZero;
        }
    
        player.position = pos;
        [self checkForCollision];
    }
}

#pragma mark - Collision Checks

//TO DO: Better collision checking. Here, it is assumed that both player and object sprites are squares
-(void) checkForCollision
{
	float playerImageSize = player.boundingBox.size.width;
    
    NSAssert([[objects lastObject] isKindOfClass:[CCSprite class]], @"Object is not of class CCSprite!");
	float objectImageSize = ((CCSprite *)[objects lastObject]).boundingBox.size.width;
    
	float playerCollisionRadius = playerImageSize * 0.4f;
	float objectCollisionRadius = objectImageSize * 0.4f;

	float maxCollisionDistance = playerCollisionRadius + objectCollisionRadius;
	
	int numObjects = [objects count];
    
	for (int i = 0; i < numObjects; i++)
	{
		ObjectFallingFromSky * object = [objects objectAtIndex:i];
        
		if ([object numberOfRunningActions] == 0)
		{
			// This object isn't even moving so we can skip checking it.
			continue;
		}

		float actualDistance = ccpDistance(player.position, object.position);
		
		// Are the two objects closer than allowed?
		if (actualDistance < maxCollisionDistance)
		{
            if (object.doesCollisionKillPlayer)
            {
                [player monkeyDiedAnimation];
            }
            else 
            {
                [object stopAllActions];
                
                score += object.incrementScoreBy;
                [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
                
                [player incentiveCaughtAnimation];
                [object performCollisionAnimation];
                
            }

		}
	}
}

#pragma mark - Game Life-Cycle

-(void) resetGame
{
    [[CCDirector sharedDirector] resume];
    
    NSMutableDictionary* gameStatus = [NSMutableDictionary dictionary];
    [gameStatus setObject:[NSNumber numberWithBool:YES] forKey:@"gameStatus"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Cocos2DNotification" 
                                                        object:self
                                                      userInfo:gameStatus];
    gameOverScene.visible = NO;
    
    scoreLabel.visible = YES;
    
	[self resetObjects];
    [self resetPlayer];
    
    player.isActionRunning = NO;
    
	score = 0;
	totalTime = 0;
	[scoreLabel setString:@"0"];
}

-(void) gameOver
{
    [self resetObjects];
    
    scoreLabel.visible = NO;
    
    [[CCDirector sharedDirector] pause];
    
    NSMutableDictionary* gameStatus = [NSMutableDictionary dictionary];
    [gameStatus setObject:[NSNumber numberWithBool:NO] forKey:@"gameStatus"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Cocos2DNotification" 
                                                        object:self
                                                      userInfo:gameStatus];
    //gameOverScene.highScore = 1000;
    gameOverScene.visible = YES;
    
}

/*
#if DEBUG
-(void) draw
{
	// Iterate through all nodes of the layer.
	for (CCNode* node in [self children])
	{
		if ([node isKindOfClass:[CCSprite class]] && (node.zOrder == playerTag || node.zOrder == objectTag))
		{
			CCSprite* sprite = (CCSprite*)node;
			float radius = sprite.boundingBox.size.width * 0.4f;
			float angle = 0;
			int numSegments = 10;
			bool drawLineToCenter = NO;
			ccDrawCircle(sprite.position, radius, angle, numSegments, drawLineToCenter);
		}
	}
}
#endif
 */

@end
