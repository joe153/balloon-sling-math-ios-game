//
//  CustomAnimation.h
//  CustomAnimationClass
//

//  Copyright 2011 CartoonSmart.com - Use this code wherever! 
//

/*
 
 This class gives you a very easy way to animate. The example code below adds a child of type CustomAnimation name fireball. The example code below is pretty easy to understand but if not, then keep reading...
 
 CustomAnimation* fireball = [CustomAnimation createClassWithFile:@"fireball" theFrameToStartWith:1 theNumberOfFramesToAnimate:36 theX:300 theY:400 flipOnX:NO flipOnY:NO doesItLoop:NO doesItUseRandomFrameToLoop:NO];
 [self addChild:fireball ];
 
 ... 
 So this would playing through a 36 frame animation starting with "fireball0001.png" onto "fireball0036.png" . Your source file names DO need leading zeros (unless you want to alter the code in the .m file to change that)
 
 You can also specify these options
 
 theX: the x location 
 theY: the y location
 flipOnX: YES OR NO whether to flip the animation horizontally
 flipOnY: YES OR NO whether to flip the animation vertically
 doesItLoop: YES OR NO to loop the animation (if no, it will remove itself)
 doesItUseRandomFrameToLoop: YES OR NO whether to loop back to a random frame instead of frame 1
 
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CustomAnimation : CCNode {
    
    NSString *fileNameToAnimate;
    int currentFrame;
    int framesToAnimate;
    int frameToStartWith;
    
    CCSprite *someSprite;
    
    bool animationFlippedX;
    bool animationFlippedY;
    bool doesTheAnimationLoop;
    bool useRandomFrameToLoop;
}

+(id) createClassWithFile:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop;

-(void) tintMe:(ccColor3B)theColor;
-(void) changeOpacityTo:(int)theNewOpacity;

@end
