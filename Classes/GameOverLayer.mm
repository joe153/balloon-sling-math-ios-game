#import "LevelMenu.h"
#import "Constants.h"
#import "GameOverLayer.h"

@implementation GameOverLayer

CGSize screenSize;

CCMenu *MainMenu;

NSString *menuBackgroundName;

NSString *mainMenuName;

NSString *retryName;


+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    GameOverLayer *layer = [GameOverLayer node];

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

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


}

- (void)createMainMenu {

    [self removeChild:MainMenu cleanup:YES];
    CCMenuItemSprite *mainMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName] selectedSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName] target:self selector:@selector(showMainMenu)];
    
    CCMenuItemSprite *retry = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:retryName] selectedSprite:[CCSprite spriteWithSpriteFrameName:retryName] target:self selector:@selector(showRetry)];

    MainMenu = [CCMenu menuWithItems:mainMenu, retry, nil];
    MainMenu.position = ccp(screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20,
    screenSize.height - MainMenu.boundingBox.size.height / 4 - MainMenu.boundingBox.size.height / 4);
    [MainMenu alignItemsVertically];


    float fontSize = 35.0f;
    if (IS_IPAD)
        fontSize = fontSize * 2;

    label = [CCLabelTTF labelWithString:@"GAME OVER!" dimensions:CGSizeMake(300, 350) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:fontSize];
    label.position = CGPointMake(screenSize.width / 2 - 80, 40);
    
    if (IS_IPAD) { //iPADs..

        label.position = CGPointMake(screenSize.width / 2 - 80, screenSize.height / 2);
    }else{

        label.position = CGPointMake(screenSize.width / 2 - 80, 40);
    }
    label.color = ccc3(227,220,16);

    [self addChild:label z:11];

    [self addChild:MainMenu z:10];
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
