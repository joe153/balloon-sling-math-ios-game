/*
 
 You'll see this class when you press the Game Menu button . 
 Obviously you get menus in here to jump to other levels or set your audio preferences. 
 
 OF NOTE!...
 
 the images for the menu buttons have separate -ipad.png (which is rare for this template, since none of the Box2D objects use separate -ipad image) 
 
 So for example, the level sections buttons are...
 
 levelButton1.png  (iphone /ipod non retina)
 levelButton1-hd.png (iphone retina)
 levelButton1-ipad.png (ipad )
 levelButton1-ipad-hd.png (ipad retina)
 
 Same goes for the audio buttons and the background_menu.png
 
 */


#import "cocos2d.h"
#import "GamePlayConfig.h"
#import "BalloonLayer.h"
#import "GameSounds.h"
#import "CCScrollLayer.h"

@interface LevelMenu : CCLayer {

}

+ (CCScene *)scene;

@end
