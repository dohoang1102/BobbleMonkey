//
//  Level.m
//

#import "Level.h"

@implementation Level

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;

@synthesize pPineapple = _pPineapple;
@synthesize pStatue = _pStatue;
@synthesize pHat = _pHat;
@synthesize pCanteen = _pCanteen;
@synthesize pBackPack = _pBackPack;
@synthesize pBananaBunch = _pBananaBunch;

@synthesize setSpeed = _setSpeed;
@synthesize setOneStar = _setOneStar;
@synthesize setTwoStar = _setTwoStar;
@synthesize setThreeStar = _setThreeStar;
@synthesize setHighscore = _setHighscore;

// Custom init method takes a variable 
// for each class instance variable
- (id)initWithName:(NSString *)name 
            number:(int) number 
          unlocked:(BOOL) unlocked 
             stars:(int) stars 
           pStatue:(float) pStatue 
      pBananaBunch:(float) pBananaBunch 
         pBackPack:(float) pBackPack 
          pCanteen:(float) pCanteen 
              pHat:(float) pHat 
        pPineapple:(float) pPineapple
          setSpeed:(float) setSpeed
        setOneStar:(float) setOneStar
        setTwoStar:(float) setTwoStar
      setThreeStar:(float) setThreeStar
      setHighscore:(float) setHighscore
{

    if ((self = [super init])) 
    {

        // Set class instance variables based 
        // on values given to this method
        self.name = name;  
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        
        self.pPineapple = pPineapple;
        self.pBackPack = pBackPack;
        self.pBananaBunch = pBananaBunch;
        self.pCanteen = pCanteen;
        self.pHat = pHat;
        self.pStatue = pStatue;
        
        self.setHighscore = setHighscore;
        self.setOneStar = setOneStar;
        self.setTwoStar = setTwoStar;
        self.setThreeStar = setThreeStar;
        self.setSpeed = setSpeed;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end