#import "DialogLayer.h"
#import "Constants.h"
#import "GamePlayConfig.h"

#define DIALOG_FONT @"futura-48.fnt"

@implementation DialogLayer

-(id) initWithHeader3Buttons:(NSString *)header andLine1:(NSString *)line1 andLine2:(NSString *)line2 andLine3:(NSString *)line3 target:(id)callbackObj selector:(SEL)selector target2:(id)callbackObjMainMenu selector:(SEL)selector2 target3:(id)callbackTarget3Obj selector:(SEL)selector3
{
    if((self=[super init])) {
        
        //NSMethodSignature *sig = [[callbackObj class] instanceMethodSignatureForSelector:selector];
        NSMethodSignature *sig = [callbackObj methodSignatureForSelector:selector];
        callback = [NSInvocation invocationWithMethodSignature:sig];
        [callback setTarget:callbackObj];
        [callback setSelector:selector];
        [callback retain];
        
        NSMethodSignature *mainMenuSig = [callbackObj methodSignatureForSelector:selector2];
        callbackMainMenu = [NSInvocation invocationWithMethodSignature:mainMenuSig];
        [callbackMainMenu setTarget:callbackObjMainMenu];
        [callbackMainMenu setSelector:selector2];
        [callbackMainMenu retain];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //CCSprite *background = [CCSprite node];
        CCSprite *background =  [CCSprite spriteWithSpriteFrameName:@"dialogBox"];
        //[background initWithFile:@"dialogBox.png"];
        [background setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
        [self addChild:background z:-1];

        CCLabelBMFont *headerLabel = [CCLabelBMFont labelWithString:header fntFile:DIALOG_FONT];
        //headerLabel.color = ccBLACK;

        [self addChild:headerLabel];
        
        //////////////////
        
        CCLabelBMFont *line1Label = [CCLabelBMFont labelWithString:line1 fntFile:DIALOG_FONT];
        //line1Label.color = ccBLACK;

        [self addChild:line1Label];
        
        CCLabelBMFont *line2Label = [CCLabelBMFont labelWithString:line2 fntFile:DIALOG_FONT];
        //line2Label.color = ccBLACK;
        [self addChild:line2Label];
        
        CCLabelBMFont *line3Label = [CCLabelBMFont labelWithString:line3 fntFile:DIALOG_FONT];
        //line3Label.color = ccBLACK;

        [self addChild:line3Label];
        
        if (IS_IPAD) { //iPADs..
            [headerLabel setPosition:ccp(screenSize.width / 2, screenSize.height / 2 + 160 )];
            [line1Label setPosition:ccp(screenSize.width / 2, screenSize.height / 2 + 70)];
            [line2Label setPosition:ccp(screenSize.width / 2, screenSize.height / 2 + 10)];
            [line3Label setPosition:ccp(screenSize.width / 2, screenSize.height / 2  )];
            headerLabel.scale  = 1.50f;
            line1Label.scale = 1.20f;
            line2Label.scale = 1.20f;
            line3Label.scale = 1.20f;
        }else{

            if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
                [headerLabel setPosition:ccp(240, 235)];
                [line1Label setPosition:ccp(240, 200)];
                [line2Label setPosition:ccp(240, 160)];
                [line3Label setPosition:ccp(240, 120)];
                headerLabel.scale  = 0.74f;
                line1Label.scale = 0.54f;
                line2Label.scale = 0.54f;
                line3Label.scale = 0.54f;
            }else{
                if (screenSize.width <= 480){// iphone 3.5''
                    [headerLabel setPosition:ccp(240, 235)];
                    [line1Label setPosition:ccp(240, 200)];
                    [line2Label setPosition:ccp(240, 160)];
                    [line3Label setPosition:ccp(240, 120)];
                    headerLabel.scale  = 0.84f;
                    line1Label.scale = 0.64f;
                    line2Label.scale = 0.64f;
                    line3Label.scale = 0.64f;
                }else{// iphone 4.0''
                    [headerLabel setPosition:ccp(290, 235)];
                    [line1Label setPosition:ccp(290, 200)];
                    [line2Label setPosition:ccp(290, 160)];
                    [line3Label setPosition:ccp(290, 120)];
                    headerLabel.scale  = 1.20f;
                    line1Label.scale = 1.00f;
                    line2Label.scale = 1.00f;
                    line3Label.scale = 1.00f;
                }
            }

        }
        
        retryName = @"retry";
        
        mainMenuName = @"mainmenu";
        
        nextLevel  = @"nextLevel";
        
        CCMenuItemSprite *mainMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:mainMenuName]
                                                                     target:self selector:@selector(mainMenuPressed:)];
        CCMenuItemSprite *retryMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:retryName]
                                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:retryName]
                                                                      target:self selector:@selector(reloadPressed:)];
        CCMenuItemSprite *nextLevelMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:nextLevel]
                                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:nextLevel]
                                                                          target:self selector:@selector(nextLevelPressed:)];
        
        CCMenu *menu = [CCMenu menuWithItems:mainMenu, retryMenu, nextLevelMenu, nil];
        if (IS_IPAD) { //iPADs..
            menu.position = ccp(240,0);
            [retryMenu setPosition:ccp(screenSize.width / 3 - 60, screenSize.height / 2 - 100)];
            [mainMenu setPosition:ccp(screenSize.width / 6 - 60 , screenSize.height / 2 - 100)];
            [nextLevelMenu setPosition:ccp(screenSize.width / 2 - 50, screenSize.height/ 2 - 100)];
        }else{
            menu.position = ccp(240,0);
            if (![[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
                [retryMenu setPosition:ccp(0, 100)];
                [nextLevelMenu setPosition:ccp(screenSize.width / 5, 100)];
                [mainMenu setPosition:ccp(screenSize.width / 2 - 340, 100)];
            }else{
                if (screenSize.width <= 480){// iphone 3.5''
                    [retryMenu setPosition:ccp(0, 100)];
                    [nextLevelMenu setPosition:ccp(screenSize.width / 5, 100)];
                    [mainMenu setPosition:ccp(screenSize.width / 2 - 340, 100)];
                }else{//iphone 4.0''
                    [retryMenu setPosition:ccp(50, 100)];
                    [nextLevelMenu setPosition:ccp(screenSize.width / 5 +30, 100)];
                    [mainMenu setPosition:ccp(screenSize.width / 2 - 340, 100)];
                }
            }

        }

        [self addChild:menu];
    }
    return self;
}

-(void) mainMenuPressed:(id) sender
{
    [callbackMainMenu invoke];
    [[CCDirector sharedDirector] resume];
    [self removeFromParentAndCleanup:YES];

}
-(void) reloadPressed:(id) sender
{
    // this is retry after the game completes so we need to subtract one level from the requested level
    [[GamePlayConfig instance] requestedLevel:[[GamePlayConfig instance] requestedLevel] - 1];

    [callback invoke];
    [[CCDirector sharedDirector] resume];
    [self removeFromParentAndCleanup:YES];
    
}
-(void) nextLevelPressed:(id) sender
{
    [callback invoke];
    //[[CCDirector sharedDirector] replaceScene:[BalloonLayer scene]];
    [[CCDirector sharedDirector] resume];
    [self removeFromParentAndCleanup:YES];
    
}

-(void) dealloc
{
    [callback release];
    [super dealloc];
}
@end