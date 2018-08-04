//
//  CCMenuItemFontWithStroke.h
//

#import "CCMenuItem.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCMenuItemFontWithStroke : CCMenuItemFont{
   int stokeSize;
   ccColor3B strokeColor;

}

@property (nonatomic) int stokeSize;
@property (nonatomic)ccColor3B strokeColor;

-(id) initFromString: (NSString*) value target:(id) rec selector:(SEL) cb  strokeSize:(int)strokeSize stokeColor:(ccColor3B)color;

@end