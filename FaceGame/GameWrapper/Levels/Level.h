//
//  Level.h
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {

    // Declare variables with an underscore
    NSString *_name;
    int _number;
    BOOL _unlocked;
    int _stars;
    NSString *_data;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;

//Game cOnfiG : )

@property (nonatomic, assign) float pStatue;
@property (nonatomic, assign) float pBananaBunch;
@property (nonatomic, assign) float pBackPack;
@property (nonatomic, assign) float pCanteen;
@property (nonatomic, assign) float pHat;
@property (nonatomic, assign) float pPineapple;

@property (nonatomic, assign) float setSpeed;
@property (nonatomic, assign) float setOneStar;
@property (nonatomic, assign) float setTwoStar;
@property (nonatomic, assign) float setThreeStar;
@property (nonatomic, assign) float setHighscore;

// Custom init method interface
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
      setHighscore:(float) setHighscore;


@end
