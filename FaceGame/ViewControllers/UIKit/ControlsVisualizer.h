//
//  ControlsVisualizer.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//


#import <UIKit/UIKit.h>

//Dedicated view to perfom drawing of reference markers on screen for visualization of the controls mechanism 
@interface ControlsVisualizer : UIView
{
    CGPoint rightEye;  
    CGPoint leftEye;
    CGPoint mouth;
    
    CGPoint centerOfEyes;
    
    CGPoint facialBisectorPointA; 
    CGPoint facialBisectorPointB;
    
    CGPoint facialVertexPoint;
    
    double debugCircleRadius;
    double debugLineWidth;
    
    BOOL iPad;
}

-(void) fillClassVrsWithDictioary: (NSDictionary *) dictionary;
-(void) hideControlsVisualizer: (BOOL) hide;

@end
