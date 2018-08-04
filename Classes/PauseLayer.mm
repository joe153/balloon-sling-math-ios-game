
#import "PauseLayer.h"
#import "LevelMenu.h"
#import "Constants.h"

@implementation PauseLayer

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    PauseLayer *layer = [PauseLayer node];

    // add layer as a child to scene
    [scene addChild:layer];

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
- (id)init {

    if ((self = [super init])) {

        screenSize = [[CCDirector sharedDirector] winSize];

        menuBackgroundName = @"menu_options";

        resumeName = @"resume";

        retryName = @"retry";

        mainMenuName = @"mainmenu";

        CCSprite *theBackground = [[CCSprite node] initWithFile:deviceFile(menuBackgroundName, @"png")];
        
        theBackground.position = ccp (screenSize.width / 2, screenSize.height / 2);
        [self addChild:theBackground z:0];

        self.isTouchEnabled = YES;

        [self createMainMenu];

    }
    return self;
}

- (void)createMainMenu {

    [self removeChild:MainMenu cleanup:YES];
    
    CCMenuItemSprite *mainMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                                 target:self selector:@selector(showMainMenu)];
    
    CCMenuItemSprite *resume = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:resumeName]
                                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:resumeName]
                                                               target:self selector:@selector(doResume)];

    CCMenuItemSprite *retry = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:retryName]
                                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:retryName]
                                                              target:self selector:@selector(showRetry)];



    float fontSize = 35.0f;
    if (IS_IPAD)
        fontSize = fontSize * 2;

    pauseLabel = [CCLabelTTF labelWithString:@"PAUSED " dimensions:CGSizeMake(300, 350) alignment:UITextAlignmentCenter
                                    fontName:@"Marker Felt" fontSize:fontSize];
    if (IS_IPAD) { //iPADs..
        pauseLabel.position = CGPointMake(screenSize.width / 2 - 80, screenSize.height / 2);
    }else{
        pauseLabel.position = CGPointMake(screenSize.width / 2 - 80, 40);        
    }

    //buyLabel.position = ccp(screenSize.width / 2, screenSize.height / 2 );

    pauseLabel.color = ccc3(227,220,16);

    [self addChild:pauseLabel z:11];

    MainMenu = [CCMenu menuWithItems:mainMenu, resume, retry, nil];
    MainMenu.position = ccp(screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20,
    screenSize.height - MainMenu.boundingBox.size.height / 4 - MainMenu.boundingBox.size.height / 4);
    [MainMenu alignItemsVertically];

    [self addChild:MainMenu z:10];
}

- (void)doResume {
    [[GameSounds sharedGameSounds] playBackgroundMusic];
    [[CCDirector sharedDirector] popScene];
}

- (void)showRetry {
    [[CCDirector sharedDirector] replaceScene:[BalloonLayer scene]];
}

- (void)showMainMenu {
    // Run the intro Scene
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}
@end
