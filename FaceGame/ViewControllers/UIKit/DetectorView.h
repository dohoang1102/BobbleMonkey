//
//  DetectorView.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetectorView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIView *previewView; //Check
	AVCaptureVideoPreviewLayer *previewLayer;//Check
	AVCaptureVideoDataOutput *videoDataOutput;//Check
	BOOL detectFaces;//Check
	dispatch_queue_t videoDataOutputQueue;//Check
	BOOL isUsingFrontFacingCamera;//chack
	CIDetector *faceDetector;//check
    AVCaptureSession *session;
}

- (void) pauseSession;
- (void) resumeSession;

@end
