//
//  OptionsMenuBar.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "OptionsMenuBar.h"

static UIColor * NormalStateColor()
{
    return [UIColor colorWithRed:(255.0/255.0) green:(110/255) blue:(0.0/255) alpha:1.0];
};

static UIColor * HighlightedStateColor()
{
    return [UIColor colorWithRed:(255.0/255.0) green:(200.0/255) blue:(0.0/255) alpha:1.0];
};

@interface OptionsMenuBar ()
{
    UIButton * pauseButton;
    UIButton * backButton;
}

@end

@implementation OptionsMenuBar

@synthesize delegate = _delegate;

-(void) showPauseButton: (BOOL) showButton
{
    
    if (showButton) 
    {
        pauseButton.hidden = NO;
    } 
    else {
        pauseButton.hidden = YES;
    }
     
}


-(void) pauseButtonPressed
{
     NSLog(@"Button Pressed");
    [pauseButton setTitleColor:HighlightedStateColor() forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pauseButtonReleased) userInfo:nil repeats:NO];

}

-(void) pauseButtonReleased
{
     NSLog(@"Button Pressed");
    [pauseButton setTitleColor:NormalStateColor() forState:UIControlStateNormal];
    [self.delegate pauseGameUsingPauseButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        int fontSize = self.frame.size.height;
        pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //position the pause button at the top left
        [pauseButton setFrame:CGRectMake(0, 0, fontSize, fontSize)];
        [pauseButton setTitle:@"II" forState:UIControlStateNormal];
        pauseButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:fontSize];
        pauseButton.titleLabel.textColor = NormalStateColor();
        [pauseButton setTitleColor:NormalStateColor() forState:UIControlStateNormal];
         [pauseButton setTitleColor:HighlightedStateColor() forState:UIControlStateSelected];
        pauseButton.backgroundColor = [UIColor clearColor];
        
        //pauseButton.userInteractionEnabled = YES;
        [pauseButton addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchDown];
        //[pauseButton addTarget:self action:@selector(pauseButtonReleased) forControlEvents:UIControlEventTouchUpInside];
        //[pauseButton.layer setBorderWidth:5.0];
        [self addSubview:pauseButton];

    }
    return self;
}


@end
