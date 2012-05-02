//
//  MultiLayerScene.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "MultiLayerScene.h"
#import "SceneManager.h"
#import "SideScroller.h"


@implementation MultiLayerScene

@synthesize iPad;
@synthesize sideScrollerGameLayer = _sideScrollerGameLayer;

// Semi-Singleton: you can access MultiLayerScene only as long as it is the active scene.
static MultiLayerScene* multiLayerSceneInstance;

+(MultiLayerScene*) sharedLayer
{
	NSAssert(multiLayerSceneInstance != nil, @"MultiLayerScene not available!");
	return multiLayerSceneInstance;
}


// Access to the various layers by wrapping the getChildByTag method
// and checking if the received node is of the correct class.
-(SideScroller*) sideScrollerGameLayer
{
	CCNode* layer = [[MultiLayerScene sharedLayer] getChildByTag:SideScrollerGameLayerTag];
	NSAssert([layer isKindOfClass:[SideScroller class]], @"%@: not a UserInterfaceLayer!", NSStringFromSelector(_cmd));
	return (SideScroller*)layer;
}

+(id) scene
{
    NSLog(@"MultilayerSceneInscae Got Created");
    
	CCScene* scene = [CCScene node];
	MultiLayerScene* layer = [MultiLayerScene node];
	[scene addChild:layer];
    [scene setTag:MultiLayerParentScene];
    
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

        //Once the game has started, we start the game
        NSMutableDictionary* gameTime = [NSMutableDictionary dictionary];
        [gameTime setObject:[NSNumber numberWithBool:YES] forKey:@"isGameScenePutUp"]; 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameVCStatusNotification" 
                                                            object:self
                                                          userInfo:gameTime];
        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
		NSAssert(multiLayerSceneInstance == nil, @"another MultiLayerScene is already in use!");
		multiLayerSceneInstance = self;
        
        SideScroller* gameLayer = [SideScroller node];
        [self addChild:gameLayer z:1 tag:SideScrollerGameLayerTag];
        
	}
	
	return self;
}

-(void) dealloc
{
	NSLog(@"Multilayer Scene got dealloced");
	
    NSMutableDictionary* gameTime = [NSMutableDictionary dictionary];
    [gameTime setObject:[NSNumber numberWithBool:NO] forKey:@"isGameScenePutUp"]; 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameVCStatusNotification" 
                                                        object:self
                                                      userInfo:gameTime];

	// The Layer will be gone now, to avoid crashes on further access it needs to be nil.
	multiLayerSceneInstance = nil;

	[super dealloc];
}

@end
