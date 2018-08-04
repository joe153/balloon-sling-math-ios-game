//
// JRubens Inc.
//


#import <Foundation/Foundation.h>


@interface GameData : NSObject
{
    // current level
    int currentLevel;

    BOOL gamePurchased;

    // is addition enabled?
    BOOL addition;

    // is subtraction enabled?
    BOOL subtraction;

    // skill level
    int minNumberAddition, maxNumberAddition;

}
@property(nonatomic, assign) int currentLevel;
@property(nonatomic, assign) BOOL addition;
@property(nonatomic, assign) BOOL subtraction;
@property(nonatomic, assign) int minNumberAddition;
@property(nonatomic, assign) int maxNumberAddition;
@property(nonatomic, assign) BOOL gamePurchased;

@end