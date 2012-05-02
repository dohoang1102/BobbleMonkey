//
//  ObjectFallingFromSky.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "ObjectFallingFromSky.h"

static id parentLayer; 

@interface ObjectFallingFromSky ()
{
    CCLabelTTF * scoreInformerLabel;
    NSString * ObjectNodeTagsStringDefinition; 
}

@end

@implementation ObjectFallingFromSky

@synthesize doesCollisionKillPlayer = _doesCollisionKillPlayer;
@synthesize incrementScoreBy = _incrementScoreBy;

+(id) objectOfKind:(ObjectNodeTags) tag WithSender: (id) sender
{
    parentLayer = sender;
	return [[[self alloc] initWithObjectImageOfKind:tag] autorelease];
}

-(id) initWithObjectImageOfKind: (ObjectNodeTags) tag
{
    switch (tag) 
    {
        case BananaNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_banana.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"BananaNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 1;
            }
            break;
        }
        case StatueNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_statue.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"StatueNode";
                _doesCollisionKillPlayer = YES;
            }
            break;
        }
        case BananaBunchNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_bananabunch.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"BananaBunchNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 5;
            }
            break;
        }
        case BackPackNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_backpack.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"BackPackNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 10;
            }
            break;
        }
        case CanteenNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_canteen.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"CanteenNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 15;
            }
            break;
        }
        case HatNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_hat.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"HatNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 15;
            }
            break;
        }
        case PineappleNode:
        {
            if ((self = [super initWithSpriteFrameName:@"object_pineapple.png"])) 
            { 
                ObjectNodeTagsStringDefinition = @"StatueNode";
                _doesCollisionKillPlayer = NO;
                _incrementScoreBy = 50;
            }
            break;
        }
        default:
        {
            break;
        }
    }
   
    NSLog(@"%i", ((int)(self.boundingBox.size.height)));
    
    scoreInformerLabel = [CCLabelTTF labelWithString:@"+1" fontName:@"Arial" fontSize:([[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"object_banana.png"].rect.size.height)];
    scoreInformerLabel.color = ccc3(255,0,0);
    [parentLayer addChild:scoreInformerLabel z:90];
    scoreInformerLabel.visible = NO;
    
    self.tag = tag;
    
	return self;
}

#pragma mark - Animations For Collisions 

-(void) performCollisionAnimation
{
    //TO DO: PErform Custom AniMations for each object
    /*
     SEL collisionAnimationSelector = NSSelectorFromString([NSString stringWithFormat:@"%@_CollisionAnimation", ObjectNodeTagsStringDefinition]);
     
     if ([self respondsToSelector:collisionAnimationSelector]) 
     {
     [self performSelector:collisionAnimationSelector];
     }*/
    
    [self generic_CollisionAnimation];
    
    //The debugger raises a warning here but that should not matter, because I check if the class responds to the selector
    if ([parentLayer respondsToSelector:@selector(objectBelowScreen:)]) 
    {
        [parentLayer objectBelowScreen:self];
    }
}

-(void) generic_CollisionAnimation

{
    [scoreInformerLabel setString: [NSString stringWithFormat:@"+ %i", _incrementScoreBy]];
    [self performScoreInformerLabelAnimation];
}

-(void) bananaNode_CollisionAnimation
{
    
    [scoreInformerLabel setString: [NSString stringWithFormat:@"+ %i", _incrementScoreBy]];
    [self performScoreInformerLabelAnimation];

}

-(void) performScoreInformerLabelAnimation
{
    scoreInformerLabel.visible = YES;
    scoreInformerLabel.position = ccp (self.position.x, self.position.y);
    
    CCJumpBy *labelJump = [CCJumpBy actionWithDuration:1 position:ccp(0, 0) height:self.boundingBox.size.height * 7 jumps:1];
    
    id action = [CCSpawn actions: labelJump, [CCFadeOut actionWithDuration:0.5f], nil];
    
    [scoreInformerLabel runAction:action];
}

#pragma mark - Dealloc 

-(void) dealloc
{
	NSLog(@"dealloc for Object Falling from sky");
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
