//
// JRubens Inc.
//


#import "Question.h"
#import "Constants.h"

@implementation Question {
    int numberOfTries;
    int correctAnswerWithin;
    BOOL answerReturned;

}


@synthesize answer;
@synthesize questionString;

- (id)init {
    self = [super init];
    if (self) {
        correctAnswerWithin = arc4random() % CORRECT_ANSWER_RETURN_RATE_MAX + 1;
        numberOfTries = 0;
        answerReturned = NO;
    }

    return self;
}


- (void)dealloc {
    [questionString release];
    [super dealloc];
}

//
- (int)possibleAnswer {

    numberOfTries++;
    int possible = [self randomAnswer: answer];
    if (possible == answer) {
        answerReturned = YES;
        numberOfTries = 0; // set the try to zero again
    }

    //int correctAnswerWithin = 3; // return the correct answer within 3 tries

    if (numberOfTries > correctAnswerWithin) {
        numberOfTries = 0; // set the try to zero again
        return answer;
    }
    return possible;
}

- (int)randomAnswer: (int) correctAnswer {
    if (correctAnswer == 0)
        return 1;

    int tmp = arc4random() % 4;

    int plusOrMinus = arc4random() % 2;
    if (plusOrMinus == 1) { // plus
        return correctAnswer + tmp;
    } else { // minus
        return correctAnswer - tmp;
    }
}

// toString
- (NSString *)description {
   return [NSString stringWithFormat:@"%@ = %d", questionString, answer];
}

@end