#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ServiceManager;
@class GameData;

// singleton
@interface GamePlayConfig : NSObject {

    //int requestedLevel; // level requested by the user from the level menu
    int currentLevel; // user's best level

    NSUserDefaults *defaults;

    int pointTotalForAllLevels; // total points

    int levelsCompletedAddition;
    int levelsCompletedSubtraction;
    int levelsCompletedMultiplication;
    int levelsCompletedDivision;

    //last category played
    int lastCategoryPlayed;
}

typedef enum {
    ADDITION,
    SUBTRACTION,
    MULTIPLICATION,
    DIVISION
} GameCategory;

@property GameCategory gameCategory;

+ (GamePlayConfig *)instance;


- (int)requestedLevel;
- (void)requestedLevel:(int)level;

-(int) returnPointsToPassLevel;
-(int) returnBonusPerTimeLeft ;
-(int) returnHighScoreForLevel ;
-(int) returnHighScoreByLevel:(int)level;
-(void) setHighScoreForLevel:(int)theScore;
-(void) addToPointTotalForAllLevels:(int)pointThisLevel;


- (BOOL)canYouGoToTheFirstLevelOfThisSection:(int)theSection:(GameCategory)category;

- (void)changeLevelToFirstInThisSection:(int)theSection;

- (void)increaseLevel;

- (void)purchaseGame;

- (BOOL)gamePurchased;

- (int) numberOfLives;

- (int) numberOfQuestions;

- (int) numberOfSeconds;

- (float) balloonSpeed;

- (int) balloonSize;

@end
