//
// JRubens Inc.
//

#import "ServiceManager.h"
#import "Utils.h"
#import "PopBalloonDao.h"

@implementation ServiceManager {

}

// todo: do some random logic here to return additions or subtractions
- (Question *)getQuestion:(int)level :(GameCategory)category {

    if (category == ADDITION) {
        return [self additionQuestion:level];
    } else if (category == SUBTRACTION) {
        return [self subtractionQuestion:level];
    } else if (category == MULTIPLICATION) {
        return [self multiplicationQuestion:level];
    } else if (category == DIVISION) {
        return [self divisionQuestion:level];
    }

    return [self additionQuestion:level];
}

- (Question *)additionQuestion:(int)level {
    question = [[Question alloc] init];

    int min = level - 1;
    int max = level + 2;

    int add1 = arc4random() % max + min;
    int add2 = arc4random() % max + min;

    question.answer = add1 + add2;

    NSMutableString *aString = [NSMutableString stringWithFormat:@"%d", add1];
    [aString appendFormat:@" + %d = ?", add2];
    question.questionString = aString;

    return question;
}


- (Question *)subtractionQuestion:(int)level {
    question = [[Question alloc] init];

    int min = level/2;
    int max = level*2;

    int num1 = arc4random() % max + min + level + 1;
    int num2 = arc4random() % max + min;

    question.answer = num1 - num2;

    NSMutableString *aString = [NSMutableString stringWithFormat:@"%d", num1];
    [aString appendFormat:@" - %d = ?", num2];
    question.questionString = aString;

    return question;
}

- (Question *)multiplicationQuestion:(int)level {
    question = [[Question alloc] init];

    int max = level + 2;

    int num1 = arc4random() % max;
    if (num1 < level/2)
        num1 = num1 + max/2;

    int num2 = arc4random() % max;
    if (num2 < level/2)
        num2 = num2 + max/2;

    question.answer = num1 * num2;

    NSMutableString *aString = [NSMutableString stringWithFormat:@"%d", num1];
    [aString appendFormat:@" x %d = ?", num2];
    question.questionString = aString;

    return question;
}

- (Question *)divisionQuestion:(int)level {
    question = [[Question alloc] init];

    int max = level + 2;

    int num1 = arc4random() % max + 1;
    if (num1 < level/2)
        num1 = num1 + max/2;

    int num2 = arc4random() % max + 1;
    if (num2 < level/2)
        num2 = num2 + max/2;

    int tempAnswer = num1 * num2;
    question.answer = num1;

    NSMutableString *aString = [NSMutableString stringWithFormat:@"%d", tempAnswer];
    [aString appendFormat:@" / %d = ?", num2];
    question.questionString = aString;

    return question;
}

- (NSMutableArray *)top10scores {
    dao = [[PopBalloonDao alloc] init];
    return dao.topScores;
}

- (void)saveScores:(NSString *)name :(int)level :(int)score {
    dao = [[PopBalloonDao alloc] init];
    [dao saveScores:name :level :score];
}

// todo: read from database
- (GameData *)getGameData {

    gameData = [[GameData alloc] init];
    gameData.currentLevel = 5;
    gameData.addition = YES;
    gameData.subtraction = NO;
    gameData.gamePurchased = YES;

    return gameData;
}

- (NSString *)wellDoneMessage {
    NSArray *words_ = [@"WELL DONE!, EXCELLENT!, SPLENDID!, YOU GOT IT!, GREAT!, GOOD JOB!, SMART!, NICE!, AMAZING!, AWESOME!" componentsSeparatedByString:@","];
    NSString *msg = [words_ objectAtIndex:arc4random() % words_.count];
    return msg;
}

- (void)dealloc {
    [question release];
    [gameData release];
    [dao release];
    [super dealloc];
}


@end