//
//  LevelParser.m
//

#import "LevelParser.h"
#import "Levels.h"
#import "Level.h"
#import "GDataXMLNode.h"

@implementation LevelParser

+ (NSString *)dataFilePath:(BOOL)forSave forChapter:(int)chapter {

    NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i",chapter];
    
    /***************************************************************************
     This method is used to set up the specified xml for reading/writing.
     Specify the name of the XML file you want to work with above.
     You don't have to worry about the rest of the code in this method.
     ***************************************************************************/
    
    NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;   
        NSLog(@"%@ opened for read/write",documentsPath);
    } else {
        NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
        return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    }  
}

+ (Levels *)loadLevelsForChapter:(int)chapter {

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    NSString *name;
    int number;
    BOOL unlocked;
    int stars;
    //NSString *data;
    
    //Game COnfiG : )
    float pStatue;
    float pBananaBunch;
    float pBackPack;
    float pCanteen;
    float pHat;
    float pPineapple;
    
    float setSpeed;
    float setOneStar;
    float setTwoStar;
    float setThreeStar;
    float setHighscore;
    
    Levels *levels = [[[Levels alloc] init] autorelease];

    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE forChapter:chapter];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *nameArray = [element elementsForName:@"Name"];
        NSArray *numberArray = [element elementsForName:@"Number"];
        NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
        NSArray *starsArray = [element elementsForName:@"Stars"];
        NSArray *gameDataArray = [element elementsForName:@"Data"];
        

        if (nameArray.count > 0) {
            GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
            name = [nameElement stringValue];
        }
        if (numberArray.count > 0) {
            GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
            number = [[numberElement stringValue] intValue];
        } 
        if (unlockedArray.count > 0) {
            GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
            unlocked = [[unlockedElement stringValue] boolValue];
        } 
        if (starsArray.count > 0) {
            GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
            stars = [[starsElement stringValue] intValue];
        }         
        
        //NSArray *gameConfig = [doc nodesForXPath:@"//Levels/Level/Data" error:nil];

        for (GDataXMLElement *element in gameDataArray) 
        {
            NSArray * statue= [element elementsForName:@"Statue"];
            NSArray * bananaBunch= [element elementsForName:@"BananaBunch"];
            NSArray * backPack= [element elementsForName:@"BackPack"];
            NSArray * canteen= [element elementsForName:@"Canteen"];
            NSArray * hat= [element elementsForName:@"Hat"];
            NSArray * pineapple= [element elementsForName:@"Pineapple"];
            
            NSArray * speed= [element elementsForName:@"Speed"];
            NSArray * oneStar= [element elementsForName:@"OneStar"];
            NSArray * twoStar= [element elementsForName:@"TwoStar"];
            NSArray * threeStar= [element elementsForName:@"ThreeStar"];
            NSArray * highscore= [element elementsForName:@"Highscore"];
            
            if (statue.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [statue objectAtIndex:0];
                pStatue = [[element stringValue] doubleValue];
            }
            if (bananaBunch.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [bananaBunch objectAtIndex:0];
                pBananaBunch = [[element stringValue] doubleValue];
            }
            if (backPack.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [backPack objectAtIndex:0];
                pBackPack = [[element stringValue] doubleValue];
            }
            if (canteen.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [canteen objectAtIndex:0];
                pCanteen = [[element stringValue] doubleValue];
            }
            if (hat.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [hat objectAtIndex:0];
                pHat = [[element stringValue] doubleValue];
            }
            if (pineapple.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [pineapple objectAtIndex:0];
                pPineapple = [[element stringValue] doubleValue];
            }
            
            
            if (speed.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [speed objectAtIndex:0];
                setSpeed = [[element stringValue] doubleValue];
            }

            if (oneStar.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [oneStar objectAtIndex:0];
                setOneStar = [[element stringValue] doubleValue];
            }

            if (twoStar.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [twoStar objectAtIndex:0];
                setTwoStar = [[element stringValue] doubleValue];
            }

            if (threeStar.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [threeStar objectAtIndex:0];
                setThreeStar = [[element stringValue] doubleValue];
            }
            
            if (highscore.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [highscore objectAtIndex:0];
                setHighscore = [[element stringValue] doubleValue];
            }

        }
        
        Level *level = [[[Level alloc] initWithName:name 
                                                  number: number 
                                                unlocked: unlocked 
                                                   stars: stars 
                                                 pStatue: pStatue 
                                            pBananaBunch: pBananaBunch 
                                               pBackPack: pBackPack 
                                                pCanteen: pCanteen 
                                                    pHat: pHat 
                                              pPineapple: pPineapple
                                                setSpeed: setSpeed
                                              setOneStar: setOneStar
                                              setTwoStar: setTwoStar
                                            setThreeStar: setThreeStar
                                      setHighscore: setHighscore] autorelease];     
        
        [levels.levels addObject:level];
        
    }
    
    [doc release];
    [xmlData release];
    return levels;
}

+ (void)saveData:(Levels *)saveData 
      forChapter:(int)chapter {
    
   
    /*************************************************************************** 
     This method writes data to the xml based on a TemplateData instance
     You will have to be very aware of the intended xml contents and structure
     as you will be wiping and re-writing the whole xml file.
     
     We write an xml by creating elements and adding 'children' to them.
     
     You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
     ***************************************************************************/
    
    // create the <Levels> element
    GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];
    
    // Loop through levels found in the levels array 
    for (Level *level in saveData.levels) {
     
        // create the <Level> element
        GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];
        
        // create the <Name> element
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name"
                                                         stringValue:level.name];   
        // create the <Number> element
        GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number" 
                                                           stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
        // create the <Unlocked> element
        GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked"   
                                                             stringValue:[[NSNumber numberWithBool:level.unlocked] stringValue]];
        // create the <Stars> element
        GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars" 
                                                           stringValue:[[NSNumber numberWithInt:level.stars] stringValue]];
        // create the <Data> element
        GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data"]; 
        
        // enclose variable elements into a <Level> element
        [levelElement addChild:nameElement];
        [levelElement addChild:numberElement];
        [levelElement addChild:unlockedElement];
        [levelElement addChild:starsElement];
        [levelElement addChild:dataElement];

        GDataXMLElement *pStatueElement = [GDataXMLNode elementWithName:@"Statue" 
                                                          stringValue:[[NSNumber numberWithFloat:level.pStatue] stringValue]];
        
        GDataXMLElement *pBananaBunchElement = [GDataXMLNode elementWithName:@"BananaBunch" 
                                                            stringValue:[[NSNumber numberWithFloat:level.pBananaBunch] stringValue]];
        
        GDataXMLElement *pBackPackElement = [GDataXMLNode elementWithName:@"BackPack" 
                                                            stringValue:[[NSNumber numberWithFloat:level.pBackPack] stringValue]];
        
        GDataXMLElement *pCanteenElement = [GDataXMLNode elementWithName:@"Canteen" 
                                                            stringValue:[[NSNumber numberWithFloat:level.pCanteen] stringValue]];
        
        GDataXMLElement *pHatElement = [GDataXMLNode elementWithName:@"Hat" 
                                                            stringValue:[[NSNumber numberWithFloat:level.pHat] stringValue]];
        
        GDataXMLElement *pPineappleElement = [GDataXMLNode elementWithName:@"Pineapple" 
                                                            stringValue:[[NSNumber numberWithFloat:level.pPineapple] stringValue]];
        
        GDataXMLElement *setSpeedElement = [GDataXMLNode elementWithName:@"Speed" 
                                                               stringValue:[[NSNumber numberWithFloat:level.setSpeed] stringValue]];
        
        GDataXMLElement *setOneStarElement = [GDataXMLNode elementWithName:@"OneStar" 
                                                               stringValue:[[NSNumber numberWithFloat:level.setOneStar] stringValue]];
        
        GDataXMLElement *setTwoStarElement = [GDataXMLNode elementWithName:@"TwoStar" 
                                                               stringValue:[[NSNumber numberWithFloat:level.setTwoStar] stringValue]];
        
        GDataXMLElement *setThreeStarElement = [GDataXMLNode elementWithName:@"ThreeStar" 
                                                               stringValue:[[NSNumber numberWithFloat:level.setThreeStar] stringValue]];
        
        GDataXMLElement *setHighscoreElement = [GDataXMLNode elementWithName:@"Highscore" 
                                                               stringValue:[[NSNumber numberWithFloat:level.setHighscore] stringValue]];
        

        [dataElement addChild:pStatueElement];
        [dataElement addChild:pBananaBunchElement];
        [dataElement addChild:pBackPackElement];
        [dataElement addChild:pCanteenElement];
        [dataElement addChild:pHatElement];
        [dataElement addChild:pPineappleElement];
        
        [dataElement addChild:setSpeedElement];
        [dataElement addChild:setOneStarElement];
        [dataElement addChild:setTwoStarElement];
        [dataElement addChild:setThreeStarElement];
        [dataElement addChild:setHighscoreElement];
        
        // enclose each <Level> into the <Levels> element
        [levelsElement addChild:levelElement];
    }
    
    // put the <Levels> element (and everything in it) into the XML doc
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:levelsElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    // overwrite the existing file, being sure to overwrite the proper chapter
    NSString *filePath = [self dataFilePath:TRUE forChapter:chapter];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end