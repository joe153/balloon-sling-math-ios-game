//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PopBalloonDao : NSObject

- (NSMutableArray*)topScores;
- (void)saveScores:(NSString *)name : (int)level : (int)score;

@end