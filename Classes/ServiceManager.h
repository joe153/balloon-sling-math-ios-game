//
// JRubens Inc.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "GameData.h"
#import "GamePlayConfig.h"

@class PopBalloonDao;

@interface ServiceManager : NSObject {
    Question *question;
    GameData *gameData;
    PopBalloonDao *dao;
}

// generates a random questionString based on the level provided
- (Question *)getQuestion:(int)level : (GameCategory)category;

- (Question*)additionQuestion: (int) level;

- (Question*)subtractionQuestion: (int) level;

// provides the top 10 scores
- (NSMutableArray*)top10scores;

// saves the score- level and score and name
- (void)saveScores:(NSString *)name : (int)level : (int)score;

// contacts the server with some user info through json
- (void)contactServer;

// returns the level config
- (GameData *)getGameData;

- (NSString *)wellDoneMessage;

@end