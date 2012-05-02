//
//  ControlsVisualizer.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//


#import "ControlsVisualizer.h"

@implementation ControlsVisualizer

#pragma mark - Setup

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
    
    self.backgroundColor = [UIColor clearColor];
    //self.tag = 1; 
    self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setup];
}

#pragma mark - Setter For Class Variables

-(void) fillClassVrsWithDictioary: (NSDictionary *) dictionary
{
    //jjNSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    rightEye = [[dictionary objectForKey:@"rightEye"] CGPointValue];
    leftEye = [[dictionary objectForKey:@"leftEye"] CGPointValue];
    mouth = [[dictionary objectForKey:@"mouth"] CGPointValue];

    centerOfEyes = [[dictionary objectForKey:@"centerOfEyes"] CGPointValue];

    facialBisectorPointA = [[dictionary objectForKey:@"facialBisectorPointA"] CGPointValue];
    facialBisectorPointB = [[dictionary objectForKey:@"facialBisectorPointB"] CGPointValue];
    
    facialVertexPoint = [[dictionary objectForKey:@"facialVertexPoint"] CGPointValue];
}

#pragma mark - Shape Drawing Methods

- (void) drawLineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGFloat dash[] = {13.0, 2.0};
    CGContextSetLineDash(context, 0, dash, 2);

    CGContextBeginPath (context);
    
    CGContextMoveToPoint(context, pointA.x, pointA.y);
    CGContextAddLineToPoint(context, pointB.x, pointB.y);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void) drawCircleAtPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, YES);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

-(void) hideControlsVisualizer: (BOOL) hide
{
    if (hide) 
    {
        self.hidden = YES;
    }
    else 
    {
        self.hidden = NO;
    }
    
}
#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad; 
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, self.bounds);
    CGContextSetLineWidth(context, debugLineWidth);
    
         CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.9, 0.6);
    //[[UIColor blueColor] setStroke];
    
    if (iPad)
    {
        debugCircleRadius = 5;
        debugLineWidth = 5;
    }
    else 
    {
        debugCircleRadius = 3;
        debugLineWidth = 3;
    }
    
    
    //Draw debug shapes 
    [self drawCircleAtPoint:rightEye withRadius:debugCircleRadius inContext:context];
    [self drawCircleAtPoint:leftEye withRadius:debugCircleRadius inContext:context];
    [self drawCircleAtPoint:mouth withRadius:debugCircleRadius inContext:context];
    //[self drawCircleAtPoint:centerOfEyes withRadius:debugCircleRadius inContext:context];
    //[self drawCircleAtPoint:facialVertexPoint withRadius:debugCircleRadius inContext:context];
    [self drawLineFromPointA:facialBisectorPointA toPointB:facialBisectorPointB  inContext:context];
    
    //CGContextRelease(context);
}


@end
