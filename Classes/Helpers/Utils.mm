#import "Utils.h"

@implementation Utils

+ (int)getRandomNumber:(int)from to:(int)to {

    return (int) from + arc4random() % (to - from + 1);
}

+ (NSString *)append:(id)first, ... {
    NSString *result = @"";
    id eachArg;
    va_list list;
    if (first) {
        result = [result stringByAppendingString:first];
        va_start(list, first);
        while (eachArg = va_arg(list, id))
            result = [result stringByAppendingString:eachArg];
        va_end(list);
    }
    return result;
}

+ (BOOL)isRetineDisplay{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // not Retine display
        return NO;
    }
}

@end