//
//  GameDataParser.h
//

#import <Foundation/Foundation.h>

@class GameData;

@interface GameDataParser : NSObject {}

+ (GameData *)loadData;
+ (void)saveData:(GameData *)saveData;

@end