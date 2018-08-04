// Pause Layer

#import "cocos2d.h"
#import "CCLayer.h"

@interface PauseLayer : CCLayer {
    CGSize screenSize;

    CCMenu *MainMenu;

    NSString *menuBackgroundName;

    NSString *resumeName;

    NSString *mainMenuName;

    NSString *retryName;

    CCLabelTTF *pauseLabel;

}

+ (CCScene *)scene;

@end
