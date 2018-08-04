//
//  GameSounds.mm

#import "GameSounds.h"
#import "SimpleAudioEngine.h"

@implementation GameSounds

static GameSounds *sharedGameSounds = nil;

+ (GameSounds *)sharedGameSounds {

    if (sharedGameSounds == nil) {
        sharedGameSounds = [[GameSounds alloc] init];

    }

    return sharedGameSounds;
}


- (void)playBreakSound {
    [[SimpleAudioEngine sharedEngine] playEffect:@"break1.mp3"];
}


- (void)releaseSlingSounds {
    [[SimpleAudioEngine sharedEngine] playEffect:@"whoosh.mp3"];
}


- (void)playBackgroundMusic {
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"birds.mp3" loop:YES];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.15f;

}

- (void)stopBackgroundMusic {
    [[CDAudioManager sharedManager] setMode:kAMM_FxOnly];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)popBalloon {
    [[SimpleAudioEngine sharedEngine] playEffect:@"balloon_pop.mp3" pitch:1 pan:1 gain:0.1f];
}

- (void)explosion {
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
}

- (void)levelCompleted {
    //[[SimpleAudioEngine sharedEngine] playEffect:@"whoosh.mp3"];
}

- (void)incorrectAnswer {
    [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
}

- (void)restartBackgroundMusic {
    [self playBackgroundMusic];
}

-(void)dealloc{
    [sharedGameSounds release];
    [super dealloc];
}

@end
