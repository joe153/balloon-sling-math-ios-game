#import "CategoryMenu.h"
#import "Constants.h"
#import "MenuLayer.h"
#import "LevelMenu.h"

@implementation CategoryMenu {

}

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    CategoryMenu *layer = [CategoryMenu node];

    // add layer as a child to scene
    [scene addChild:layer];

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
- (id)init {

    if ((self = [super init])) {

        [self setBackground];
        [self createCategories];
        [self createBackButton];

    }
    return self;
}

- (void)setBackground {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    //CCSprite *theBackground = [CCSprite spriteWithSpriteFrameName:@"menu_options"];
    CCSprite *theBackground = [[CCSprite node] initWithFile:deviceFile(@"menu_options", @"png")];
    theBackground.position = ccp (screenSize.width / 2, screenSize.height / 2);
    [self addChild:theBackground z:0];

}

- (void)createCategories {

    //[CCSprite spriteWithFile:@"category1.png"]
    CCMenuItemSprite *plusIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                                 target:self selector:@selector(selectCategory:)];
    plusIcon.tag = 1;
    [plusIcon addChild:[self createHeaderLabel:plusIcon.tag]];
    [plusIcon addChild:[self createIcon:plusIcon.tag]];
    [plusIcon addChild:[self createFooterLabel:plusIcon.tag]];
    CCMenuItemSprite *minusIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                          selectedSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                                  target:self selector:@selector(selectCategory:)];
    minusIcon.tag = 2;
    [minusIcon addChild:[self createHeaderLabel:minusIcon.tag]];
    [minusIcon addChild:[self createIcon:minusIcon.tag]];
    [minusIcon addChild:[self createFooterLabel:minusIcon.tag]];
    CCMenuItemSprite *multiplyIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                                     target:self selector:@selector(selectCategory:)];
    multiplyIcon.tag = 3;
    [multiplyIcon addChild:[self createHeaderLabel:multiplyIcon.tag]];
    [multiplyIcon addChild:[self createIcon:multiplyIcon.tag]];
    [multiplyIcon addChild:[self createFooterLabel:multiplyIcon.tag]];
    CCMenuItemSprite *divideIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                           selectedSprite:[CCSprite spriteWithSpriteFrameName:@"category-button"]
                                                                   target:self selector:@selector(selectCategory:)];
    divideIcon.tag = 4;
    [divideIcon addChild:[self createHeaderLabel:divideIcon.tag]];
    [divideIcon addChild:[self createIcon:divideIcon.tag]];
    [divideIcon addChild:[self createFooterLabel:divideIcon.tag]];


    CCMenu *Menu = [CCMenu menuWithItems:plusIcon, minusIcon, multiplyIcon, divideIcon, nil];
    [Menu alignItemsHorizontallyWithPadding:10];
    [self addChild:Menu];

}


- (CCSprite *)createIcon : (int) tag {
    CCSprite *icon;
    if (tag == 1)
      icon =[CCSprite spriteWithSpriteFrameName:@"additionIcon"];
    else if (tag == 2)
      icon =[CCSprite spriteWithSpriteFrameName:@"subtractionIcon"];
    else if (tag ==3 )
      icon =[CCSprite spriteWithSpriteFrameName:@"multiplicationIcon"];
    else
      icon =[CCSprite spriteWithSpriteFrameName:@"divisionIcon"];  

    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    if (IS_IPAD) { //iPADs..
        icon.position = ccp(screenSize.width / 2 - 420, screenSize.height/2 - 150  );
    } else {
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            icon.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 - 50 );
        }else{
            if (screenSize.width <= 480){
                icon.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 - 50 );
            }else{
                icon.position = ccp(screenSize.width / 2 - 230, screenSize.height/2 - 50 );
            }
            
        }
    }
    
    return icon;
}

- (CCLabelBMFont *)createHeaderLabel: (int) tag {
    CCLabelBMFont *headerLabel;
    
    if (tag == 1) {
        headerLabel = [CCLabelBMFont labelWithString:@"Addition" fntFile:DIALOG_FONT];

    } else if (tag == 2) {
        headerLabel = [CCLabelBMFont labelWithString:@"Subtraction" fntFile:DIALOG_FONT];
    } else if (tag == 3) {
        headerLabel = [CCLabelBMFont labelWithString:@"Multiplication" fntFile:DIALOG_FONT];
    } else {
        headerLabel = [CCLabelBMFont labelWithString:@"Division" fntFile:DIALOG_FONT];
    }
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    if (IS_IPAD) { //iPADs..
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        
            if (headerLabel.string == @"Multiplication"){
                headerLabel.position = ccp(screenSize.width / 2 - 410, screenSize.height/2 + 10 );
                headerLabel.scale  = 0.6f;
            }else{
                headerLabel.position = ccp(screenSize.width / 2 - 420, screenSize.height/2 + 10 );
                headerLabel.scale  = 0.7f;
            }
        }else{
            if (headerLabel.string == @"Multiplication"){
                headerLabel.position = ccp(screenSize.width / 2 - 410, screenSize.height/2 + 10 );
                headerLabel.scale  = 1.4f;
            }else{
                headerLabel.position = ccp(screenSize.width / 2 - 420, screenSize.height/2 + 10 );
                headerLabel.scale  = 1.5f;
            }
        }
        
    } else {
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {

            if (headerLabel.string == @"Multiplication"){
                headerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 + 30 );
                headerLabel.scale  = 0.3f;
            }else{
                headerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 + 30 );
                headerLabel.scale  = 0.4f;
            }
            CCLOG(@"must be iphone 3 ");
        } else {
            CCLOG(@"retina display is on-must be iphone 4 or 5");
            if (screenSize.width <= 480){
                CCLOG(@"retina display 3.5 inches");
                if (headerLabel.string == @"Multiplication"){
                    headerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 + 30 );
                    headerLabel.scale  = 0.6f;
                }else{
                    headerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 + 30 );
                    headerLabel.scale  = 0.7f;
                }
            }else{
                CCLOG(@"retina display 4 inches");
                if (headerLabel.string == @"Multiplication"){
                    headerLabel.position = ccp(screenSize.width / 2 - 230, screenSize.height/2 + 30 );
                    headerLabel.scale  = 0.6f;
                }else{
                    headerLabel.position = ccp(screenSize.width / 2 - 230, screenSize.height/2 + 30 );
                    headerLabel.scale  = 0.7f;
                }
            }

        }
    }
    
    return headerLabel;
}

- (CCLabelBMFont *)createFooterLabel: (int) tag {
    CCLabelBMFont *footerLabel;
    
    if (tag == 1) {
        footerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/30", [[NSUserDefaults standardUserDefaults] integerForKey:@"levelsCompletedAddition" ]] fntFile:DIALOG_FONT];
        
    } else if (tag == 2) {
        footerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/30", [[NSUserDefaults standardUserDefaults] integerForKey:@"levelsCompletedSubtraction" ]]  fntFile:DIALOG_FONT];
    } else if (tag == 3) {
        footerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/30", [[NSUserDefaults standardUserDefaults] integerForKey:@"levelsCompletedMultiplication" ]]  fntFile:DIALOG_FONT];
    } else {
        footerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/30", [[NSUserDefaults standardUserDefaults] integerForKey:@"levelsCompletedDivision" ]]  fntFile:DIALOG_FONT];
    }
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    if (IS_IPAD) { //iPADs..
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            footerLabel.position = ccp(screenSize.width / 2 - 420, screenSize.height/2 - 320 );
            footerLabel.scale  = 1.0f;
        }else{
            footerLabel.position = ccp(screenSize.width / 2 - 420, screenSize.height/2 - 320 );
            footerLabel.scale  = 1.5f;
        }
    } else {
        if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            
            footerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 - 140 );
            footerLabel.scale  = 0.5f;
        }else{
            if (screenSize.width <= 480){
                footerLabel.position = ccp(screenSize.width / 2 - 190, screenSize.height/2 - 140 );
            }else{
                 footerLabel.position = ccp(screenSize.width / 2 - 230, screenSize.height/2 - 140 );               
            }
        }
    }
    
    return footerLabel;
}

- (void)selectCategory:(CCMenuItem *)menuItem {

    switch ([menuItem tag]) {
        case 1:
            [[GamePlayConfig instance] setGameCategory:ADDITION];
            break;
        case 2:
            [[GamePlayConfig instance] setGameCategory:SUBTRACTION];
            break;
        case 3:
            [[GamePlayConfig instance] setGameCategory:MULTIPLICATION];
            break;
        case 4:
            [[GamePlayConfig instance] setGameCategory:DIVISION];
            break;
        default:
            [[GamePlayConfig instance] setGameCategory:ADDITION];
            break;
    }

    NSLog(@"tag: %d %d", [menuItem tag], [[GamePlayConfig instance] gameCategory]);

    [[CCDirector sharedDirector] pushScene:[LevelMenu scene]];
}

- (void)createBackButton {
    CCMenu *backMenu;
    CCMenuItemSprite *backBtn = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"back"]
                                                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"back"]
                                                                target:self selector:@selector(backToMainMenu)];

    backMenu = [CCMenu menuWithItems:backBtn, nil];
    if (IS_IPAD) { //iPADs..
        backMenu.position = ccp(90, 120);
    } else {
        backMenu.position = ccp(30, 30);
    }
    [self addChild:backMenu z:10];
}

- (void)backToMainMenu {
    [[CCDirector sharedDirector] pushScene:[MenuLayer scene]];
}

@end