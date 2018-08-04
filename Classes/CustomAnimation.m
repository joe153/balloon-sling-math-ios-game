//
//  CustomAnimation.m
//  CustomAnimationClass
//
//  Copyright 2011 CartoonSmart.com - Use this code wherever!
//

#import "CustomAnimation.h"


@implementation CustomAnimation


-(id) initWithOurOwnProperties:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop{
    
    if ((self = [super init]))
    {
        
        //CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        fileNameToAnimate = theFileNameToAnimate;
        
        frameToStartWith = theFrameToStartWith;
        currentFrame = frameToStartWith;
        
        framesToAnimate = theNumberOfFramesToAnimate;
        
        animationFlippedX = flipOnX;
        animationFlippedY = flipOnY;
        
        doesTheAnimationLoop = doesItLoop;
        useRandomFrameToLoop = doesItUseRandomFrameToLoop;
        
        someSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_000%i", fileNameToAnimate, currentFrame]];
        [self addChild:someSprite];
        someSprite.position = ccp( theX , theY );
        
        someSprite.flipX = animationFlippedX;
        someSprite.flipY = animationFlippedY;
        
        
        
        [self schedule:@selector(runMyAnimation:) interval: 1.0f / 60.0f ];
        

    }
    return self;
}

-(void) runMyAnimation:(ccTime) delta {
    
    currentFrame ++; //adds 1 to currentFrame
    
    if (currentFrame <= framesToAnimate) {
        
        //if you don't want leading zeros
        
        if (currentFrame < 10) {
        
            [someSprite setTexture:[[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_000%i", fileNameToAnimate, currentFrame]] texture] ]; 
            
        } else if (currentFrame < 100) {
         
             [someSprite setTexture:[[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_00%i", fileNameToAnimate, currentFrame]] texture] ];
            
        } else {
            
            [someSprite setTexture:[[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_0%i", fileNameToAnimate, currentFrame]] texture] ];
            
        }
        
        
    } else {
        
        if ( doesTheAnimationLoop == YES && useRandomFrameToLoop == NO) {
            
            currentFrame = frameToStartWith;
            
        } else if ( doesTheAnimationLoop == YES && useRandomFrameToLoop == YES) {
            
            // currentFrame = arc4random() % 10; // you'd get a range of 0 to 9
            
            currentFrame = arc4random() % framesToAnimate; // you'd get a range of 0 to whatever framesToAnimate is
            
        } else {
            [self removeChild:someSprite cleanup:NO];
            [self unschedule:_cmd];
        }
        
    }
    
    
}

-(void) changeOpacityTo:(int)theNewOpacity {
    
    someSprite.opacity = theNewOpacity;  //range of 0 to 255
    
}


-(void) tintMe:(ccColor3B)theColor {
    
    someSprite.color = theColor;
    
}



+(id) createClassWithFile:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY  doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop{
    
    return [[[self alloc] initWithOurOwnProperties:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY  doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop] autorelease];
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
