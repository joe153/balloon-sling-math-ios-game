#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HelpLayer : CCLayer {
    NSInvocation *callback;
    NSString *buttonName;
}

- (id)initWithHeader2Buttons:(NSString *)header target:(id)callbackObj selector:(SEL)selector target2:(id)callbackMainMenuObj;

@end