//
//  GameViewController.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectorView.h"
#import "cocos2d.h"
#import "ControlsStabilizerDelegate.h"
#import "OptionsMenuDelegate.h"

typedef enum
{
    forPausedGame,
    forInitialCalibration,
    forLostFace,
    
} WhenControlsStabilizerViewIsVisible;

@interface GameViewController : UIViewController <UIAccelerometerDelegate, ControlsStabilizerDelegate, OptionsMenuDelegate>
{
    DetectorView * detectorView;
    
    CCDirector * director;
}

@end
