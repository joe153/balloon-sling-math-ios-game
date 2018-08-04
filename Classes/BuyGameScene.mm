#import "PauseLayer.h"
#import "BuyGameScene.h"
#import "InAppPurchaseManager.h"
#import "LevelMenu.h"
#import "Constants.h"

@implementation BuyGameLayer {

    CGSize screenSize;

    CCMenu *MainMenu;

    NSString *mainMenuName;

    NSString *buyName;

    UIActivityIndicatorView   *spinner;
}

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    BuyGameLayer *layer = [BuyGameLayer node];

    // add layer as a child to scene
    [scene addChild:layer];

    // return the scene
    return scene;
}

- (id)init {

    if ((self = [super init])) {

        screenSize = [[CCDirector sharedDirector] winSize];

        menuBackgroundName = @"buyBackground";
        buyName = @"buy";
        mainMenuName = @"mainmenu";

        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                UIActivityIndicatorViewStyleWhiteLarge];
        CGRect frame = spinner.frame;
        frame.origin.x = screenSize.width / 2;
        frame.origin.y = screenSize.height / 2;
        spinner.frame = frame;

        [[[CCDirector sharedDirector] openGLView] addSubview:spinner];


        self.isTouchEnabled = YES;
        [self createMainMenu];

    }
    return self;
}
//Click the buy button to play all levels and categories.  We have 10 different levels each for additions, subtractions, multiplications and divisions.  More are coming!  Imagine your child mastering all the math while enjoy playing the game!

- (void)createMainMenu {

    [self removeChild:MainMenu cleanup:YES];

    CCSprite *theBackground = [[CCSprite node] initWithFile:deviceFile(menuBackgroundName, @"png")];
    theBackground.position = ccp (screenSize.width / 2, screenSize.height / 2);
    [self addChild:theBackground z:0];
    CCMenuItemSprite *levelButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                                    target:self selector:@selector(showLevelMenu)];

    CCMenuItemSprite *buyButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"buy.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"buy.png"]
                                                                    target:self selector:@selector(doBuy)];

    NSString *msg = @"Click the buy button to play all levels of addition, subtraction, multiplication and division.  "
            "\nWe have over 30 different levels! Imagine your child mastering all math skills while having fun!";
    if (IS_IPAD) { //iPADs..
        buyLabel = [CCLabelTTF labelWithString:msg dimensions:CGSizeMake(600, 500) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:35];
        buyLabel.position = CGPointMake(screenSize.width / 2 - 80, 170);
    } else {
        buyLabel = [CCLabelTTF labelWithString:msg dimensions:CGSizeMake(300, 350) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:20];
        buyLabel.position = CGPointMake(screenSize.width / 2 - 80, 40);
    }

    buyLabel.color = ccc3(72, 61, 139);

    [self addChild:buyLabel z:11];

    MainMenu = [CCMenu menuWithItems:buyButton, levelButton, nil];
    MainMenu.position = ccp(screenSize.width - MainMenu.boundingBox.size.width / 7 - MainMenu.boundingBox.size.width / 20,
    screenSize.height - MainMenu.boundingBox.size.height / 4 - MainMenu.boundingBox.size.height / 4);
    [MainMenu alignItemsVertically];

    [self addChild:MainMenu z:10];

}

- (void)successfullyPurchased:(NSNotification *)notification {
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    [spinner stopAnimating];
    NSLog(@"Purchase successful!");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Complete"
                                                    message:@"Thank you for your purchase.  You can now play all levels."
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

    [self takeToNextLevel];
}

- (void)purchaseFailed:(NSNotification *)notification {
    NSLog(@"Purchase failed!");
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    [spinner stopAnimating];
}

- (void)doBuy {
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
    [spinner startAnimating];

    [self showBuy];
}

- (void)takeToNextLevel {
    [[GamePlayConfig instance] increaseLevel];
    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}

- (void)showBuy {
    [[GameSounds sharedGameSounds] stopBackgroundMusic];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successfullyPurchased:)
                                                 name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(purchaseFailed:)
                                                 name:kInAppPurchaseManagerTransactionFailedNotification object:nil];

    if ([[InAppPurchaseManager sharedHelper] canMakePurchases]) {
        [[InAppPurchaseManager sharedHelper] loadStore];
        [[InAppPurchaseManager sharedHelper] purchase];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Disabled"
                                                        message:@"You must enable purchases first."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}

- (void)showLevelMenu {
    [[GameSounds sharedGameSounds] stopBackgroundMusic];
    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [spinner release];
}
@end
