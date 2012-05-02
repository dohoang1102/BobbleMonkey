//
//  GameViewController.m
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import "GameViewController.h"
#import "LoadingScene.h"
#import "ControlsVisualizer.h"
#import "MultiLayerScene.h"
#import "SideScroller.h"
#import "ControlsStablizer.h"
#import "OptionsMenuBar.h"
#import "Cocos2DConnectorDelegate.h"
#import "SceneManager.h"
#import "DetectorView.h"

#define kFilteringFactor 0.05
#define hDeviceTolerance 0.16
#define zDeviceTolerance 0.80

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
static CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

@interface GameViewController ()
{
    ControlsVisualizer * controlsVisualizerLayer;
    ControlsStablizer * controlsStabilizerLayer;
    
    UIAccelerationValue accelerationX;
    UIAccelerationValue accelerationY;
    UIAccelerationValue accelerationZ;
    
    float deviceAngleToHorizontal;
    
    //Keeps track of the number of missed face frames
    int numberOfMissedFaceFrames; 
    
    BOOL isShowingControlsStabilierView;
    
    UIButton * pauseButton;
    OptionsMenuBar *optionMenu;
    
    BOOL isCocosGameInProgress;
    BOOL isGameStarted;
}
@end

@implementation GameViewController

#pragma mark - Cocos2D-Intimate Methods

-(void)gameViewControllerPutUp: (NSNotification *) notification
{
    NSDictionary *messages = notification.userInfo;
    
    BOOL isGameScenePutUp = [[messages objectForKey:@"isGameScenePutUp"] boolValue];
    
    if (isGameScenePutUp) 
    {
        [detectorView resumeSession];
        [self hideOptionsMenu:YES];
        [self showControlsStabilierView:forInitialCalibration];
    }
    else 
    {
        [self hideOptionsMenu:YES];
        [detectorView pauseSession];
    }
}

-(void)gameInProgress: (BOOL) inProgress
{
    isCocosGameInProgress = inProgress;
    
    if (!inProgress) 
    {
        [controlsVisualizerLayer hideControlsVisualizer:YES];
        [self hideOptionsMenu:YES];
    }
    else 
    {
        [controlsVisualizerLayer hideControlsVisualizer:NO];
        [self hideOptionsMenu:NO];
    }
}

-(void) cocos2DReceiver:(NSNotification *) notification
{
    
    //Retrieve messages from dicitonary
    NSDictionary *messages = notification.userInfo;
    
    [self gameInProgress: [[messages objectForKey:@"gameStatus"] boolValue]];
    // isGameStarted = [[messages objectForKey:@"isGameStarted"] boolValue];
    
}

//returns nil if reference to the requested scene is not found
-(id <Cocos2DConnectorDelegate>) returnReferenceToCurrentLayer
{
    
    id <Cocos2DConnectorDelegate> scene = nil;
    
    CCScene * currentScene = [director runningScene];
    
    if (currentScene.tag == MultiLayerParentScene) 
    {
        NSLog(@"got an image");
        
        id layer = [[MultiLayerScene sharedLayer] getChildByTag:SideScrollerGameLayerTag];
        
        if ([layer conformsToProtocol:@protocol(Cocos2DConnectorDelegate)])
        {
            scene = layer;
        }
    }
    
    return scene;
}

#pragma mark - Facial Mathematics

-(CGPoint) findXCoordOnLineGivenPointsOnLineA:(CGPoint) pointA B:(CGPoint) pointB AndYCoord:(CGPoint) mouthPoint
{
    
    CGFloat slope = ((pointB.y - pointA.y)/(pointB.x - pointA.x));
    
    CGFloat yIntercept = pointA.y - (slope * pointA.x);
    
    CGFloat x = (mouthPoint.y - yIntercept) / slope;
    
    return (CGPointMake(x, mouthPoint.y));
}

- (void) verticalLineTrackFaceWithRightEye:(CGPoint)rightEye leftEye:(CGPoint)leftEye andMouth:(CGPoint)mouth andBox:(CGRect)box
{
    
    CGPoint centerOfEyes = CGPointMake ((leftEye.x + ((rightEye.x - leftEye.x)/2)), //X coordinate
                                        - ( (fabsf (rightEye.y - leftEye.y)/2 ) + fminf(-rightEye.y, -leftEye.y) )); //Y coordinate
        
    CGPoint facialBisectorPointA = CGPointMake((centerOfEyes.x + ((box.size.height+ centerOfEyes.y) * tanf(deviceAngleToHorizontal))), 
                                         (-box.size.height));
    
    CGPoint facialBisectorPointB = CGPointMake((centerOfEyes.x - ((- centerOfEyes.y) * tanf(deviceAngleToHorizontal))), 0.0f );
    
    CGPoint facialVertexPoint = [self findXCoordOnLineGivenPointsOnLineA:facialBisectorPointA B:facialBisectorPointB AndYCoord:mouth]; 
    
    NSMutableDictionary* detectorViewProperties = [NSMutableDictionary dictionary];
    
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:centerOfEyes] forKey:@"centerOfEyes"];
    
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:facialBisectorPointA] forKey:@"facialBisectorPointA"];
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:facialBisectorPointB] forKey:@"facialBisectorPointB"];
    
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:rightEye] forKey:@"rightEye"];
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:leftEye] forKey:@"leftEye"];
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:mouth] forKey:@"mouth"];
    
    [detectorViewProperties setObject:[NSValue valueWithCGPoint:facialVertexPoint] forKey:@"facialVertexPoint"];
    
    [controlsVisualizerLayer fillClassVrsWithDictioary:detectorViewProperties];
    [controlsVisualizerLayer setNeedsDisplay];

    // Prepare some normalized data 
    
    float delta = ( ( (facialVertexPoint.x - mouth.x) / box.size.width) * 10);
    
    //Send data to a receiver object to act upon 
    
    id <Cocos2DConnectorDelegate> currentLayer = [self returnReferenceToCurrentLayer];

    if (currentLayer)
    {
        [currentLayer receivedRawDetectorData:delta];
    }
}

#pragma mark - Options Menu Delegate Methods

- (void) pauseGameUsingPauseButton
{
    [self showControlsStabilierView:forPausedGame];
}

-(void)hideOptionsMenu:(BOOL)hideMenu
{
    [optionMenu setHidden:hideMenu];
}

#pragma mark - Re-Calibration Action

//# of missed frames has to be 0 and the device has to be within the horozontal tolerance 
-(void) enableGoButton
{
    
    BOOL deviceVertical;
    BOOL faceInView;
    
    if (numberOfMissedFaceFrames <= 5) {
        faceInView =YES;
        [controlsStabilizerLayer faceFound:YES];
    }
    else {
        faceInView = NO;
        [controlsStabilizerLayer faceFound:NO];
    }
    
    if ((deviceAngleToHorizontal <= hDeviceTolerance && deviceAngleToHorizontal >= -hDeviceTolerance)
        && (accelerationZ <= zDeviceTolerance && accelerationZ >= -zDeviceTolerance) ) {
        deviceVertical = YES;
        [controlsStabilizerLayer deviceVertical:YES];
    }
    else {
        deviceVertical = NO;
        [controlsStabilizerLayer deviceVertical:NO];
    }
    
    if (faceInView & deviceVertical) 
        [controlsStabilizerLayer showGoButton:YES];

    else 
       [controlsStabilizerLayer showGoButton:NO];
    
    
}

-(void) dismissControlsStabilierView
{
    controlsStabilizerLayer.hidden = YES;
    isShowingControlsStabilierView = NO;
    [optionMenu showPauseButton:YES];
    
    if (!isGameStarted) {
        [director resume];
    }
   
    else {
        if (isCocosGameInProgress) {
            [director resume];
        }
    }
    
}

-(void) showControlsStabilierView: (WhenControlsStabilizerViewIsVisible) whenControlsStabilizerViewIsVisible
{
    [optionMenu showPauseButton:NO]; 
    
    isShowingControlsStabilierView = YES;
    
    switch (whenControlsStabilizerViewIsVisible) 
    {
        case forLostFace:
        {
            [controlsStabilizerLayer setUpForLostFace];
            break;
        }
        case forPausedGame:
        {
            [controlsStabilizerLayer setupForPausedGame];
            break;
        }
        case forInitialCalibration:
        {
            [controlsStabilizerLayer setupForInitialCalibration];
            break;
        }
            
        default:
            break;
    }
    
    controlsStabilizerLayer.hidden = NO;
    
    if (director)
    {
        [director pause];
    }
    
}

#pragma mark - Acceleromenter Delegate Method

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    accelerationX = acceleration.x * kFilteringFactor + accelerationX * (1.0 - kFilteringFactor);
    accelerationY = acceleration.y * kFilteringFactor + accelerationY * (1.0 - kFilteringFactor);
    accelerationZ = acceleration.z * kFilteringFactor + accelerationZ * (1.0 - kFilteringFactor);
    
    deviceAngleToHorizontal = -accelerationX;
    
   // NSLog(@"%f", accelerationZ);
}


#pragma mark - Detector Data Receiver

- (void) receiveDetectorData:(NSNotification *) notification
{
    //Retrieve Detector data from dicitonary
    NSDictionary *detectorInfo = notification.userInfo;
    
    NSArray * features = [detectorInfo objectForKey:@"features"];
    CGRect clap = [[detectorInfo objectForKey:@"clap"] CGRectValue];
    
    // Originates in the bottom left of the video frame (Bottom right if mirroring is turned on)
    CGRect previewBox = [[detectorInfo objectForKey:@"previewBox"] CGRectValue];
    CGRect parentFrame = [[detectorInfo objectForKey:@"parentFrame"] CGRectValue];
    //NSString *gravity = [detectorInfo objectForKey:@"gravity"];
    
    NSInteger featuresCount = [features count], currentFeature = 0;
    
    ////////////////////////////////// CALIBRATIONS /////////////////////////////////////
    if(!isShowingControlsStabilierView)
    {
        if (numberOfMissedFaceFrames >=30 || deviceAngleToHorizontal >= hDeviceTolerance || deviceAngleToHorizontal <= -hDeviceTolerance 
            || accelerationZ >= zDeviceTolerance || accelerationZ <= -zDeviceTolerance) 
        {  
            if (isCocosGameInProgress) {
                 [self showControlsStabilierView:forLostFace];
            }
        }
    }
    
    else {
        [self enableGoButton];
    }

    //-----------------------------------------------------------------------------------------------------
	if ( featuresCount == 0 ) {
        numberOfMissedFaceFrames ++;
		return; // early bail.
	}
    else {
        numberOfMissedFaceFrames = 0;
    }
    
    for ( CIFaceFeature *ff in features ) 
    {

    if (ff.hasLeftEyePosition && ff.hasRightEyePosition)
    {
        if (!CGRectEqualToRect(controlsVisualizerLayer.frame, previewBox))
        {
            NSLog(@"Frame Reset");
            controlsVisualizerLayer.frame = CGRectMake(previewBox.origin.x, previewBox.origin.y, previewBox.size.width, previewBox.size.height);
        }
        
        CGFloat widthScaleBy = previewBox.size.height / clap.size.width;
        CGFloat heightScaleBy = previewBox.size.width / clap.size.height;
        
        
        //get coordiates relative to the faceView.frame
        CGPoint rightEye = CGPointMake((- ff.rightEyePosition.y * heightScaleBy) - (parentFrame.size.width - previewBox.size.width),  
                                        (- previewBox.size.height + (ff.rightEyePosition.x* widthScaleBy) - (parentFrame.size.height - previewBox.size.height)));
        
        CGPoint leftEye = CGPointMake((-ff.leftEyePosition.y * heightScaleBy) - (parentFrame.size.width - previewBox.size.width), 
                                       (- previewBox.size.height + (ff.leftEyePosition.x* widthScaleBy) - (parentFrame.size.height - previewBox.size.height)));
        
        CGPoint mouth = CGPointMake((-ff.mouthPosition.y * heightScaleBy) - (parentFrame.size.width - previewBox.size.width), 
                                     (- previewBox.size.height + (ff.mouthPosition.x* widthScaleBy) - (parentFrame.size.height - previewBox.size.height)));
         
        [self verticalLineTrackFaceWithRightEye:rightEye leftEye:leftEye andMouth:mouth andBox:controlsVisualizerLayer.bounds];
    
    }
        currentFeature++;
    
    }
}

#pragma mark - Setup Cocos2D Game Engine

-(void) setupCocos2DViewWithWidth:(int) width Height:(int) height
{
    director = [CCDirector sharedDirector];
    isCocosGameInProgress = NO;
    isGameStarted = NO;
    
	EAGLView* subview = [EAGLView viewWithFrame:CGRectMake(0, 0, width, height) 
                                    pixelFormat:kEAGLColorFormatRGBA8
                                    depthFormat:0
                             preserveBackbuffer:NO
                                     sharegroup:nil
                                  multiSampling:YES
                                numberOfSamples:4];
    [self.view addSubview:subview];
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
	subview.opaque = NO;
    
    if (director.openGLView == nil)
    {
        if ([CCDirector setDirectorType:kCCDirectorTypeDisplayLink] == NO)
        {
            [CCDirector setDirectorType:kCCDirectorTypeDefault];
        }
        
        [director setAnimationInterval:1.0/30];
        [director setDisplayFPS:YES];
        //[director enableRetinaDisplay:YES];
           
        
        if ([subview isKindOfClass:[EAGLView class]]) 
        {
            [director setOpenGLView:(EAGLView*)subview];
            LoadingScene* loadingScene = [LoadingScene sceneWithTargetScene: TargetSceneMainMenu];
            [director runWithScene: loadingScene];
            //[self showControlsStabilierView:forInitialCalibration];
        }
    }
    
    director.openGLView.hidden = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDetectorData:) 
                                                 name:@"FaceDetectedNotification"
                                               object:nil];
    
    //If Game is in progress 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cocos2DReceiver:) 
                                                 name:@"Cocos2DNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameViewControllerPutUp:) 
                                                 name:@"GameVCStatusNotification"
                                               object:nil];
    
    detectorView = [[DetectorView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:detectorView];
    
    
    controlsVisualizerLayer = [[ControlsVisualizer alloc] initWithFrame:CGRectMake(width, height, -width, -height)];
    //controlsVisualizerLayer.layer.borderColor = [UIColor redColor].CGColor;
    //controlsVisualizerLayer.layer.borderWidth = 3.0f;
    //For now
    controlsVisualizerLayer.hidden = NO;
    
    [self.view addSubview:controlsVisualizerLayer];
    
    controlsStabilizerLayer = [[ControlsStablizer alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    controlsStabilizerLayer.hidden = YES;
    controlsStabilizerLayer.delegate = self;
    [self.view addSubview:controlsStabilizerLayer];
                                    
    UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = 1.0f/60.0f;  
    deviceAngleToHorizontal = 0;
        
    optionMenu = [[OptionsMenuBar alloc] initWithFrame:CGRectMake(0, 0, width, height/10)];
    optionMenu.delegate = self;
    [self.view addSubview:optionMenu];
    [self hideOptionsMenu:YES];
    
    [self setupCocos2DViewWithWidth:width Height:height];
    
    //the Controls stabilizer layer needs to be the top-most view 
    //or touch events will not be propagated to it
    [self.view bringSubviewToFront:controlsStabilizerLayer];
    
    [self.view bringSubviewToFront:optionMenu];
    
}

- (void)viewDidUnload
{
    [detectorView release];
    detectorView = nil;
    
    [super viewDidUnload];
}

//For now, the app will only work in portrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [detectorView release];
    [super dealloc];
}
@end
