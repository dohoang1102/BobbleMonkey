//
//  Chapter.m
//

#import "Chapter.h"

@implementation Chapter 

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;

-(id)initWithName:(NSString*)name number:(int)number {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.name = name; 
        self.number = number; 
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end