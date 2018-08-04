#import "HelpLayer.h"
#import "Constants.h"

#define DIALOG_FONT @"futura-48.fnt"

@implementation HelpLayer


- (id)initWithHeader2Buttons:(NSString *)header target:(id)callbackObj selector:(SEL)selector target2:(id)callbackObjMainMenu {
    if ((self = [super init])) {

        //NSMethodSignature *sig = [[callbackObj class] instanceMethodSignatureForSelector:selector];
        NSMethodSignature *sig = [callbackObj methodSignatureForSelector:selector];
        callback = [NSInvocation invocationWithMethodSignature:sig];
        [callback setTarget:callbackObj];
        [callback setSelector:selector];
        [callback retain];

        CGSize screenSize = [CCDirector sharedDirector].winSize;

        CCSprite *background = [CCSprite node];
        [background initWithFile:deviceFile(@"help-iphone", @"png")];
        [background setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
        [self addChild:background z:-1];


        CCLabelBMFont *headerShadow = [CCLabelBMFont labelWithString:header fntFile:DIALOG_FONT];
        headerShadow.opacity = 127;
        [headerShadow setPosition:ccp(243, 262)];
        [self addChild:headerShadow];

        CCLabelBMFont *headerLabel = [CCLabelBMFont labelWithString:header fntFile:DIALOG_FONT];
        [headerLabel setPosition:ccp(240, 265)];
        [self addChild:headerLabel];

        buttonName = @"resume";

        CCMenuItemSprite *buttonMenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:buttonName]
                                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:buttonName]
                                                                       target:self selector:@selector(buttonPressed:)];

        CCMenu *menu = [CCMenu menuWithItems:buttonMenu, nil];
        if (IS_IPAD) {
            menu.position = ccp(240, 0);
            [buttonMenu setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
        } else {
            menu.position = ccp(240, 0);
            [buttonMenu setPosition:ccp(screenSize.width / 2 - 50, 50)];
        }

        [self addChild:menu];

    }
    return self;
}

- (void)buttonPressed:(id)sender {
    [callback invoke];
    [self removeFromParentAndCleanup:YES];
}


- (void)dealloc {
    [callback release];
    [super dealloc];
}


@end