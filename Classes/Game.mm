#import "Game.h"
#import "Constants.h"
#import "Utils.h"
#import "GamePlayConfig.h"

@implementation Game

@synthesize score = score_, timer = timer_, balloonsCollected = balloonsCollected_, balloonsNeeded = balloonsNeeded_, balloons = balloons_, level = level_, balloonPace = balloonPace_, lives = lives_;


- (id)init {
    self.balloonsCollected = 0;
    self.score = 0;
    self.timer = [[GamePlayConfig instance] numberOfSeconds];
    self.level = 1;
    self.balloonsNeeded = [[GamePlayConfig instance] numberOfQuestions];
    self.balloonPace = BALLOON_TIME_FREQUENCY;
    self.lives = [[GamePlayConfig instance] numberOfLives];

    balloons_ = [[NSMutableArray alloc] init];

    return self;
}

- (Boolean)isBalloonsCollected {
    return self.balloonsCollected >= self.balloonsNeeded;
}

- (Boolean)isGameOver {
    return [self isRoundComplete] && ![self isBalloonsCollected];
}

- (Boolean)isRoundComplete {
    return [self isTimeUp] || [self isBalloonsCollected];
}

- (Boolean)isTimeUp {
    return self.timer <= 0;
}

- (Boolean)isLifeAvailable {
    return self.lives <= 0;
}

- (void)refreshGame {
    // reset timer
    self.timer = [[GamePlayConfig instance] numberOfSeconds];

    // score is not reset between rounds
    self.balloonsCollected = 0;
}

- (Balloon *)newBalloon:(CCSprite *)sprite:(int)possibleAnswer {

    int balloonSize = [[GamePlayConfig instance] balloonSize];

    int balloonIndex = possibleAnswer;

    NSLog(@"Balloon Index %d", balloonIndex);

    NSString *balloonNumber = [NSString stringWithFormat:@"%d", balloonIndex];
    Balloon *balloon = [[Balloon alloc] initWithString:balloonSize / 60.0f sprite:sprite string:balloonNumber];

    [balloons_ addObject:balloon];

    return balloon;
}

- (Balloon *)newBalloonMenu:(CCSprite *)sprite {
    return [self newBalloon:sprite :[Utils getRandomNumber:(int) 1 to:(int) 10]];
}


- (void)removeBalloon:(id)object {
    [balloons_ removeObject:object];
}

- (void)dealloc {
    [balloons_ release];
    [super dealloc];
}
@end
