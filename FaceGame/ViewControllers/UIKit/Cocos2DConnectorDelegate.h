//
//  Cocos2DConnectorDelegate.h
//  FaceGame
//
//  Created by Ali Sharif on 12-04-15.
//  Copyright 2012 Ali.Sharif.Faceit!Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Cocos2DConnectorDelegate <NSObject>

-(void) receivedRawDetectorData: (float) data;
-(void) resetGame;

@end
