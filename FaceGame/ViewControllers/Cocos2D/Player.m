//
//  Player.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "Player.h"
#import "SideScroller.h"

static id parentLayer; 

@interface Player()
{
    CCAction *monkeyRunningAction;
}
@end

@implementation Player

@synthesize isActionRunning = _isActionRunning;

+(id) playerWithSender: (id) sender
{
    parentLayer = sender;
	return [[[self alloc] initWithPlayerImage] autorelease];
}

-(id) initWithPlayerImage
{
	// Loading the player's sprite using a sprite frame name 
	if ((self = [super initWithSpriteFrameName:@"monkey_arms_up.png"]))
	{
		self.isActionRunning = NO;
	}
	return self;
}

#pragma mark - Player Animations 

-(void) incentiveCaughtAnimation
{
    NSMutableArray *bananaCaughtAnimFrames = [NSMutableArray array];

    [bananaCaughtAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_1.png"]];
    [bananaCaughtAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_arms_up.png"]];

    CCAnimation *bananaCaughtAnim = [CCAnimation animationWithFrames:bananaCaughtAnimFrames delay:0.3f];

    CCAction *bananaCaughtAction = [CCAnimate actionWithAnimation:bananaCaughtAnim restoreOriginalFrame:NO];

    bananaCaughtAction.tag = bananaCaughtAnimationTag;
    
    [self runAction:bananaCaughtAction];
}

-(void) startMonkeyRunningAnimation
{
    NSMutableArray *monkeyRunningAnimFrames = [NSMutableArray array];
    
    [monkeyRunningAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_walk_right_1.png"]];
    [monkeyRunningAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_jump_right.png"]];
    [monkeyRunningAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_walk_right_2.png"]];
    
    CCAnimation *monkeyRunningAnim = [CCAnimation animationWithFrames:monkeyRunningAnimFrames delay:0.2f];
    
    monkeyRunningAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:monkeyRunningAnim restoreOriginalFrame:NO]];
    
    monkeyRunningAction.tag = monkeyRunningAnimationTag;
    
    [self runAction: monkeyRunningAction];
}

-(void) stopMonkeyRunningAnimation
{
    [self stopActionByTag:monkeyRunningAnimationTag];
}

-(void) monkeyDiedAnimation
{
    [parentLayer pauseAllObjects];
    
    self.isActionRunning = YES;
    
    NSMutableArray *monkeyDiedAnimFrames = [NSMutableArray array];
    
    [monkeyDiedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_dead.png"]];
    
    CCAnimation *monkeyDiedAnim = [CCAnimation animationWithFrames:monkeyDiedAnimFrames delay:0.3f];
    CCAction *monkeyDiedAction = [CCAnimate actionWithAnimation:monkeyDiedAnim restoreOriginalFrame:NO];
    
    CCJumpBy *jump = [CCJumpBy actionWithDuration:1 position:CGPointMake(0,-self.boundingBox.size.height) height:self.boundingBox.size.height*2 jumps:1];
    
    id action = [CCSpawn actions: jump, monkeyDiedAction, nil];
    
    CCCallFuncN* call = [CCCallFuncN actionWithTarget:self selector:@selector(resetGame) ];
    
	CCSequence* sequence = [CCSequence actions:action, call, nil];
    
    sequence.tag = monkeyDiedAnimationTag;
    
    [self runAction:sequence];
    
    //[self runAction:monkeyDiedAction];
    //[self runAction:jump];
}

#pragma mark - Resetting Action 

-(void) resetPlayer
{
    NSMutableArray *monkeyResetAnimFrames = [NSMutableArray array];
    [monkeyResetAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_arms_up.png"]];
    CCAnimation *monkeyResetAnim = [CCAnimation animationWithFrames:monkeyResetAnimFrames delay:0.2f];
    [self runAction: [CCAnimate actionWithAnimation:monkeyResetAnim restoreOriginalFrame:NO]];
}

-(void) resetGame
{
    //[parentLayer resetGame];
    [parentLayer gameOver];
}

#pragma mark - Dealloc 

-(void) dealloc
{
	NSLog(@"dealloc for Palyer Scene");

	[super dealloc];
}

@end
