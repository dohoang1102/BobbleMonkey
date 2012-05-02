//
//  ControlsStablizer.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "ControlsStablizer.h"
#import "StopLightIndicator.h"
#import <QuartzCore/QuartzCore.h>

@interface ControlsStablizer() 
{

    UILabel * parentRect;
    
    UILabel * pageTitle;
    
    StopLightIndicator * facialIndicator;
    StopLightIndicator * stabilityIndicator;
    
    UILabel * facialIndicatorLabel;
    UILabel * stabilityIndicatorLabel;
    
    BOOL iPad;
}

@end

@implementation ControlsStablizer

@synthesize delegate = _delegate;

- (UILabel *) createUILabelWithFontSize:(double) fontSize withFontName:(NSString *) name withFrame:(CGRect) frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame]; 
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont fontWithName:name size:fontSize]]; 
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    
    return label;
}


#pragma mark - Change Indicators

-(void) showGoButton: (BOOL) show
{
    if (show) {
        goButton.hidden = NO;
    }
    else {
        goButton.hidden = YES;
    }
}

-(void) buttonPressed
{
    goButton.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(120.0/255) blue:(0.0/255) alpha:1.0];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(buttonReleased) userInfo:nil repeats:NO];
}

-(void) buttonReleased
{
    goButton.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(190.0/255) blue:(0.0/255) alpha:1.0];
    [self.delegate dismissControlsStabilierView];
}

-(void) faceFound: (BOOL) found
{
    if (found)
    {
        facialIndicatorLabel.text=@"Face Found!";
        [facialIndicator setToGo];
    }
    else 
    {
        facialIndicatorLabel.text=@"Look At The Screen!";
        [facialIndicator setToStop];
    }
}

-(void) deviceVertical: (BOOL) vertical
{
    if (vertical) 
    {
        stabilityIndicatorLabel.text=@"Device is Vertical!";
        [stabilityIndicator setToGo];
    }
    else 
    {
        stabilityIndicatorLabel.text=@"Make Device Vertical!";
        [stabilityIndicator setToStop];
    }
    
}

#pragma mark - Setup Methods

-(void) setupForPausedGame 
{
    pageTitle.text=@"You Paused It!";
    [self deviceVertical:NO];
    [self faceFound:NO];
    [self showGoButton:NO];
}

-(void) setupForInitialCalibration 
{
    pageTitle.text=@"Calibrating ...";
    [self deviceVertical:NO];
    [self faceFound:NO];
    [self showGoButton:NO];
}

-(void) setUpForLostFace 
{
    pageTitle.text=@"Lost Ya There!";
    [self deviceVertical:NO];
    [self faceFound:NO];
    [self showGoButton:NO];
}

#pragma mark - Life-Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite: 0.2 alpha:0.7];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        float width = 300;
        float height = 440;
        
        parentRect = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - width)/2, (frame.size.height - height)/2, width, height)];
        parentRect.userInteractionEnabled = YES;
        parentRect.backgroundColor = [UIColor clearColor];
        [parentRect.layer setCornerRadius:10];
        [self addSubview:parentRect];
        
        //////////////////////////////// All further drawing happens in parentRect //////////////////////////
        float radius = 20;
        
        /*
         @"Lost Ya There!"
         @"Calibrating ..."
         @"You Paused It!"
         */
        pageTitle = [self createUILabelWithFontSize:33 withFontName:@"Chalkduster" withFrame:CGRectMake(0, 20, parentRect.bounds.size.width, 40)];
        //pageTitle.text=@"Calibrating ...";
        pageTitle.textAlignment = UITextAlignmentCenter;
        [parentRect addSubview: pageTitle];
        
        
        // ------------------------ FACE DETECTION INDICATOR --------------------
        facialIndicator = [[StopLightIndicator alloc] initWithFrame:CGRectMake(20, 100, radius*2, radius*2)];
        [parentRect addSubview:facialIndicator];
        [facialIndicator setToStop];
        
        /*
         @"Look At The Screen!"
         @"Face Found!"
         */
        facialIndicatorLabel = [self createUILabelWithFontSize:23 withFontName:@"Noteworthy-Light" withFrame:CGRectMake(78, 67, parentRect.bounds.size.width-74, 100)];
        //facialIndicatorLabel.text=@"Look At The Screen!";
        [parentRect addSubview:facialIndicatorLabel];
       
         // ------------------------ STABILITY DETECTION INDICATOR --------------------
        stabilityIndicator = [[StopLightIndicator alloc] initWithFrame:CGRectMake(20, 170, radius*2, radius*2)];
        [parentRect addSubview:stabilityIndicator];
        [stabilityIndicator setToStop];
        
        /*
         @"Make the Device Vertical!"
         @"Device is Vertical!"
         */
        stabilityIndicatorLabel = [self createUILabelWithFontSize:23 withFontName:@"Noteworthy-Light" withFrame:CGRectMake(78, 137, parentRect.bounds.size.width-74, 100)];
        //stabilityIndicatorLabel.text=@"Make Device Vertical!";
        [parentRect addSubview:stabilityIndicatorLabel];
        
        
        // ------------------------------- GO BUTTON ---------------------------------
        goButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [goButton setFrame:CGRectMake(20, parentRect.bounds.size.height - 100, parentRect.bounds.size.width - 40, 60)]; 
        [goButton setTitle:@"GO!" forState:UIControlStateNormal];
        goButton.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:30];
        goButton.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(190.0/255) blue:(0.0/255) alpha:1.0];
        goButton.userInteractionEnabled = YES;
        [goButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
        //[goButton addTarget:self action:@selector(buttonReleased) forControlEvents:UIControlEventTouchUpInside];
        [goButton.layer setBorderWidth:2.0];
        [goButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [parentRect addSubview:goButton];
        [self showGoButton:NO];
        
    }
    return self;
}


- (void)dealloc
{
    [parentRect release];
    
    [pageTitle release];
    
    [facialIndicator release];
    [facialIndicatorLabel release];
    
    [stabilityIndicator release];
    [stabilityIndicatorLabel release];
    
    [goButton release];
    
    [super dealloc];
}

@end
