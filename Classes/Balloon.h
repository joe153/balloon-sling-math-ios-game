//
//  Balloon.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Balloon : NSObject
{
    CCSprite* sprite_;
    CCLabelTTF* label_;
    float speed_;
    float scale_;
    NSString* string_;
    int  pointValue;
    int  simpleScoreVisualFX; //defined in Constants.h
}

@property (readwrite, retain) CCSprite* sprite;
@property (readwrite, retain) CCLabelTTF* label;
@property (readwrite, retain) NSString* string;
@property (readwrite, assign) float speed;
@property (nonatomic) int pointValue;
@property (nonatomic) int simpleScoreVisualFX;

-(id) init:(float) scale sprite:(CCSprite*) sprite;
-(id) initWithString:(float) scale sprite:(CCSprite*) sprite string:(NSString*) string;
-(void) raise:(float) delta;
-(void) setString:(NSString*) string;
-(void) setPosition:(CGPoint) position;
-(void) setScale:(float) scale;

-(void) initLabel:(int) fontSize;

@end
