#import "LevelMenu.h"
#import "Constants.h"
#import "CategoryMenu.h"

@implementation LevelMenu {
    GameCategory category;

    CCMenu *backMenu;

    NSString *mathPlusIcon;
    NSString *mathSubtractionIcon;
    NSString *mathMultiplicationIcon;
    NSString *mathDivisionIcon;

    //Scroll menu
    CCLayer *firstPage;
    CCLayer *secondPage;
    CCLayer *thirdPage;
    CGPoint menu1Position;
    CGPoint menu2Position;
    CCScrollLayer *scroller;
}


+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    LevelMenu *layer = [LevelMenu node];

    [scene addChild:layer];

    return scene;
}

- (id)init {

    if ((self = [super init])) {

        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        // category the user selected
        category = [[GamePlayConfig instance] gameCategory];

        mathPlusIcon = @"Math-plus-icon";
        mathSubtractionIcon = @"Math-minus-icon";
        mathMultiplicationIcon = @"Math-X-icon";
        mathDivisionIcon = @"Math-divide-icon";

        if (IS_IPAD) { //iPADs..

            menu1Position = ccp(screenSize.width / 2, 430 );
            menu2Position = ccp(screenSize.width / 2, 270 );

            if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
                CCLOG(@"must be iPad 1 or 2");
            } else {
                CCLOG(@"retina display is on-must be iPAd 3");
            }
        } else {  //IPHONES..
            menu1Position = ccp(screenSize.width / 2, 185 );
            menu2Position = ccp(screenSize.width / 2, 105 );
        }

        //CCSprite *theBackground = [CCSprite spriteWithSpriteFrameName:@"menu_options"];
        CCSprite *theBackground = [[CCSprite node] initWithFile:deviceFile(@"menu_options", @"png")];
        theBackground.position = ccp (screenSize.width / 2, screenSize.height / 2);
        [self addChild:theBackground z:0];

        self.isTouchEnabled = YES;

        firstPage = [CCLayer node];
        secondPage = [CCLayer node];
        thirdPage = [CCLayer node];

        [firstPage addChild:[self createIcon]];
        [firstPage addChild:[self createLabel: 1]];
        [secondPage addChild:[self createIcon]];
        [secondPage addChild:[self createLabel: 2]];
        [thirdPage addChild:[self createIcon]];
        [thirdPage addChild:[self createLabel: 3]];

        [self createPage];

        scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects:firstPage, secondPage, thirdPage, nil] widthOffset:0];

        [scroller selectPage:[self whichPage]];
        [self addChild:scroller];

        [self createBackButton];
    }
    return self;

}

- (int) whichPage {
    int level = [[GamePlayConfig instance] requestedLevel];
    if (level <= 10)
        return 0;
    else if (level >= 11 && level <= 20)
        return 1;
    else
        return 2;
}

- (CCMenuItemFont *)createLabel: (int) page {
    CCMenuItemFont *iconLabel;
    if (category == ADDITION) {
        iconLabel = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Addition %d/3", page]];
    } else if (category == SUBTRACTION) {
        iconLabel = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Subtraction %d/3", page]];
    } else if (category == MULTIPLICATION) {
        iconLabel = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Multiplication %d/3", page]];
        iconLabel.tag = 3;
    } else {
        iconLabel = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Division %d/3", page]];
    }

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    if (IS_IPAD) { //iPADs..
        iconLabel.position = ccp(screenSize.width / 2 + 30, 545 );
    } else {
        if (iconLabel.tag == 3){
            iconLabel.position = ccp(screenSize.width / 2 + 20, 245 );
        }else{
            iconLabel.position = ccp(screenSize.width / 2 + 5, 245 );
        }
    }

    iconLabel.color = ccWHITE;
    return iconLabel;
}

- (CCSprite *)createIcon {
    CCSprite *icon;
    if (category == ADDITION) {
        icon = [CCSprite spriteWithSpriteFrameName:mathPlusIcon];
    } else if (category == SUBTRACTION) {
        icon = [CCSprite spriteWithSpriteFrameName:mathSubtractionIcon];
    } else if (category == MULTIPLICATION) {
        icon = [CCSprite spriteWithSpriteFrameName:mathMultiplicationIcon];
    } else {
        icon = [CCSprite spriteWithSpriteFrameName:mathDivisionIcon];
    }

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    if (IS_IPAD) { //iPADs..
        icon.position = ccp(screenSize.width / 2 - 130, 545 );
    } else {
        icon.position = ccp(screenSize.width / 2 - 110, 245 );
    }

    return icon;
}

- (CCMenuItemSprite *)createButton:(int)level {
    CCMenuItemSprite *button = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:[self buttonName:level]]
                                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:[self buttonName:level]]
                                                               target:self selector:@selector(goToFirstLevelSection:)];
    button.tag = level;
    return button;
}

- (void)createPage {
    CCMenuItemSprite *button1 = [self createButton:1];
    CCMenuItemSprite *button2 = [self createButton:2];
    CCMenuItemSprite *button3 = [self createButton:3];
    CCMenuItemSprite *button4 = [self createButton:4];
    CCMenuItemSprite *button5 = [self createButton:5];
    CCMenuItemSprite *button6 = [self createButton:6];
    CCMenuItemSprite *button7 = [self createButton:7];
    CCMenuItemSprite *button8 = [self createButton:8];
    CCMenuItemSprite *button9 = [self createButton:9];
    CCMenuItemSprite *button10 = [self createButton:10];

    CCMenuItemSprite *button11 = [self createButton:11];
    CCMenuItemSprite *button12 = [self createButton:12];
    CCMenuItemSprite *button13 = [self createButton:13];
    CCMenuItemSprite *button14 = [self createButton:14];
    CCMenuItemSprite *button15 = [self createButton:15];
    CCMenuItemSprite *button16 = [self createButton:16];
    CCMenuItemSprite *button17 = [self createButton:17];
    CCMenuItemSprite *button18 = [self createButton:18];
    CCMenuItemSprite *button19 = [self createButton:19];
    CCMenuItemSprite *button20 = [self createButton:20];

    CCMenuItemSprite *button21 = [self createButton:21];
    CCMenuItemSprite *button22 = [self createButton:22];
    CCMenuItemSprite *button23 = [self createButton:23];
    CCMenuItemSprite *button24 = [self createButton:24];
    CCMenuItemSprite *button25 = [self createButton:25];
    CCMenuItemSprite *button26 = [self createButton:26];
    CCMenuItemSprite *button27 = [self createButton:27];
    CCMenuItemSprite *button28 = [self createButton:28];
    CCMenuItemSprite *button29 = [self createButton:29];
    CCMenuItemSprite *button30 = [self createButton:30];

    CCMenu *menu1 = [CCMenu menuWithItems:button1, button2, button3, button4, button5, nil];
    menu1.position = menu1Position;
    [menu1 alignItemsHorizontallyWithPadding:10];
    [firstPage addChild:menu1];

    CCMenu *menu2 = [CCMenu menuWithItems:button6, button7, button8, button9, button10, nil];
    menu2.position = menu2Position;
    [menu2 alignItemsHorizontallyWithPadding:10];
    [firstPage addChild:menu2];

    CCMenu *menu3 = [CCMenu menuWithItems:button11, button12, button13, button14, button15, nil];
    menu3.position = menu1Position;
    [menu3 alignItemsHorizontallyWithPadding:10];
    [secondPage addChild:menu3];

    CCMenu *menu4 = [CCMenu menuWithItems:button16, button17, button18, button19, button20, nil];
    menu4.position = menu2Position;
    [menu4 alignItemsHorizontallyWithPadding:10];
    [secondPage addChild:menu4];

    CCMenu *menu5 = [CCMenu menuWithItems:button21, button22, button23, button24, button25, nil];
    menu5.position = menu1Position;
    [menu5 alignItemsHorizontallyWithPadding:10];
    [thirdPage addChild:menu5];

    CCMenu *menu6 = [CCMenu menuWithItems:button26, button27, button28, button29, button30, nil];
    menu6.position = menu2Position;
    [menu6 alignItemsHorizontallyWithPadding:10];
    [thirdPage addChild:menu6];
}

// returns the locked image name if the level not allowed
- (NSString *)buttonName:(int)level {
    NSMutableString *aString = [NSMutableString stringWithFormat:@"levelButton_locked"];

    if ([[GamePlayConfig instance] canYouGoToTheFirstLevelOfThisSection:(level) :category] == YES || ALL_LEVELS_UNLOCKED) {
        aString = [NSMutableString stringWithFormat:@"levelButton"];
        [aString appendFormat:@"%d", level];
        return aString;
    } else {
        return aString;
    }
}

// go to the game
- (void)goToFirstLevelSection:(CCMenuItem *)menuItem {
    if ([[GamePlayConfig instance] canYouGoToTheFirstLevelOfThisSection:([menuItem tag]) :category] == YES || ALL_LEVELS_UNLOCKED) {
        [[GamePlayConfig instance] changeLevelToFirstInThisSection:[menuItem tag]];
        [self performSelector:@selector(popAndTransition)];
    } else {
        // do nothing as this level is locked
    }
}

- (void)createBackButton {
    [self removeChild:backMenu cleanup:YES];
    CCMenuItemSprite *backBtn = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"back"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"back"] target:self selector:@selector(backToMainMenu)];

    backMenu = [CCMenu menuWithItems:backBtn, nil];
    if (IS_IPAD) { //iPADs..
        backMenu.position = ccp(90, 120);
    } else {
        backMenu.position = ccp(30, 30);
    }
    [self addChild:backMenu z:10];
}


- (void)backToMainMenu {
    [[CCDirector sharedDirector] pushScene:[CategoryMenu scene]];
}

#pragma mark POP (remove) SCENE and Transition to new level

- (void)popAndTransition {

    [[CCDirector sharedDirector] popScene];

    //when TheLevel scene reloads it will start with a new level
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:1 scene:[BalloonLayer scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}


#pragma mark  POP (remove) SCENE and continue playing current level

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // [[CCDirector sharedDirector] popScene];
}

- (void)dealloc {
    [scroller release];
    [super dealloc];

}

@end
