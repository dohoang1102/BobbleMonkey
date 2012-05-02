//
//  ControlsStablizer.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlsStabilizerDelegate.h"



@interface ControlsStablizer : UIView 
{
    UIButton * goButton;
}

//Never retain a delegate to avoid "retain loops"
@property (assign) id <ControlsStabilizerDelegate> delegate;

//Accessors
-(void) setupForPausedGame;
-(void) setupForInitialCalibration;
-(void) setUpForLostFace;
-(void) deviceVertical: (BOOL) vertical;
-(void) faceFound: (BOOL) found;
-(void) showGoButton: (BOOL) show;

@end
