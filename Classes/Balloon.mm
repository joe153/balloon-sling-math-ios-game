//
//  Balloon.m
//

#import "Balloon.h"
#import "Constants.h"
#import "GamePlayConfig.h"

@implementation Balloon

@synthesize sprite = sprite_, label = label_, speed = speed_, string = string_;
@synthesize pointValue,simpleScoreVisualFX;

- (id)init:(float)scale sprite:(CCSprite *)sprite {
    return [self initWithString:scale sprite:sprite string:@""];
}

- (id)initWithString:(float)scale sprite:(CCSprite *)sprite string:(NSString *)string {
    speed_ = [[GamePlayConfig instance] balloonSpeed];
    scale_ = 1.5f;  //1.5f
    sprite.scale = scale_;
    pointValue = 10;
    simpleScoreVisualFX = breakEffectSmokePuffs;//breakEffectExplosion,breakEffectSmokePuffs

    sprite_ = sprite;
    string_ = string;

    [self setScale:scale];

    // has to consider showing two digits on the balloon
    int fontSize = 20;
    if (scale < 0.04) {
        fontSize = 15;
    }
    else if (scale < 0.08) {
        fontSize = 20;
    }
    else if (scale < 0.1) {
        fontSize = 25;
    }
    else if (scale < 0.12) {
        fontSize = 30;
    }
    else if (scale < 0.15) {
        fontSize = 35;
    }
    if (IS_IPAD)
        fontSize = fontSize + 20;

    [self initLabel:fontSize];

    return self;
}

- (void)initLabel:(int)fontSize {
    label_ = [CCLabelTTF labelWithString:string_ fontName:@"Helvetica" fontSize:fontSize];
    label_.position = sprite_.position;
}

- (void)setPosition:(CGPoint)position {
    label_.position = position;
    sprite_.position = position;
}

- (void)raise:(float)delta {
    CGPoint pos = [self.sprite position];
    pos.y += delta;

    self.sprite.position = pos;
    label_.position = pos;
}

- (void)setString:(NSString *)string {
    [self.label setString:string];
}

- (void)setScale:(float)scale {
    scale_ = scale;
    sprite_.scale = scale;
}
@end
