#import "cocos2d.h"
#import "FBConnect.h"

@interface MenuLayer : CCLayer <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
    CGSize screenSize; 
    CCMenu*MainMenu;
    CCMenu* AppStoreMenu;
    NSString* playImageName;
    NSString* optionsImageName;
    NSString* shareImageName;
    NSString* appStoreImageName;
    NSString* buyImageName;
    Facebook *facebook;
    BOOL isFBLogged;
    CCMenu *facebookLogoutButton;
    CCMenuItemSprite *share;
    
    float globalScale_;
    
    NSString *pListToLoad1;
    NSString *pListToLoad2;
    NSString *pListToLoad3;
    NSString *screenToLoad1;
    NSString *screenToLoad2;
    NSString *screenToLoad3;
    
    UIActivityIndicatorView *_spinner;
}

// returns a CCScene that contains the BalloonLayer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) Facebook *facebook;

@end
