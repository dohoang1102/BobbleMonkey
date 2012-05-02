//
//  StopLightIndicator.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "StopLightIndicator.h"

#import <QuartzCore/QuartzCore.h>

static UIColor * StopLightRed()
{
    return [UIColor colorWithRed:(255.0/255.0) green:(0.0/255) blue:(0.0/255) alpha:1.0];
};

static UIColor * StopLightGreen()
{
    return [UIColor colorWithRed:(0.0/255.0) green:(190.0/255) blue:(0.0/255) alpha:1.0];
};

@interface StopLightIndicator()
{
    UIActivityIndicatorView * activityView;
    CALayer * light;
}

@end

@implementation StopLightIndicator

//this is always a square frame. 
- (id)initWithFrame:(CGRect)frame
{
    //NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    self = [super initWithFrame:frame];
    if (self) 
    {
        double radius = frame.size.width/2;
        
        light = [[CALayer alloc] init];
        [light setMasksToBounds:YES];
        [light setCornerRadius:radius ];
        [light setBounds:CGRectMake(0.0f, 0.0f, radius *2, radius *2)];
        [light setFrame:CGRectMake(0.0f, 0.0f, radius*2, radius*2)];
        [[self layer] addSublayer:light];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake(radius/2, radius/2, radius, radius);
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
    }
    return self;
}

-(void) setToStop
{
    light.backgroundColor = [StopLightRed() CGColor];
    [activityView startAnimating];
}

-(void) setToGo
{
    light.backgroundColor = [StopLightGreen() CGColor];
    [activityView stopAnimating];
}


-(void) dealloc
{
    [light release];
    [activityView release];
       
    [super dealloc];
}


@end
