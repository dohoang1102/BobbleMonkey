//
//  ChapterSelect.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "ChapterSelect.h"  
#import "CCScrollLayer.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"
#import "GameData.h"
#import "GameDataParser.h"
#import <UIKit/UIKit.h>

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

@interface ChapterSelect () {
    CCMenuItemImage *image;
}
@end

@implementation ChapterSelect
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goMainMenu];
}

- (void)onSelectChapter:(CCMenuItemImage *)sender { 
    
    //CCLOG(@"writing the selected stage to GameData.xml as %i", sender.tag);
    GameData *gameData = [GameDataParser loadData];
    [gameData setSelectedChapter:sender.tag];
    [GameDataParser saveData:gameData];    
    [SceneManager goLevelSelect];
}

- (CCLayer*)layerWithChapterName:(NSString*)chapterName 
                   chapterNumber:(int)chapterNumber 
                      screenSize:(CGSize)screenSize {

    CCLayer *layer = [[CCLayer alloc] init];
    
    if (self.iPad) {
        image = [CCMenuItemImage itemFromNormalImage:@"StickyNote-iPad.png" 
                                                        selectedImage:@"StickyNote-iPad.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];
    }
    else {
        image = [CCMenuItemImage itemFromNormalImage:@"StickyNote-iPhone.png" 
                                                        selectedImage:@"StickyNote-iPhone.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];    
    }
    
    // Put a label in the new layer based on the passed chapterName
    int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleSmall;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Chalkduster" fontSize:largeFont];
    layerLabel.position =  ccp( screenSize.width / 2 , screenSize.height / 2 + 10 );
    layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95,58,0);
    [layer addChild:layerLabel];
    
    return layer;
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

-(int) getWidthOffSetForScreenSize: (CGSize) screenSize
{
    int observedWidth = 0;
    
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        observedWidth = screenSize.width;
        
    }
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
    {
        observedWidth = screenSize.height;
        
    }
    
    if (self.iPad) 
    {
        return ((observedWidth - image.boundingBox.size.width) * 0.8);
    }
    else 
    {
        return ((observedWidth - image.boundingBox.size.width));
    }
    

}

- (id)init {
    
    if( (self=[super init])) 
    {
        CCSprite * backGround =[CCSprite spriteWithFile:deviceFile(@"bg_jungle", @"png")];
        [backGround setPosition:CGPointMake(backGround.boundingBox.size.width/2, backGround.boundingBox.size.height/2)];
        [self addChild:backGround z:-1];

        
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        CGSize screenSize = [CCDirector sharedDirector].winSize;  

        NSMutableArray *layers = [NSMutableArray new];

        Chapters *chapters = [ChapterParser loadData];
        
        for (Chapter *chapter in chapters.chapters) {
            // Create a layer for each of the stages found in Chapters.xml
            CCLayer *layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        int widthOffSet = [self getWidthOffSetForScreenSize:screenSize];
        
        NSLog(@"widthOFFSet = %i", widthOffSet);
        
        // Set up the swipe-able layers
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers 
                                                            widthOffset:widthOffSet];

        
        GameData *gameData = [GameDataParser loadData];
        [scroller selectPage:(gameData.selectedChapter -1)];
        
        [self addChild:scroller];
        
        [scroller release];
        [layers release];
        
        [self addBackButton];  

    }
    return self;
}



@end
