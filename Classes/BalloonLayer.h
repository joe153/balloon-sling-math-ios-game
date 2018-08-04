#import "cocos2d.h"
#import "Game.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface BalloonLayer : CCColorLayer
{
    CGSize windowSize_;
    CGPoint windowCenter_;
    float globalScale_;
    float globalScale_iPad3;
    NSMutableArray *balloons;
    NSMutableArray *bombs;
    int balloonsPopped; // tracks how many balloons are popped

    b2World *world;
	GLESDebugDraw *m_debugDraw;
    b2Body *moving_rec;
    b2BodyDef ballBodyDef;
    b2FixtureDef ballShapeDef;
    b2Body *groundBody;
    
    NSMutableArray	*_bombs;
	CCSprite			*_curBomb;
    CCSprite			*bomb;
    NSMutableArray	*_hearts;
    CCSprite			*heart;
    CCSprite			*_curHeart;
    float speed;
    
    int maxStretchOfSlingShot;

    CGPoint positionInSling;
    float multipyThrowPower; 
    BOOL areWeInTheStartingPosition;
    BOOL slingShotBallInHand;  //if the bakk is in the sling
    BOOL throwInProgress;  //if the ninja is currently being thrown (in midair / midturn basically)

    //sling art
    CGPoint platformStartPosition;
    
    CCSprite *strapFront;
    CCSprite *strapBack;
    CCSprite *strapEmpty;
    
    int screenWidth;
    int screenHeight;
    // Score properties
    unsigned char fontSizeForScore;
    CCLabelTTF *currentQuestionNumber; // shows the current question number e.g. 2/4
    CCLabelTTF *highScoreLabel;
    CGPoint highScoreLabelStartPosition;
    CGPoint currentScoreLabelStartPosition;
    BOOL useImagesForPointScoreLabels;
    BOOL somethingJustScored;
    int pointsToPassLevel;
    int bonusPerTimeLeft;
    int pointTotalThisRound;
    int bonusThisRound;
    int totalPoints;
    Question *question;
    float radiusSQ;

}
@property(nonatomic, retain) Question *question;


// returns a CCScene that contains the BalloonLayer as the only child
+(CCScene *) scene;
-(void) cleanUpSprite: (CCSprite*) balloon;


-(void) popBalloon: (Balloon*) balloon;
-(void) setUpClouds;

-(void) updateBalloons:(ccTime)dt;
-(void) updateClouds:(ccTime)dt;
-(void) showGameOver;
-(void) setUpMenu;

-(void) initBalloonImages;
-(void) initBackgroundMusic;
-(void) initLabels;

-(void) setupDefaults;
-(void) setupWindow;

-(CCLabelTTF*) labelWithString: (NSString*) string fontSize: (int) fontSize position: (CGPoint) position;



-(void) showRound;
-(void)nextLevel;


@end

