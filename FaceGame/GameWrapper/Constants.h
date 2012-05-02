//
//  Constants.h
//  
//  This file is used for 'global' variables (constants).  
//  
//  Just ensure you import this header file to use the constants.
//


/*
 Used as a multiplier for calculating font size based on scren size.  Usage: 
 screenSize = [CCDirector sharedDirector].winSize
 fontsize = screenSize.height / kFontScaleLarge;)
*/
#define kFontScaleHuge 6;
#define kFontScaleLarge 9;
#define kFontScaleMedium 10;
#define kFontScaleSmall 12;
#define kFontScaleTiny 14;