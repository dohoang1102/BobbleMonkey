//
//  GameDataParser.m
//

#import "GameDataParser.h"
#import "GameData.h"
#import "GDataXMLNode.h"

@implementation GameDataParser  

+ (NSString *)dataFilePath:(BOOL)forSave {

    NSString *xmlFileName = @"GameData";  
    
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

+ (GameData *)loadData { 

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    int selectedChapter;
    int selectedLevel;
    BOOL sound;
    BOOL music;
    
    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    /*************************************************************************** 
     This next line will usually have the most customisation applied because 
     it will be a direct reflection of what you want out of the XML file.
     ***************************************************************************/
    
    NSArray *dataArray = [doc nodesForXPath:@"//GameData" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    /*************************************************************************** 
     We use dataArray to populate variables created at the start of this 
     method. For each variable you will need to:
        1. Create an array based on the elements in the xml
        2. Assign the variable a value based on data in elements in the xml
     ***************************************************************************/
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *selectedChapterArray = [element elementsForName:@"SelectedChapter"];       
        NSArray *selectedLevelArray = [element elementsForName:@"SelectedLevel"];       
        NSArray *soundArray = [element elementsForName:@"Sound"];   
        NSArray *musicArray = [element elementsForName:@"Music"];        
        
        // selectedChapter
        if (selectedChapterArray.count > 0) {
            GDataXMLElement *selectedChapterElement = (GDataXMLElement *) [selectedChapterArray objectAtIndex:0];
            selectedChapter = [[selectedChapterElement stringValue] intValue];
        } 
        // selectedLevel
        if (selectedLevelArray.count > 0) {
            GDataXMLElement *selectedLevelElement = (GDataXMLElement *) [selectedLevelArray objectAtIndex:0];
            selectedLevel = [[selectedLevelElement stringValue] intValue];
        } 
   
        // sound    
        if (soundArray.count > 0) {
            GDataXMLElement *soundElement = (GDataXMLElement *) [soundArray objectAtIndex:0];
            sound = [[soundElement stringValue] boolValue];
        }
        
        // music    
        if (musicArray.count > 0) {
            GDataXMLElement *musicElement = (GDataXMLElement *) [musicArray objectAtIndex:0];
            music = [[musicElement stringValue] boolValue];
        }

    }
    
    /*************************************************************************** 
     Now the variables are populated from xml data we create an instance of
     TemplateData to pass back to whatever called this method.
     
     The initWithExampleInt:exampleBool:exampleString will need to be replaced
     with whatever method you have updaed in the TemplateData class.
     ***************************************************************************/
    
    
    GameData *Data = [[[GameData alloc] initWithSelectedChapter:selectedChapter
                                                 selectedLevel:selectedLevel
                                                         sound:sound
                                                         music:music] autorelease];  
                                                  
    [doc release];
    [xmlData release];
    return Data;
    [Data release];
}

+ (void)saveData:(GameData *)saveData { 
        
    GDataXMLElement *gameDataElement = [GDataXMLNode elementWithName:@"GameData"];
   
    GDataXMLElement *selectedChapterElement = 
    [GDataXMLNode elementWithName:@"SelectedChapter" 
                      stringValue:[[NSNumber numberWithInt:saveData.selectedChapter] stringValue]];

    GDataXMLElement *selectedLevelElement = 
    [GDataXMLNode elementWithName:@"SelectedLevel" 
                      stringValue:[[NSNumber numberWithInt:saveData.selectedLevel] stringValue]];
    
    GDataXMLElement *soundElement = 
    [GDataXMLNode elementWithName:@"Sound"
                      stringValue:[[NSNumber numberWithBool:saveData.sound] stringValue]];
    
    GDataXMLElement *musicElement = 
    [GDataXMLNode elementWithName:@"Music"   
                      stringValue:[[NSNumber numberWithBool:saveData.music] stringValue]];
    
    [gameDataElement addChild:selectedChapterElement];
    [gameDataElement addChild:selectedLevelElement];
    [gameDataElement addChild:soundElement];
    [gameDataElement addChild:musicElement];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:gameDataElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end