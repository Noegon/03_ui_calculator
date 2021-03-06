//
//  AbstractNotation.m
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNAbstractNotation.h"

@implementation NGNAbstractNotation

- (double)decodeNumber:(NSString *)stringfiedNumber
          fromNotation:(CalculatorModelNotations)notation {
    const char *utf8String = [stringfiedNumber UTF8String];
    NSInteger result = 0;
    if (utf8String != NULL) {
        switch (notation) {
            case BINNotation:
                result = strtol(utf8String, NULL, 2);
                break;
            case OCTNotation:
                result = strtol(utf8String, NULL, 8);
                break;
            case DECNotation:
                result = stringfiedNumber.doubleValue;
                break;
            case HEXNotation:
                result = strtol(utf8String, NULL, 16);
                break;
        }
    }
    return (double)result;
}

@end
