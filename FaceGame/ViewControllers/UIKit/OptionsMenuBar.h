//
//  OptionsMenuBar.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OptionsMenuDelegate.h"

//All options in this menu are square shaped
//Currently, the height of the bar is relative to the height of the device screen. 
@interface OptionsMenuBar : UIView

@property (assign) id <OptionsMenuDelegate> delegate;

-(void) showPauseButton: (BOOL) showButton;

@end
