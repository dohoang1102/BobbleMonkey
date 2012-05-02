//
//  GameData.m
//

#import "GameData.h"

@implementation GameData

@synthesize selectedChapter = _selectedChapter; 
@synthesize selectedLevel = _selectedLevel;
@synthesize sound = _sound; 
@synthesize music = _music;

-(id)initWithSelectedChapter:(int)chapter
             selectedLevel:(int)level
                     sound:(BOOL)sound
                     music:(BOOL)music {
    
    if ((self = [super init])) {
        
        self.selectedChapter = chapter; 
        self.selectedLevel = level; 
        self.sound = sound;  
        self.music = music; 
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end



