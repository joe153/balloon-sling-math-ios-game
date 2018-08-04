#import "GamePlayConfig.h"
#import "Constants.h"

@implementation GamePlayConfig {
    int requestedLevelAddition;
    int requestedLevelSubtraction;
    int requestedLevelMultiplication;
    int requestedLevelDivision;
}

@synthesize gameCategory;

// singleton
static GamePlayConfig *sharedData = nil;

+ (GamePlayConfig *)instance {

    if (sharedData == nil) {
        sharedData = [[GamePlayConfig alloc] init];
    }
    return sharedData;
}


- (id)init {
    if ((self = [super init])) {

        gameCategory = ADDITION;
        pointTotalForAllLevels = 0;

        // initialize the current level from the saved level
        currentLevel = [self retrieveLastRequestedLevel];

        sharedData = self;

        defaults = [NSUserDefaults standardUserDefaults];
        lastCategoryPlayed = [defaults integerForKey:@"lastCategoryPlayed"];

        // set default completed levels to 1
        if ([defaults integerForKey:@"levelsCompletedAddition"] == 0)
            [defaults setInteger:1 forKey:@"levelsCompletedAddition"];
        if ([defaults integerForKey:@"levelsCompletedSubtraction"] == 0)
            [defaults setInteger:1 forKey:@"levelsCompletedSubtraction"];
        if ([defaults integerForKey:@"levelsCompletedMultiplication"] == 0)
            [defaults setInteger:1 forKey:@"levelsCompletedMultiplication"];
        if ([defaults integerForKey:@"levelsCompletedDivision"] == 0)
            [defaults setInteger:1 forKey:@"levelsCompletedDivision"];

        levelsCompletedAddition = [defaults integerForKey:@"levelsCompletedAddition"];
        levelsCompletedSubtraction = [defaults integerForKey:@"levelsCompletedSubtraction"];
        levelsCompletedMultiplication = [defaults integerForKey:@"levelsCompletedMultiplication"];
        levelsCompletedDivision = [defaults integerForKey:@"levelsCompletedDivision"];

        CCLOG(@" Levels completed over all time: %i", levelsCompletedAddition  );
    }

    return self;
}

- (BOOL)canYouGoToTheFirstLevelOfThisSection:(int)levelNow :(GameCategory)category {

    int thePreviousSection = levelNow - 1;
    if (category == ADDITION) {
        if (levelsCompletedAddition > (thePreviousSection))
            return YES;
        else
            return NO;
    } else if (category == SUBTRACTION) {
        if (levelsCompletedSubtraction > (thePreviousSection))
            return YES;
        else
            return NO;
    } else if (category == MULTIPLICATION) {
        if (levelsCompletedMultiplication > (thePreviousSection))
            return YES;
        else
            return NO;
    } else if (category == DIVISION) {
        if (levelsCompletedDivision > (thePreviousSection))
            return YES;
        else
            return NO;
    } else {
        return NO;
    }
}

- (void)changeLevelToFirstInThisSection:(int)theSection {

    [self requestedLevel:theSection];

    CCLOG(@"Level now equals %i, which is the first level in Section: %i", [self requestedLevel], theSection);
}

#pragma mark LEVEL UP

- (void)increaseLevel {
    [self requestedLevel:([self requestedLevel] + 1)];

    CCLOG(@"Requested level %i completed", [self requestedLevel]);

    if (gameCategory == ADDITION) {
        if ([self requestedLevel] > levelsCompletedAddition) {

            levelsCompletedAddition++;

            [defaults setInteger:levelsCompletedAddition forKey:@"levelsCompletedAddition"];

            CCLOG(@"Addition level %i completed", levelsCompletedAddition);
        }
    } else if (gameCategory == SUBTRACTION) {
        if ([self requestedLevel] > levelsCompletedSubtraction) {
            CCLOG(@"Levels Completed before adding %i ", levelsCompletedSubtraction);

            levelsCompletedSubtraction++;

            [defaults setInteger:levelsCompletedSubtraction forKey:@"levelsCompletedSubtraction"];

            CCLOG(@"Subtraction level %i completed", levelsCompletedSubtraction);
        }

    } else if (gameCategory == MULTIPLICATION) {
        if ([self requestedLevel] > levelsCompletedMultiplication) {

            levelsCompletedMultiplication++;

            [defaults setInteger:levelsCompletedMultiplication forKey:@"levelsCompletedMultiplication"];

            CCLOG(@"Multiplication level %i completed", levelsCompletedMultiplication);
        }

    } else if (gameCategory == DIVISION) {
        if ([self requestedLevel] > levelsCompletedDivision) {

            levelsCompletedDivision++;

            [defaults setInteger:levelsCompletedDivision forKey:@"levelsCompletedDivision"];

            CCLOG(@"Division level %i completed", levelsCompletedDivision);
        }

    }

}

- (int)requestedLevel {
    int l = 0;
    if (gameCategory == ADDITION) {
        if (requestedLevelAddition == 0)
            requestedLevelAddition = [self retrieveLastRequestedLevel];
        l = requestedLevelAddition;
    } else if (gameCategory == SUBTRACTION) {
        if (requestedLevelSubtraction == 0)
            requestedLevelSubtraction = [self retrieveLastRequestedLevel];
        l = requestedLevelSubtraction;
    } else if (gameCategory == MULTIPLICATION) {
        if (requestedLevelMultiplication == 0)
            requestedLevelMultiplication = [self retrieveLastRequestedLevel];
        l = requestedLevelMultiplication;
    } else if (gameCategory == DIVISION) {
        if (requestedLevelDivision == 0)
            requestedLevelDivision = [self retrieveLastRequestedLevel];
        l = requestedLevelDivision;
    }
    if (l == 0)
        l = 1;
    return l;
}

- (void)requestedLevel:(int)level {
    [self saveRequestedLevel:level];

    if (gameCategory == ADDITION) {
        requestedLevelAddition = level;
    } else if (gameCategory == SUBTRACTION) {
        requestedLevelSubtraction = level;
    } else if (gameCategory == MULTIPLICATION) {
        requestedLevelMultiplication = level;
    } else if (gameCategory == DIVISION) {
        requestedLevelDivision = level;
    }
}

- (void)saveRequestedLevel:(int)level {
    NSString *levelString = [NSString stringWithFormat:@"GAME_LEVEL%d", gameCategory];
    [defaults setInteger:level forKey:levelString];
}

- (int)retrieveLastRequestedLevel {
    NSString *levelString = [NSString stringWithFormat:@"GAME_LEVEL%d", gameCategory];
    return [defaults integerForKey:levelString];
}

- (void)purchaseGame {
    [defaults setBool:YES forKey:@"GAME_PURCHASE"];
    [defaults synchronize];
}

- (BOOL)gamePurchased {
    if (APP_PURCHASE_ENABLED) { // test flag is set, allow the user to play all levels if not enabled
        return [defaults boolForKey:@"GAME_PURCHASE"];
    } else {
        return YES;
    }
}

#pragma mark LEVEL UP 


- (int)returnPointsToPassLevel {
    return 10 * [self numberOfQuestions];
}

- (int)returnBonusPerTimeLeft {
    return 1;
}

- (void)addToPointTotalForAllLevels:(int)pointThisLevel {  //this method gets called, but at no point am I ever showing the pointTotalForAllLevels

    pointTotalForAllLevels = pointTotalForAllLevels + pointThisLevel;

}

#pragma mark HIGH SCORES 

- (void)setHighScore:(int)level :(int)theScore {
    if (gameCategory == ADDITION) {
        if (theScore > [self getHighScore:level]) {
            [defaults setInteger:theScore forKey:[NSString stringWithFormat:@"highScoreAdditionLevel%d", level]];
        }
    } else if (gameCategory == SUBTRACTION) {
        if (theScore > [self getHighScore:level]) {
            [defaults setInteger:theScore forKey:[NSString stringWithFormat:@"highScoreSubtractionLevel%d", level]];
        }
    } else if (gameCategory == MULTIPLICATION) {
        if (theScore > [self getHighScore:level]) {
            [defaults setInteger:theScore forKey:[NSString stringWithFormat:@"highScoreMultiplicationLevel%d", level]];
        }
    } else if (gameCategory == DIVISION) {
        if (theScore > [self getHighScore:level]) {
            [defaults setInteger:theScore forKey:[NSString stringWithFormat:@"highScoreDivisionLevel%d", level]];
        }
    } else {
        NSLog(@"ERROR, unknown game category");
    }
    [defaults synchronize];
}

- (int)getHighScore:(int)level {
    if (gameCategory == ADDITION) {
        return [defaults integerForKey:[NSString stringWithFormat:@"highScoreAdditionLevel%d", level]];
    } else if (gameCategory == SUBTRACTION) {
        return [defaults integerForKey:[NSString stringWithFormat:@"highScoreSubtractionLevel%d", level]];
    } else if (gameCategory == MULTIPLICATION) {
        return [defaults integerForKey:[NSString stringWithFormat:@"highScoreMultiplicationLevel%d", level]];
    } else if (gameCategory == DIVISION) {
        return [defaults integerForKey:[NSString stringWithFormat:@"highScoreDivisionLevel%d", level]];
    } else {
        NSLog(@"ERROR, unknown game category");
        return 0;
    }
}

- (void)setHighScoreForLevel:(int)theScore {
    [self setHighScore:[self requestedLevel] :theScore];
}


- (int)returnHighScoreForLevel {
    return [self getHighScore:[self requestedLevel]];
}

- (int)returnHighScoreByLevel:(int)level {
    return [self getHighScore:level];
}

// number of lives available in each level
- (int)numberOfLives {
    int level = [self requestedLevel];
    if (level < 5)
        return 3;
    else if (level < 10)
        return 4;
    else
        return 5;
}

// total correct questions required to pass to the next level
- (int)numberOfQuestions {
    int level = [self requestedLevel];
    int size = (level + 1);

    int MAX_NUMBER = 12; // maximum number of questions

    if (size >= MAX_NUMBER) // set the max question number to be MAX_NUMBER
        size = MAX_NUMBER;

    if (SHOW_ONLY_ONE_QUESTION) // for testing
        return 1;
    else
        return size;
}

// seconds available to complete the level
- (int)numberOfSeconds {
    return [self numberOfQuestions] * 10 + 30; // 10 seconds per question + extra time
}

// speed of balloon going up e.g. 60.0f seems to be too fast
- (float)balloonSpeed {
    float DEFAULT_SPEED = 40.0f; //todo: ideal for iphone but iPad needs to be faster
    float balloonSpeed = DEFAULT_SPEED;

    int level = [self requestedLevel];
    if (level == 1) // no speed variation
        return DEFAULT_SPEED;
    else if (level == 2) { // 2 variations
        NSArray *speeds = [@"40, 50" componentsSeparatedByString:@","];
        NSString *msg = [speeds objectAtIndex:arc4random() % speeds.count];
        balloonSpeed = [msg floatValue];
    } else if (level < 7) {
        NSArray *speeds = [@"40, 50, 60" componentsSeparatedByString:@","];
        NSString *msg = [speeds objectAtIndex:arc4random() % speeds.count];
        balloonSpeed = [msg floatValue];
    } else if (level < 14) {
        NSArray *speeds = [@"30, 40, 50, 60" componentsSeparatedByString:@","];
        NSString *msg = [speeds objectAtIndex:arc4random() % speeds.count];
        balloonSpeed = [msg floatValue];
    } else {
        NSArray *speeds = [@"30, 40, 50, 60, 70" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        balloonSpeed = [tmp floatValue];
    }

    if (IS_IPAD) // because the screen is bigger the speed needs to be faster
        balloonSpeed = balloonSpeed + 20.0f;
    return balloonSpeed;
}

// balloon size (3 is small, 6 is big)
- (int)balloonSize {
    int defaultSize = 8;

    int level = [self requestedLevel];
    if (level == 1) // no speed variation
        return defaultSize;
    else if (level == 2) { // 2 variations
        NSArray *speeds = [@"5, 8" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        return [tmp intValue];
    } else if (level < 5) {
        NSArray *speeds = [@"5, 6, 7" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        return [tmp intValue];
    } else if (level < 10) {
        NSArray *speeds = [@"5, 6, 7, 8" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        return [tmp intValue];
    } else if (level < 15) {
        NSArray *speeds = [@"5, 6, 7, 8" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        return [tmp intValue];
    } else {
        NSArray *speeds = [@"3, 4, 5, 6, 7, 8" componentsSeparatedByString:@","];
        NSString *tmp = [speeds objectAtIndex:arc4random() % speeds.count];
        return [tmp intValue];
    }
}

- (void)dealloc {
    [defaults release];
    [sharedData release];
}


@end
