//
// JRubens Inc.
//


#import <Foundation/Foundation.h>


@interface Question : NSObject
{
    int answer;
    NSString *questionString;
}
@property(nonatomic, assign) int answer;
@property(nonatomic, copy) NSString *questionString;

// could return the correct answer or a wrong answer but guaranteed to return the correct one within x number of calls
- (int)possibleAnswer;

@end