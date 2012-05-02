//
//  MainMenu.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "MainMenu.h"  
#import "GameData.h"
#import "GameDataParser.h"

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

@implementation MainMenu
@synthesize iPad;

- (void)onPlay: (id) sender {
    [SceneManager goChapterSelect];
}

- (void)onOptions: (id) sender {
    [SceneManager goOptionsMenu];
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

- (id)init {
    
    if( (self=[super init])) 
    {
        CCSprite * backGround =[CCSprite spriteWithFile:deviceFile(@"bg_jungle", @"png")];
        [backGround setPosition:CGPointMake(backGround.boundingBox.size.width/2, backGround.boundingBox.size.height/2)];
        [self addChild:backGround z:-1];

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 

        // Set font settings
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:largeFont];
        
        // Create font based items ready for CCMenu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlay:)];
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"Instructions" target:self selector:@selector(onOptions:)];

        // Add font based items to CCMenu
        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];

        // Align the menu 
        [menu alignItemsVertically];

        // Add the menu to the scene
        [self addChild:menu];
        
        // Testing GameData
        /*
        GameData *gameData = [GameDataParser loadData];

        CCLOG(@"Read from XML 'Selected Chapter' = %i", gameData.selectedChapter);
        CCLOG(@"Read from XML 'Selected Level' = %i", gameData.selectedLevel);
        CCLOG(@"Read from XML 'Music' = %i", gameData.music);
        CCLOG(@"Read from XML 'Sound' = %i", gameData.sound);
        
        gameData.selectedChapter = 7;
        gameData.selectedLevel = 4;
        gameData.music = 0;
        gameData.sound = 0;
        
        [GameDataParser saveData:gameData];
        */
    }
    return self;
}

@end
