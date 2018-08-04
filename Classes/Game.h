//
//  Game.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Balloon.h"
#import "Question.h"

@interface Game : NSObject
{
    int score_;
    float timer_;
    int balloonsCollected_;
    int balloonsNeeded_;
    int level_;
    float balloonPace_;
    int lives_;

    NSMutableArray* balloons_;

}

@property (readwrite, assign) int score;
@property (readwrite, assign) float timer;
@property (readwrite, assign) int balloonsCollected;
@property (readwrite, assign) int balloonsNeeded;
@property (readwrite, assign) int level;
@property (readwrite, assign) float balloonPace;
@property (readwrite, assign) int lives;


@property (readonly, retain) NSMutableArray* balloons;

-(id) init;

-(Boolean) isBalloonsCollected;
-(Boolean) isRoundComplete;
-(Boolean) isGameOver;
-(Boolean) isTimeUp;
-(Boolean) isLifeAvailable;
-(Balloon*) newBalloon: (CCSprite*) sprite: (int) possibleAnswer;
-(Balloon*) newBalloonMenu:(CCSprite*)sprite;
-(void) removeBalloon:(id)object;
-(void) refreshGame;


@end
