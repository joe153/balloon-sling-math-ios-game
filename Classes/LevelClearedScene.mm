
#import "PauseLayer.h"
#import "LevelMenu.h"
#import "MenuLayer.h"
#import "LevelClearedScene.h"

@implementation LevelClearedLayer
{
    CGSize screenSize;

    CCMenu *MainMenu;

    NSString *menuBackgroundName;

    NSString *resumeName;

    NSString *mainMenuName;

    NSString *retryName;

    NSString *nextLevelName;

}

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    LevelClearedLayer *layer = [LevelClearedLayer node];

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
        nextLevelName = @"nextlevel";

        CCSprite *theBackground = [CCSprite spriteWithFile:menuBackgroundName];
        theBackground.position = ccp (screenSize.width / 2, screenSize.height / 2);
        [self addChild:theBackground z:0];

        self.isTouchEnabled = YES;
        [self createMainMenu];

    }
    return self;
}

- (void)createMainMenu {

    [self removeChild:MainMenu cleanup:YES];
    CCMenuItemSprite *mainMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName] selectedSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName] target:self selector:@selector(showMainMenu)];

    CCMenuItemSprite *retry = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:retryName] selectedSprite:[CCSprite spriteWithSpriteFrameName:retryName] target:self selector:@selector(showRetry)];
    
    CCMenuItemSprite *nextLevel = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:nextLevelName] selectedSprite:[CCSprite spriteWithSpriteFrameName:nextLevelName] target:self selector:@selector(showRetry)];
    
    

    MainMenu = [CCMenu menuWithItems:mainMenu, retry, nextLevel, nil];
    MainMenu.position = ccp(screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20,
    screenSize.height - MainMenu.boundingBox.size.height / 4 - MainMenu.boundingBox.size.height / 4);
    [MainMenu alignItemsVertically];

    [self addChild:MainMenu z:10];

}

- (void)showRetry {
    [[CCDirector sharedDirector] replaceScene:[BalloonLayer scene]];
}

- (void)showMainMenu {
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[MenuLayer scene]];
}
@end
