//
//  AbstractNotation.m
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNAbstractNotation.h"

@implementation NGNAbstractNotation

+ (double)decodeNumber:(NSString *)stringfiedNumber fromNotation:(Notations)notation {
    const char *utf8String2 = [stringfiedNumber UTF8String];
    const char *utf8String8 = [stringfiedNumber UTF8String];
    const char *utf8String16 = [stringfiedNumber UTF8String];
    NSUInteger result;
    switch (notation) {
        case BINNotation:
            result = strtol(utf8String2, NULL, 2);
            break;
        case OCTNotation:
            result = strtol(utf8String8, NULL, 8);
            break;
        case DECNotation:
            result = stringfiedNumber.doubleValue;
            break;
        case HEXNotation:
            result = strtol(utf8String16, NULL, 16);
            break;
    }
    return (double)result;
}

@end
