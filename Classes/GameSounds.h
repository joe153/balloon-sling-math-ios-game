//
//  GameSounds.h

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameSounds : CCNode {

}

+ (GameSounds *)sharedGameSounds;

- (void)releaseSlingSounds;

- (void)playBreakSound;

- (void)playBackgroundMusic;

- (void)stopBackgroundMusic;

- (void)popBalloon;

- (void)explosion;

- (void)levelCompleted;

- (void)incorrectAnswer;

- (void)restartBackgroundMusic;

@end
