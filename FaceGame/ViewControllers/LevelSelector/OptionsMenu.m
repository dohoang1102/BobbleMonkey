//
//  OptionsMenu.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "OptionsMenu.h"

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

@implementation OptionsMenu
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goMainMenu];
}

- (void)addBackButton {

    if (self.iPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPad.png" 
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPhone.png" 
                                                         selectedImage:@"Arrow-Selected-iPhone.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back];        
    }
}

- (id)init 
{
    if( (self=[super init])) 
    {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];

        CCSprite * backGround =[CCSprite spriteWithFile:deviceFile(@"bg_jungle", @"png")];
        [backGround setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backGround z:-1];
        
        CCSprite * instructions =[CCSprite spriteWithFile:deviceFile(@"instructionsopaque", @"png")];
        [instructions setPosition:CGPointMake(screenSize.width/2, screenSize.height * 0.65)];
        
        if (iPad)
        { 
            [instructions setScale:0.50f];
        }
        else
        {
            [instructions setScale:0.22f];
        }
        
        [self addChild:instructions z:0];
        
       

        [self addBackButton];   

    }
    return self;
}

@end
