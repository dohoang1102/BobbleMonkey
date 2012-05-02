//
//  LoadingScene.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "LoadingScene.h"
#import "MultiLayerScene.h"
#import "SceneManager.h"

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


@interface LoadingScene ()
{
    CCLabelTTF * label;
}

-(void) update:(ccTime)delta;

@end

@implementation LoadingScene

+(id) sceneWithTargetScene:(TargetScenes)targetScene;
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	// This creates an autorelease object of self (the current class: LoadingScene)
	return [[[self alloc] initWithTargetScene:targetScene] autorelease];
    NSLog(@"[self alloc] initWithTargetScene:targetScene");
}

-(id) initWithTargetScene:(TargetScenes)targetScene
{
	if ((self = [super init]))
	{
		targetScene_ = targetScene;
        
        CCSprite * backGround =[CCSprite spriteWithFile:deviceFile(@"bg_jungle", @"png")];
        [backGround setPosition:CGPointMake(backGround.boundingBox.size.width/2, backGround.boundingBox.size.height/2)];
        [backGround setOpacity:190];
        [self addChild:backGround z:-1];

        int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleLarge;
		label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Chalkduster" fontSize:largeFont];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label z:0];
		
        //glClearColor(0.0, 0.0, 0.0, 0.0);
        
		// Must wait one frame before loading the target scene!
		// Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) update:(ccTime)delta
{
	// It's not strictly necessary, as we're changing the scene anyway. But just to be safe.
	[self unscheduleAllSelectors];
	
	switch (targetScene_)
	{
		case TargetSceneMultiLayerScene:	
        {
            CCTransitionFade * transition = [CCTransitionFade transitionWithDuration:1 scene:[MultiLayerScene scene] withColor:ccWHITE];
            [[CCDirector sharedDirector] replaceScene:transition];
            
			break;
        }
        case TargetSceneMainMenu:
        {
            [SceneManager goMainMenu];
			break;
		}
			
		default:
        {
            NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene_);
			break;
        }
	}
    
    [self removeChild:label cleanup:NO];
}

-(void) dealloc
{
	NSLog(@"dealloc for LoadingScene got called");

	[super dealloc];
}

@end
