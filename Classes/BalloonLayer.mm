//  BalloonLayer.m

#import "BalloonLayer.h"
#import "ServiceManager.h"
#import "Constants.h"
#import "PauseLayer.h"
#import "Utils.h"
#import "GameOverLayer.h"
#import "LevelMenu.h"
#import "CustomAnimation.h"
#import "DialogLayer.h"
#import "HelpLayer.h"
#import "BuyGameScene.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

//#define SLING_POSITION			ccp(60,157)
#define SLING_POSITION            platformStartPosition
#define SLING_BOMB_POSITION        ccpAdd(platformStartPosition, ccp(0,27)) //0,9
#define SLING_MAX_ANGLE            360
#define SLING_MIN_ANGLE            0
#define SLING_TOUCH_RADIUS_IPAD    200
#define SLING_TOUCH_RADIUS         100
#define SLING_LAUNCH_RADIUS_IPAD   110
#define SLING_LAUNCH_RADIUS        60

CCLabelTTF *scoreLabel;
CCLabelTTF *timerLabel;
CCLabelTTF *levelLabel;
CCLabelBMFont *questionLabel;

CGPoint origin;

ccColor3B black;
NSString *font;

// define available balloon colors
NSArray *balloonImages;

NSMutableArray *clouds;
Game *game;
ServiceManager *serviceManager;

/**
 The number of seconds since the last balloon was released.
 */
float secondsSinceLastBalloon = 0;

// BalloonLayer implementation
@implementation BalloonLayer {
    CGPoint slingShotCenterPosition;
}

@synthesize question;


+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    BalloonLayer *layer = [BalloonLayer node];

    // add layer as a child to scene
    [scene addChild:layer];

    // return the scene
    return scene;
}

/**
 Performs all of the initialization for the layer.
 @returns CCLayerColor
 */
- (id)init {
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if ((self = [super initWithColor:ccc4(204, 243, 255, 255)])) {

        [self setupWindow];

        [self setupDefaults];
        [self initBalloonImages];

        //CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);

        screenWidth = (int) windowSize_.width;
        screenHeight = (int) windowSize_.height;

        game = [[Game alloc] init];
        serviceManager = [[ServiceManager alloc] init];


        self.isTouchEnabled = YES;

        pointTotalThisRound = 0;
        pointsToPassLevel = [[GamePlayConfig instance] returnPointsToPassLevel];

        bonusPerTimeLeft = [[GamePlayConfig instance] returnBonusPerTimeLeft];

        useImagesForPointScoreLabels = YES; //IF NO, means you use Marker Felt text for scores


        _bombs = [[NSMutableArray array] retain];
        _hearts = [[NSMutableArray array] retain];

        maxStretchOfSlingShot = 400; //best to leave as is, since this value ties in closely to the image size of strap.png. (should be 1/4 the size of the source image)
        multipyThrowPower = 1; // fine tune how powerful the sling shot is. Range is probably best between .5 to 1.5, currently for the iPad 1.0 is good

        throwInProgress = NO; //is a throw currently in progress, as in, is a ninja in midair (mostly used to prevent tossing two ninjas, one right after another)
        areWeInTheStartingPosition = YES;  //is the world back at 0 on the X axis (if yes, then we can put a ninja in the sling)

        strapFront = [CCSprite spriteWithSpriteFrameName:@"strap"];
        [self addChild:strapFront z:depthStrapBack];

        strapBack = [CCSprite spriteWithSpriteFrameName:@"strapBack"];
        [self addChild:strapBack z:depthStrapBack];

        strapEmpty = [CCSprite spriteWithSpriteFrameName:@"strapEmpty"];
        [self addChild:strapEmpty z:depthStrapBack];

        strapBack.visible = NO;  //visible only when stretching
        strapFront.visible = NO; //visible only when stretching
        if (IS_IPAD) { //iPADs..
            platformStartPosition = ccp(150, 95 );
            highScoreLabelStartPosition = ccp( 120, windowSize_.height - 100 );
            fontSizeForScore = 18;
            currentScoreLabelStartPosition = ccp( 120, windowSize_.height - 80); //score label
            //sling shot
            slingShotCenterPosition = ccp(150, 140 ); // 62,70
            strapFront.position = ccp(slingShotCenterPosition.x, slingShotCenterPosition.y  );
            strapBack.position = ccp(slingShotCenterPosition.x + 35, slingShotCenterPosition.y - 3 );
            strapEmpty.position = ccp(155, 115 );
        } else {
            platformStartPosition = ccp(70, 45 );
            highScoreLabelStartPosition = ccp( 120, windowSize_.height - 70 );
            fontSizeForScore = 18;
            currentScoreLabelStartPosition = ccp( 120, windowSize_.height - 50); //score label
            //sling shot
            slingShotCenterPosition = ccp(70, 68 ); // 62,70
            strapFront.position = ccp(slingShotCenterPosition.x, slingShotCenterPosition.y  );
            strapBack.position = ccp(slingShotCenterPosition.x + 17, slingShotCenterPosition.y - 5 );
            strapEmpty.position = ccp(72, 63 );
        }


        // Initialize arrays
        balloons = [[NSMutableArray alloc] init];
        bombs = [[NSMutableArray alloc] init];
        [self setupPhysicsWorld];
        // Create score label
        currentQuestionNumber = [CCLabelTTF labelWithString:@" " dimensions:CGSizeMake(200, 40) alignment:CCTextAlignmentLeft
                                                   fontName:@"Marker Felt" fontSize:fontSizeForScore];
        [self addChild:currentQuestionNumber z:depthScore];
        [currentQuestionNumber setColor:ccc3(0, 0, 0)];
        currentQuestionNumber.position = currentScoreLabelStartPosition;


        highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i", [[GamePlayConfig instance]
                returnHighScoreForLevel]] dimensions:CGSizeMake(200, 40) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:fontSizeForScore];
        [self addChild:highScoreLabel z:depthScore];
        [highScoreLabel setColor:ccc3(0, 0, 0)];

        highScoreLabel.position = highScoreLabelStartPosition;

        [self updatePointsLabel];

        [self setupBackground];
        [self setupLives];
        [self setupBombs];
        [self setupNextBomb];

        [self setupSchedule];
        [self initBackgroundMusic];

        [self setUpClouds];
        [self initLabels];
        [self showRound];
        //[self updateScore:0];
        [self updateQuestion];

        [self setUpMenu];
        [self schedule:@selector(update:)];
    }
    return self;
}

/**
 Updates the score
 @param delta Time since the last frame, in seconds.
 */
- (void)updateScore:(Balloon *)balloon {
    //game.score += delta;
    [self showPoints:balloon.pointValue positionToShowScore:balloon.sprite.position theSimpleScoreVisualFX:balloon.simpleScoreVisualFX];  //show points
    // [lblScore setString:[[NSString alloc] initWithFormat:@"Questions right: %2d/%2d",
    //                                                      game.balloonsCollected, game.balloonsNeeded]];
}

/**
 Updates the questions
 @param delta Time since the last frame, in seconds.
 */
- (void)updateQuestion {
    int requestedLevel = [[GamePlayConfig instance] requestedLevel];
    GameCategory gameCategory = [[GamePlayConfig instance] gameCategory];
    Question *q = [serviceManager getQuestion:requestedLevel :gameCategory];
    self.question = q;
    [q release];
    [questionLabel setString:[NSString stringWithFormat:question.questionString]];
}

/**
 Updates the time based on a delta time slice. Called by nextFrame.
 @param delta Time since the last frame, in seconds.
 */
- (void)updateTime:(float)delta {
    game.timer -= delta;
    if ((int) game.timer < 11) {
        timerLabel.color = ccRED;
    }

    [timerLabel setString:[NSString stringWithFormat:@"Time: %2d", (int) game.timer]];
}

/**
 Setup the balloon images
 */
- (void)initBalloonImages {
    balloonImages = [[NSArray alloc] initWithObjects:@"balloon_blue", @"balloon_brown", @"balloon_cyan", @"balloon_lime", @"balloon_olive", @"balloon_orange", @"balloon_pink", @"balloon_purple", @"balloon_red", nil];
}

/**
 Setups the defaults for the game
 */
- (void)setupDefaults {
    black = ccc3(0, 0, 0);
    font = @"Helvetica-Bold";
    globalScale_ = 5; //1.5
    globalScale_iPad3 = 6;
    origin = ccp(0, 0);
}

/**
 Initializes the window measurements for use in positioning.
 */
- (void)setupWindow {
    // ask director the the window size
    windowSize_ = [[CCDirector sharedDirector] winSize];
    windowCenter_ = ccp(windowSize_.width / 2, windowSize_.height / 2);
}

/**
 Initializes the background music.
 */
- (void)initBackgroundMusic {
    [[GameSounds sharedGameSounds] playBackgroundMusic];
}

/**
 Sets up the scheduler
 */
- (void)setupSchedule {
    // schedule a repeating callback on every frame
    [self schedule:@selector(nextFrame:)];

}

- (void)update:(ccTime)dt {

    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in bombs) {
        CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width / 2),
                projectile.position.y - (projectile.contentSize.height / 2),
                projectile.contentSize.width,
                projectile.contentSize.height);

        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (Balloon *balloon in game.balloons) {
            // we have to refine this bounding box later
            CGRect targetRect = [balloon.sprite boundingBox];

            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                [self popBalloon:balloon];
                [targetsToDelete addObject:balloon];
                break;
            }
        }

        for (CCSprite *target in targetsToDelete) {
            [balloons removeObject:target];
            [self removeChild:target cleanup:YES];
        }

        if (targetsToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }

        [targetsToDelete release];
    }

    for (CCSprite *projectile in projectilesToDelete) {
        [bombs removeObject:projectile];
        b2Body *spriteBody = NULL;
        for (b2Body *b = world->GetBodyList(); b; b = b->GetNext()) {
            if (b->GetUserData() != NULL) {
                CCSprite *curSprite = (CCSprite *) b->GetUserData();
                if (projectile == curSprite) {
                    spriteBody = b;
                    break;
                }
            }
        }
        if (spriteBody != NULL) {
            world->DestroyBody(spriteBody);
        }
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    //It is recommended that a fixed time step is used with Box2D for stability
    //of the simulation, however, we are using a variable time step here.
    //You need to make an informed choice, the following URL is useful
    //http://gafferongames.com/game-physics/fix-your-timestep/

    int32 velocityIterations = 8;
    int32 positionIterations = 1;

    // Instruct the world to perform a single step of simulation. It is
    // generally best to keep the time step and iterations fixed.
    world->Step(dt, velocityIterations, positionIterations);


    //Iterate over the bodies in the physics world
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetUserData() != NULL) {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            CCSprite *myActor = (CCSprite *) b->GetUserData();
            if (myActor != NULL) {
                if (b != NULL) {
                    myActor.position = CGPointMake(b->GetPosition().x * PTM_RATIO,
                            b->GetPosition().y * PTM_RATIO);
                    myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                    //myActor.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle());
                }
            }
        }
    }

    if (moving_rec) {
        //b2Vec2 pos = moving_rec->GetPosition();    
        b2Vec2 pos = b2Vec2(0.0f, -9.8f);
        CGPoint newPos = ccp(-1 * pos.x * PTM_RATIO, self.position.y * PTM_RATIO);
        [self setPosition:newPos];
    }

}


/**
Initializes the labels used in the layer.
*/
- (void)initLabels {
    // score display
    scoreLabel = [self labelWithString:@"Answer right: 0/10" fontSize:20];
    scoreLabel.color = ccc3(255, 0, 0);
    scoreLabel.visible = false;
    CGSize lblSize = scoreLabel.boundingBox.size;
    scoreLabel.position = ccp(lblSize.width / 2 + lblSize.width / 10, windowSize_.height - lblSize.height / 2);

    // questionString display
    questionLabel = [CCLabelBMFont labelWithString:@"X + Y =" fntFile:DIALOG_FONT];
    if (IS_IPAD && [Utils isRetineDisplay]) { //iPADs..
        questionLabel.scale = 3.0f;
    } else if ([Utils isRetineDisplay]) {
        questionLabel.scale = 1.84f;
    } else {
        questionLabel.scale = 0.84f;
    }
    [self addChild:questionLabel z:200]; // question in front of the balloon
    CGSize lblQuestionSize = questionLabel.boundingBox.size;
    questionLabel.position = ccp(windowSize_.width / 2, windowSize_.height - lblQuestionSize.height / 2);

    // timer display        
    timerLabel = [self labelWithString:@"Time: 0  " fontSize:20];
    timerLabel.position = ccp(windowSize_.width - timerLabel.boundingBox.size.width / 2 - timerLabel.boundingBox.size.width / 10,
    windowSize_.height - timerLabel.boundingBox.size.height / 2);

    levelLabel = [self labelWithString:@"1 Question" fontSize:50];

}

/**
 Creates a CCLabelTTF using the passed parameters and default values.
 @param string
 @param fontSize
 @param position
 @returns A CCLabelTTF object
 */
- (CCLabelTTF *)labelWithString:(NSString *)string fontSize:(int)fontSize {
    CCLabelTTF *lbl = [CCLabelTTF labelWithString:string fontName:font fontSize:fontSize];
    lbl.position = windowCenter_;
    lbl.color = black;
    [self addChild:lbl];
    return lbl;
}

/**
 Sets up the menu used in this layer, shown when the game is over.
 */
- (void)setUpMenu {

    CCMenuItemSprite *pauseBtn = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pause"]
                                                                 target:self selector:@selector(showPause)];

    CCLabelTTF *lblMainMenu = [CCLabelTTF labelWithString:@"Main Menu" fontName:font fontSize:30];
    lblMainMenu.color = black;

    CCMenu *menu_ = [CCMenu menuWithItems:pauseBtn, nil];
    if (IS_IPAD) { //iPADs..
        menu_.position = ccp(windowSize_.width - pauseBtn.boundingBox.size.width,
        pauseBtn.boundingBox.size.height);
    } else {
        menu_.position = ccp(windowSize_.width - pauseBtn.boundingBox.size.width,
        pauseBtn.boundingBox.size.height);
    }

    [self addChild:menu_];
}

/**
 Shows the round notice when the round rolls over and fades out
 */
- (void)showRound {
    levelLabel.string = [NSString stringWithFormat:@"Level %d", [[GamePlayConfig instance] requestedLevel]];
    levelLabel.visible = true;
    [levelLabel runAction:[CCFadeOut actionWithDuration:2]];
    // show the help pop up if the level is 1
    if ([[GamePlayConfig instance] requestedLevel] == 1) {
        CCLayer *dialogLayer = [[[HelpLayer alloc]
                initWithHeader2Buttons:@""
                                target:self
                              selector:@selector(test)
                               target2:self] autorelease];
        [self addChild:dialogLayer z:200];
    }
}

- (void)test {

}

/**
Moves the game into the next round.
*/
- (void)nextLevel {
    [[GamePlayConfig instance] increaseLevel];
    //[[CCDirector sharedDirector] pushScene:[LevelMenu scene]];

    // result screen
    CCLayer *dialogLayer = [[[DialogLayer alloc]
            initWithHeader3Buttons:[NSString stringWithFormat:@"Level %d Passed!", ([[GamePlayConfig instance] requestedLevel] - 1)] // level already increased at this point
                          andLine1:[NSString stringWithFormat:@"Score: %d", totalPoints]
                          andLine2:[NSString stringWithFormat:@"High Score: %d", [[GamePlayConfig instance] returnHighScoreByLevel:([[GamePlayConfig instance] requestedLevel] - 1)]]
                          andLine3:@""
                            target:self
                          selector:@selector(showRetry)
                           target2:self
                          selector:@selector(showLevelMenu)
                           target3:self
                          selector:@selector(nextLevelButton)] autorelease];

    [self addChild:dialogLayer z:200];
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
}

- (void)setupPhysicsWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -9.8f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);

    m_debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(m_debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    m_debugDraw->SetFlags(flags);

    //    contactListener = new ContactListener();
    //    world->SetContactListener(contactListener);

    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner

    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    //groundBody = world->CreateBody(&groundBodyDef);
}

/**
 Initializes the clouds for the scene
 */
- (void)setUpClouds {
    clouds = [[NSMutableArray alloc] initWithObjects:nil];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int cloudCount = CLOUD_COUNT;
    for (int i = 0; i < cloudCount; i++) {
        CCSprite *cloud = [CCSprite spriteWithFile:@"cloud.png"];
        cloud.scale = 0.5 + (arc4random() % 3) / 10.0f; // cloud size
        int yPosition = [Utils getRandomNumber:(int) winSize.height / 2 to:(int) winSize.height];
        int xPosition = arc4random() % (int) winSize.width;
        cloud.position = ccp(xPosition, yPosition);

        [clouds addObject:cloud];
        [self addChild:cloud];
    }
}

/**
 Event registration for touches
 */
- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

/**
 Called to process the next frame of animation.
 @param dt The number of seconds elasped since the last frame.
 */
- (void)nextFrame:(ccTime)dt {
    [self updateClouds:dt];

    if ([game isGameOver]) {
        [self performSelector:@selector(showGameOver) withObject:nil afterDelay:1.0f];
        return;
    }
    else if ([game isRoundComplete]) {

        if (pointTotalThisRound >= pointsToPassLevel) {
            // [[GameSounds sharedGameSounds] levelCompleted];

            [self performSelector:@selector(resetOrAdvanceLevel) withObject:nil];
            if ([[GamePlayConfig instance] gamePurchased] == YES
                    || [[GamePlayConfig instance] requestedLevel] < IAP_LEVEL) { // allow the game until level IAP_LEVEL
                [self performSelector:@selector(nextLevel) withObject:nil afterDelay:3.0f];
                 [[CCDirector sharedDirector] pause];
                [game refreshGame];
            } else { // redirect the user to the buy screen
                [self performSelector:@selector(showBuyScreen) withObject:nil afterDelay:2.0f];
            }
        }
        return;
    }
    else if ([game isLifeAvailable]) {
        [self performSelector:@selector(showGameOver) withObject:nil afterDelay:3.0f];
        return;
    }

    [self updateTime:dt];
    [self updateBalloons:dt];
}


/**
Shows the Buy notice when the round rolls over.
*/
- (void)showBuyScreen {
    [[CCDirector sharedDirector] pushScene:[BuyGameLayer scene]];
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
}

- (void)showRetry {
    [[CCDirector sharedDirector] pushScene:[BalloonLayer scene]];
}

- (void)showLevelMenu {
    // Run the intro Scene
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}

- (void)nextLevelButton {
    // this is not needed
//    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}


/**
 Updates balloon positions.
 @param dt The number of seconds elasped since the last frame.
 */
- (void)updateBalloons:(ccTime)dt {
    // raise all balloons
    for (Balloon *balloon in game.balloons) {
        [balloon raise:dt * (balloon.speed)];
    }

    secondsSinceLastBalloon += dt;
    if (secondsSinceLastBalloon > game.balloonPace) {
        [self newBalloon];
        secondsSinceLastBalloon = 0;
    }
}

/**
 Updates cloud positions.
 @param dt The number of seconds elasped since the last frame.
 */
- (void)updateClouds:(ccTime)dt {
    // all clouds move right
    for (CCSprite *cloud in clouds) {
        CGPoint pos = cloud.position;
        pos.x += dt * 15;
        CGSize cloudSize = cloud.boundingBox.size;

        if (pos.x > windowSize_.width) {
            pos.x = -cloudSize.width;
        }
        cloud.position = pos;
    }
}

/**
 Processes a game over.
 */
- (void)showGameOver {
    [[CCDirector sharedDirector] pushScene:[GameOverLayer scene]];
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
}

/**
 * Creates a new balloon
 * @returns Balloon* A pointer to a balloon
 */
- (void)newBalloon {
    NSString *spriteFile = [balloonImages objectAtIndex:arc4random() % balloonImages.count];
    CCSprite *balloonSprite = [CCSprite spriteWithSpriteFrameName:spriteFile];
    Balloon *balloon = [game newBalloon:balloonSprite :question.possibleAnswer];

    if (IS_IPAD) { //iPADs..
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            balloon.sprite.scale *= globalScale_; //CCLOG(@"must be iPad 1 or 2");
        } else {
            balloon.sprite.scale *= globalScale_iPad3; //CCLOG(@"retina display is on-must be iPAd 3");
        }
    } else {  //IPHONES..
        balloon.sprite.scale *= globalScale_;
    }

    int minX = (int) windowSize_.width - (int) (windowSize_.width * 0.7); // 70% of the screen
    int maxX = (int) windowSize_.width - (int) balloon.sprite.boundingBox.size.height;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    [balloon setPosition:ccp(actualX, -balloon.sprite.boundingBox.size.height)];

    [self addChild:balloon.sprite];
    [self addChild:balloon.label];
    [balloon release];
}

/**
 Shows an explosion at the passed coordinates
 @param x
 @param y
 */
- (void)explosionAt:(float)x y:(float)y {
    CCParticleSystem *emitter = [CCParticleExplosion node];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"stars-grayscale.png"];
    emitter.autoRemoveOnFinish = YES;
    emitter.position = ccp(x, y);
    emitter.life = 0.2;
    emitter.duration = 0.5;
    emitter.scale = 0.5;
    emitter.speed = 100;

    //For not showing color
    emitter.blendAdditive = NO;

    [self addChild:emitter];
}

/**
 Cleans a balloon from the display.
 @param sender
 @param balloon
 */
- (void)cleanUpBalloon:(id)sender data:(Balloon *)balloon {
    [game removeBalloon:balloon];
    [self cleanUpSprite:sender];
}


/**
 Cleans up a sprite from the display.
 */
- (void)cleanUpSprite:(CCSprite *)inSprite {
    // call your destroy particles here
    // remove the sprite
    [self removeChild:inSprite cleanup:YES];
}


/**
 Called when a player touches a balloon to process popping animations
 @param balloon The balloon to pop
 */
- (void)popBalloon:(Balloon *)balloon {
    CGPoint pos = balloon.sprite.position;

    [[GameSounds sharedGameSounds] popBalloon];

    [self explosionAt:pos.x y:pos.y];
    NSLog(@"BALLOON LABEL %@", balloon.string);
    if (question.answer == [balloon.string intValue]) { // correctly answered

        balloonsPopped++;
        game.balloonsCollected++;
        [self updateQuestion];

        [self updateScore:balloon];
        CGSize s = [CCDirector sharedDirector].winSize;

        int balloonsLeft = game.balloonsNeeded - balloonsPopped;
        NSString *msg;
        if (balloonsLeft == 0) { // show different message when all balloons popped
            msg = @"";
        } else {
            NSMutableString *tmp = [NSMutableString stringWithFormat:@"%@! %d more to go!", [serviceManager wellDoneMessage], balloonsLeft];
            msg = tmp;
        }

        CCLabelTTF *label = [CCLabelTTF labelWithString:msg dimensions:CGSizeMake(305, 179)
                                              alignment:UITextAlignmentCenter
                                               fontName:@"Helvetica"
                                               fontSize:18.0f];
        [label setPosition:ccp(s.width / 2.0f, 90)];
        [label setColor:ccBLUE];
        [self addChild:label z:1001];

        id scoreAction = [CCSequence actions:
                [CCSpawn actions:
                        [CCScaleBy actionWithDuration:2.0 scale:2.0],
                        [CCEaseIn actionWithAction:[CCFadeOut actionWithDuration:2.4] rate:2],
                        nil],
                [CCCallBlock actionWithBlock:^{
                    [self removeChild:label cleanup:YES];
                }],
                nil];
        [label runAction:scoreAction];
        [[GameSounds sharedGameSounds] explosion];

    } else { // incorrectly answered

        [[GameSounds sharedGameSounds] incorrectAnswer];

        [self updateLivesArray];

        CGSize s = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@""
                                             dimensions:CGSizeMake(305, 179)
                                              alignment:UITextAlignmentCenter
                                               fontName:@"Helvetica"
                                               fontSize:18.0f];

        NSString *msg;
        if (game.lives == 0) {
            msg = @"GAME OVER!";
            [label setColor:ccRED];
        } else if (game.lives == 1) {
            msg = @"WRONG! 1 LIFE LEFT!";
            [label setColor:ccRED];
        } else {
            msg = @"WRONG! TRY AGAIN";
            [label setColor:ccBLUE];
        }
        [label setString:msg];
        [label setPosition:ccp(s.width / 2.0f, 90)];

        [self addChild:label z:1001];
        id scoreAction = [CCSequence actions:
                [CCSpawn actions:
                        [CCScaleBy actionWithDuration:2.0 scale:2.0],
                        [CCEaseIn actionWithAction:[CCFadeOut actionWithDuration:2.4] rate:2],
                        nil],
                [CCCallBlock actionWithBlock:^{
                    [self removeChild:label cleanup:YES];
                }],
                nil];
        [label runAction:scoreAction];
    }
    [self cleanUpSprite:balloon.label];
    [self cleanUpBalloon:balloon.sprite data:balloon];
}


/**
 Called on touch start.
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [self convertTouchToNodeSpace:touch];


    if (IS_IPAD) { //iPADs..
        radiusSQ = SLING_TOUCH_RADIUS_IPAD * SLING_TOUCH_RADIUS_IPAD;
    } else {
        radiusSQ = SLING_TOUCH_RADIUS * SLING_TOUCH_RADIUS;
    }

    //Get the vector of the touch
    CGPoint vector = ccpSub(SLING_POSITION, pt);

    //Are we close enough to the slingshot?
    if (ccpLengthSQ(vector) < radiusSQ) {
        //[self updateArrowWithTouch:touch];
        return YES;
    } else
        return NO;
}

/**
 Called on moving.
 */
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    // Update the rotation and power based on change in touch
    //[self updateArrowWithTouch:touch];
    CGPoint location = [touch locationInView:[touch view]];

    location = [[CCDirector sharedDirector] convertToGL:location];

    /////////////////////////////////
    // Move the ball in the slingshot. IF the screen is in the starting position (self.position.x == 0) and a throw isn't already in progress, AND our finger is touching around the sling shot

    if (([self checkCircleCollision:location :2 :slingShotCenterPosition :maxStretchOfSlingShot] == YES || slingShotBallInHand == YES) && throwInProgress == NO && areWeInTheStartingPosition == YES) {

        if (slingShotBallInHand == NO) {

            positionInSling = slingShotCenterPosition;
            //slingShotBallInHand = YES;

            strapBack.visible = YES;
            strapFront.visible = YES;
            strapEmpty.visible = NO;
        }

        float radius = maxStretchOfSlingShot; //radius of slingShot
        radius = radius - 360;

        GLfloat angle = [self calculateAngle:location.x :location.y :slingShotCenterPosition.x :slingShotCenterPosition.y];  //angle from slingShot center to the location of the touch


        // if the user is moving the ball within the max stretch of the slingShot  (the radius)
        if ([self checkCircleCollision:location :2 :slingShotCenterPosition :radius] == YES) {

            positionInSling = ccp(location.x, location.y);

            //tie the strap size into the location of the touch in relation to the distance from the slingshot center

            float scaleStrap = (abs(slingShotCenterPosition.x - location.x)) / radius;

            scaleStrap = scaleStrap + 0.3;  //add a little extra

            if (scaleStrap > 1) {  //make sure it doesn't go over 100% scale
                scaleStrap = 1;
            }

            strapFront.scaleX = scaleStrap;
            strapBack.scaleX = strapFront.scaleX;  //strap back is the same size as the strap front (until we rework it a tad below)



        } else {
            // if the user is moving the ninja outside the max stretch of the slingShot

            GLfloat angleRadians = CC_DEGREES_TO_RADIANS (angle - 90);
            positionInSling = ccp( slingShotCenterPosition.x - (cos(angleRadians) * radius), slingShotCenterPosition.y + (sin(angleRadians) * radius) );

            strapFront.scaleX = 1;
            strapBack.scaleX = 1;


        }

        strapFront.rotation = angle - 90;
        [self adjustBackStrap:(float) angle];
        [self updateArrowWithTouch:touch];

//        b2Vec2 locationInMeters = b2Vec2(positionInSling.x / PTM_RATIO, positionInSling.y / PTM_RATIO);
//        
//        // currentBodyNode.body->SetTransform( locationInMeters , CC_DEGREES_TO_RADIANS(angle - 90) );
//        currentBodyNode.body->SetTransform( locationInMeters , CC_DEGREES_TO_RADIANS( currentAngle  )  );
//        //Set the position
//        _curBomb.position = ccp(positionInSling.x / PTM_RATIO, positionInSling.y / PTM_RATIO);
//        _curBomb.rotation = CC_DEGREES_TO_RADIANS( angle  )  ;

    }
}

/**
 Called on touch end.
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [[GameSounds sharedGameSounds] releaseSlingSounds];
    CGPoint location = [self convertTouchToNodeSpace:touch];

    [self projectileBomb:location];
}

- (GLfloat)calculateAngle:(GLfloat)x1 :(GLfloat)y1 :(GLfloat)x2 :(GLfloat)y2 {
    // DX
    GLfloat x = x2 - x1;

    // DY
    GLfloat y = y2 - y1;


    GLfloat angle = 180 + (atan2(-x, -y) * (180 / M_PI));

    return angle;  //degrees
}

- (BOOL)checkCircleCollision:(CGPoint)center1  :(float)radius1  :(CGPoint)center2  :(float)radius2 {
    float a = center2.x - center1.x;
    float b = center2.y - center1.y;
    float c = radius1 + radius2;
    float distanceSqrd = (a * a) + (b * b);

    if (distanceSqrd < (c * c)) {

        return YES;
    } else {
        return NO;
    }

}


- (void)projectileBomb:(CGPoint)location {
    CGPoint vector = ccpSub(SLING_BOMB_POSITION, _curBomb.position);

    CGFloat shootAngle = ccpToAngle(vector);

    // This determines the speed variance
    b2Vec2 direction = b2Vec2(slingShotCenterPosition.x - location.x, slingShotCenterPosition.y - location.y);

    speed = (abs(slingShotCenterPosition.x - positionInSling.x)) + (abs(slingShotCenterPosition.y - positionInSling.y));

    speed = speed / 200;

    speed = speed * multipyThrowPower;


    strapBack.visible = NO;
    strapFront.visible = NO;
    strapEmpty.visible = YES;
    areWeInTheStartingPosition = YES;


    //   b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(_curBomb.position.x / PTM_RATIO, _curBomb.position.y / PTM_RATIO);
    ballBodyDef.userData = _curBomb;

    moving_rec = world->CreateBody(&ballBodyDef);
    b2CircleShape circle;
    float x1 = cos(shootAngle);
    float y1 = sin(shootAngle);
    // b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 0.8f;  //60,0f
    ballShapeDef.friction = 0.9f; // We don't want the ball to have friction! 0,0
    ballShapeDef.restitution = 0.2f; //1.0f
    //        ballShapeDef.density = 0.8f;
    //        ballShapeDef.restitution = 0.2f;
    //        ballShapeDef.friction = 0.99f;
    moving_rec->CreateFixture(&ballShapeDef);
    moving_rec->SetAngularDamping(3);
    //b2Vec2 force = b2Vec2(x1* power,y1* power);
    b2Vec2 force = b2Vec2(x1 * speed, y1 * speed);

    // moving_rec->ApplyLinearImpulse(force, ballBodyDef.position);
    // This moves the body, and the key part is multiplication
    // of 'speed' variable with direction. .
    moving_rec->SetLinearVelocity(speed * direction);


    [bombs addObject:_curBomb];


    [self setupNextBomb];

}

- (void)updateArrowWithTouch:(UITouch *)touch {


    CGPoint pt = [self convertTouchToNodeSpace:touch];

    //Get the vector, angle, length, and normal vector of the touch
    CGPoint vector = ccpSub(pt, SLING_BOMB_POSITION);
    CGPoint normalVector = ccpNormalize(vector);
    float angleRads = ccpToAngle(normalVector);
    int angleDegs = (int) CC_RADIANS_TO_DEGREES(angleRads) % 360;
    float length = ccpLength(vector);

    //Correct the Angle; we want a positive one
    while (angleDegs < 0)
        angleDegs += 360;

    if (IS_IPAD) {
        if (length > SLING_LAUNCH_RADIUS_IPAD)
            length = SLING_LAUNCH_RADIUS_IPAD;
    } else {
        if (length > SLING_LAUNCH_RADIUS)
            length = SLING_LAUNCH_RADIUS;
    }


    //Limit the angle
    if (angleDegs > SLING_MAX_ANGLE)
        normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(SLING_MAX_ANGLE));
    else if (angleDegs < SLING_MIN_ANGLE)
        normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(SLING_MIN_ANGLE));

    //Set the position
    _curBomb.position = ccpAdd(SLING_BOMB_POSITION, ccpMult(normalVector, length));
    _curBomb.rotation = angleDegs;

}

#pragma mark RESET OR ADVANCE LEVEL
- (void)showBoardMessage:(NSString *)theMessage {

    CCLabelTTF *boardMessage = [CCLabelTTF labelWithString:theMessage fontName:@"Marker Felt" fontSize:22];
    [self addChild:boardMessage z:depthPointScore];
    [boardMessage setColor:ccc3(255, 255, 255)];
    boardMessage.position = ccp( screenWidth / 2, screenHeight * .7 );


    CCSequence *seq = [CCSequence actions:

            [CCScaleTo actionWithDuration:2.0f scale:2.0f],
            [CCFadeTo actionWithDuration:1.0f opacity:0.0f],
            [CCCallFuncN actionWithTarget:self selector:@selector(removeBoardMessage:)], nil];  //NOTE: CCCallFuncN  works, CCCallFunc does not.

    [boardMessage runAction:seq];
}

- (void)removeBoardMessage:(id)sender {

    CCLabelTTF *boardMessage = (CCLabelTTF *) sender;

    [self removeChild:boardMessage cleanup:YES];

}


// todo: delete this
- (void)resetOrAdvanceLevel {

    if (pointTotalThisRound >= pointsToPassLevel) {

        //CCLOG(@"board passed");

        [self doPointBonusForTimeLeft];
        totalPoints = pointTotalThisRound;

        if (bonusThisRound > 0) { //if theres a bonus, show it in the level passed message

            NSString *bonusMessage = [NSString stringWithFormat:@"Level Passed: %i Bonus!", bonusThisRound];

            [self showBoardMessage:bonusMessage];


            [[GamePlayConfig instance] setHighScoreForLevel:pointTotalThisRound]; //will check to see if there's a high score set

            [[GamePlayConfig instance] addToPointTotalForAllLevels:pointTotalThisRound];
            bonusThisRound = 0;
            pointTotalThisRound = 0;

        } else {

            [self showBoardMessage:(NSString *) @"Level Passed"];
        }


        //[[GamePlayConfig instance] increaseLevel];  //level up

    } else {
        [[GamePlayConfig instance] setHighScoreForLevel:pointTotalThisRound]; //will check to see if there's a high score set even if you failed the round
    }




    //[self performSelector:@selector(transitionOut) withObject:nil afterDelay:3.0f]; //if you want to transition after a different amount of time, then change 3 to whatever
}


#pragma mark SIMPLE BREAK FX

- (void)showSimpleVisualFX:(CGPoint)positionToShowScore theSimpleScoreVisualFX:(int)theSimpleScoreVisualFX {

    if (theSimpleScoreVisualFX == breakEffectSmokePuffs) {

        [[GameSounds sharedGameSounds] playBreakSound];

        //CCLOG(@"Play Smoke Puffs on Score");

        CustomAnimation *smokeFX = [CustomAnimation createClassWithFile:@"puffs" theFrameToStartWith:1 theNumberOfFramesToAnimate:7
                                                                   theX:positionToShowScore.x theY:positionToShowScore.y
                                                                flipOnX:false flipOnY:false doesItLoop:false doesItUseRandomFrameToLoop:false];
        [self addChild:smokeFX z:depthVisualFx];

    } else if (theSimpleScoreVisualFX == breakEffectExplosion) {

        [[GameSounds sharedGameSounds] playBreakSound];

        //CCLOG(@"Play Smoke Puffs on Score");

        CustomAnimation *smokeFX = [CustomAnimation createClassWithFile:@"explosion" theFrameToStartWith:1 theNumberOfFramesToAnimate:11
                                                                   theX:positionToShowScore.x theY:positionToShowScore.y
                                                                flipOnX:false flipOnY:false doesItLoop:false doesItUseRandomFrameToLoop:false];
        [self addChild:smokeFX z:depthVisualFx];

    }

}

- (void)showPoints:(int)pointValue positionToShowScore:(CGPoint)positionToShowScore  theSimpleScoreVisualFX:(int)theSimpleScoreVisualFX {

    pointTotalThisRound = pointTotalThisRound + pointValue;
    [self updatePointsLabel];

    //CCLOG(@"Point Value %i, total points is now %i", pointValue, pointTotalThisRound);

    [self showSimpleVisualFX:positionToShowScore theSimpleScoreVisualFX:theSimpleScoreVisualFX];

    [self somethingJustScoredVar];

    if (useImagesForPointScoreLabels == YES) {

        [self showPointsWithImagesForValue:pointValue positionToShowScore:positionToShowScore];

    } else {

        [self showPointsWithFontLabelForValue:pointValue positionToShowScore:positionToShowScore];
    }


}

//todo: remove this
- (void)showPointsWithImagesForValue:(int)pointValue positionToShowScore:(CGPoint)positionToShowScore {


    CCSprite *scoreLabel;
    if (pointValue == 10) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"10points"];

    } else if (pointValue == 100) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"100points"];
    }
    else if (pointValue == 500) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"500points"];
    }
    else if (pointValue == 1000) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"1000points"];
    }
    else if (pointValue == 5000) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"5000points"];
    }
    else if (pointValue == 10000) {

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"10000points"];
    }
    else { //default

        scoreLabel = [CCSprite spriteWithSpriteFrameName:@"100points"];

    }


    [self addChild:scoreLabel z:depthPointScore];
    scoreLabel.position = positionToShowScore;


    //    CCMoveTo* moveAction = [CCMoveTo actionWithDuration:1.0f position:ccp ( scoreLabel.position.x  , scoreLabel.position.y + 25 )];
    //    
    //    [scoreLabel runAction:moveAction];

    CCSequence *seq = [CCSequence actions:
            [CCFadeTo actionWithDuration:1.5f opacity:20.0f],
            [CCCallFuncN actionWithTarget:self selector:@selector(removeThisChild:)], nil];

    [scoreLabel runAction:seq];

}

- (void)removeThisChild:(id)sender {


    CCSprite *theSprite = (CCSprite *) sender;

    [self removeChild:theSprite cleanup:YES];


}

- (void)showPointsWithFontLabelForValue:(int)pointValue positionToShowScore:(CGPoint)positionToShowScore {


    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", pointValue] fontName:@"Marker Felt" fontSize:22];
    [self addChild:scoreLabel z:depthPointScore];
    [scoreLabel setColor:ccc3(255, 255, 255)];
    scoreLabel.position = positionToShowScore;


    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:1.0f position:ccp ( scoreLabel.position.x, scoreLabel.position.y + 25 )];

    [scoreLabel runAction:moveAction];

    CCSequence *seq = [CCSequence actions:
            [CCFadeTo actionWithDuration:1.5f opacity:20.0f],
            [CCCallFuncN actionWithTarget:self selector:@selector(removeThisLabel:)], nil];  //NOTE: CCCallFuncN  works, CCCallFunc does not.

    [scoreLabel runAction:seq];


}

- (void)removeThisLabel:(id)sender {


    CCLabelTTF *theLabel = (CCLabelTTF *) sender;

    [self removeChild:theLabel cleanup:YES];


}


- (void)doPointBonusForTimeLeft {


    bonusThisRound = (bonusPerTimeLeft * (int) game.timer);
    pointTotalThisRound = pointTotalThisRound + bonusThisRound;

    [self updatePointsLabel];

    CCLOG(@"Time Left to complete level: %i", (int) game.timer );
}

#pragma mark POINTS

- (void)updatePointsLabel {
    NSString *updateLabel = [NSString stringWithFormat:@"Questions: %i/%i ", [game balloonsCollected],
                                                       [[GamePlayConfig instance] numberOfQuestions]];
    [currentQuestionNumber setString:updateLabel];

}

- (void)somethingJustScoredVar {


    somethingJustScored = YES;

    [self unschedule:@selector(resetSomethingJustScoredVar)];
    [self schedule:@selector(resetSomethingJustScoredVar:) interval:3.0f];

}

- (void)resetSomethingJustScoredVar:(ccTime)delta {

    somethingJustScored = NO;
    [self unschedule:_cmd];
}

#pragma mark Pause Button 

- (void)showPause {
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[PauseLayer scene]];
}

- (void)setupBackground {
    GameCategory gameCategory = [[GamePlayConfig instance] gameCategory];

    CCSprite *background = [[CCSprite node] initWithFile:deviceFile(@"addition-background", @"png")];


    //[yourSprite setTexture:[[CCSprite spriteWithFile:@"yourImage.png"]texture]];
    if (gameCategory == SUBTRACTION)
        background = [[CCSprite node] initWithFile:deviceFile(@"subtractionBackground", @"png")];
    else if (gameCategory == MULTIPLICATION)
        background = [[CCSprite node] initWithFile:deviceFile(@"multiplication-background", @"png")];
    else if (gameCategory == DIVISION)
        background = [[CCSprite node] initWithFile:deviceFile(@"division-background", @"png")];

    background.anchorPoint = ccp(0, 0);
    background.position = ccp(0, 0);

    [self addChild:background z:depthBackground];

    CCSprite *sling1 = [CCSprite spriteWithSpriteFrameName:@"platform"];
    CCSprite *sling2 = [CCSprite spriteWithSpriteFrameName:@"slingshot_front"];
    if (IS_IPAD) { //iPADs..
        sling1.position = SLING_POSITION;
        sling2.position = ccp(152, 131 ); // x horizontal,y vertical
    } else {
        sling1.position = SLING_POSITION;
        sling2.position = ccp(70, 62 );
    }
    //sling2.position = ccpAdd(SLING_POSITION, ccp(-8, 15));

    [self addChild:sling1 z:depthPlatform];
    [self addChild:sling2 z:depthSlingShotFront];
}

- (void)setupBombs {
    for (int i = 0; i < 3; i++) {
        bomb = [CCSprite spriteWithSpriteFrameName:@"ball"];
        if (IS_IPAD) { //iPADs..
            bomb.position = ccp(10 + i * 36, 23); //143  TODO verify for iPad
        } else {
            bomb.position = ccp(10 + i * 16, 23); //143  TODO verify for iPad
        }
        [self addChild:bomb z:5];
        [_bombs addObject:bomb];
    }
}

- (void)setupLives {
    for (int i = 0; i < [[GamePlayConfig instance] numberOfLives]; i++) {
        heart = [CCSprite spriteWithSpriteFrameName:@"life"];
        if (IS_IPAD) { //iPADs..
            heart.position = ccp(heart.boundingBox.size.width / 2 + heart.boundingBox.size.width / 10 + i * 40, windowSize_.height - heart.boundingBox.size.height / 2);
        } else {
            heart.position = ccp(heart.boundingBox.size.width / 2 + heart.boundingBox.size.width / 10 + i * 20, windowSize_.height - heart.boundingBox.size.height / 2);
        }

        [self addChild:heart z:5];
        [_hearts addObject:heart];
    }
}

- (void)updateLivesArray {
    if ([_hearts count]) {
        _curHeart = [_hearts lastObject];
        [self removeChild:_curHeart cleanup:YES];
        [_hearts removeLastObject];
        game.lives = [_hearts count];
    }
}

- (void)setupNextBomb {
    if ([_bombs count]) {
        _curBomb = [_bombs lastObject];

        //move it into position
        if (IS_IPAD) { //iPADs..
            [_curBomb runAction:[CCMoveTo actionWithDuration:.7 position:ccpAdd(ccp(170, 115), ccp(0, 27))]];
        } else {
            [_curBomb runAction:[CCMoveTo actionWithDuration:.7 position:ccpAdd(ccp(77, 45), ccp(0, 27))]];
        }

        [_bombs removeLastObject];

    }
    else {
        _curBomb = [CCSprite spriteWithSpriteFrameName:@"ball"];
        _curBomb.position = ccp(16, 23); //143
        [self addChild:_curBomb z:5];
        //move it into position
        if (IS_IPAD) { //iPADs..
            [_curBomb runAction:[CCMoveTo actionWithDuration:.7 position:ccpAdd(ccp(170, 115), ccp(0, 27))]];
        } else {
            [_curBomb runAction:[CCMoveTo actionWithDuration:.7 position:ccpAdd(ccp(77, 45), ccp(0, 27))]];
        }
        //[_bombs addObject:bomb];
    }
    //_curBomb = nil;
}

- (void)draw {
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states:  GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    world->DrawDebugData();

    // restore default GL states
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}





//strap


- (void)adjustBackStrap:(float)angle {


    //CCLOG(@" %f", angle );

    if (angle < 30) {

        //CCLOG(@" between 6 and 7 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.0; // 1.0
        strapBack.rotation = strapFront.rotation * .8;

    } else if (angle < 60) {

        //CCLOG(@" between 7 and 8 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.05;
        strapBack.rotation = strapFront.rotation * .80;

    } else if (angle < 90) {

        //CCLOG(@" between 8 and 9 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.1;
        strapBack.rotation = strapFront.rotation * .85;

    } else if (angle < 120) {

        //CCLOG(@" between 9 and 10 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.2;
        strapBack.rotation = strapFront.rotation * .95;

    } else if (angle < 150) {

        //CCLOG(@" between 10 and 11 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.2;
        strapBack.rotation = strapFront.rotation * .9;

    }

    else if (angle < 180) {
        //CCLOG(@" between 11 and 12 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.2; //1.10 
        strapBack.rotation = strapFront.rotation * .9; // .85

    }
    else if (angle < 210) {
        //CCLOG(@" between 12 and 1 oclock");

        strapBack.scaleX = strapBack.scaleX * 1.2; //.95
        strapBack.rotation = strapFront.rotation * .9;//.85

    }
    else if (angle < 240) {
        //CCLOG(@" between 1 and 2 oclock");

        strapBack.scaleX = strapBack.scaleX * 0.95;  //.7
        strapBack.rotation = strapFront.rotation * .85;//.85

    }

    else if (angle < 270) {
        //CCLOG(@" between 2 and 3 oclock");

        strapBack.scaleX = strapBack.scaleX * .75;  //6
        strapBack.rotation = strapFront.rotation * .9;

    }

    else if (angle < 300) {
        //CCLOG(@" between 3 and 4 oclock");

        strapBack.scaleX = strapBack.scaleX * .7;  //.5
        strapBack.rotation = strapFront.rotation * 1.0;

    }
    else if (angle < 330) {
        //CCLOG(@" between 4 and 5 oclock");

        strapBack.scaleX = strapBack.scaleX * .65; //.6
        strapBack.rotation = strapFront.rotation * 1.1;

    }

    else if (angle < 360) {
        //CCLOG(@" between 5 and 6 oclock");

        strapBack.scaleX = strapBack.scaleX * .65; //.6
        strapBack.rotation = strapFront.rotation * 1.1;
    }


}


// on "dealloc" you need to release all your retained objects
- (void)dealloc {

    delete world;
    world = NULL;
    [game release];
    [_bombs release];
    [balloons release];
    [_hearts release];
    [serviceManager release];
    [balloonImages release];

    // don't forget to call "super dealloc"
    [bombs release];
    bombs = nil;
    [question release];
    [clouds release];
    [super dealloc];
}
@end
