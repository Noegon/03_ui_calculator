//
//  BINNotation.m
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNBinNotation.h"

@implementation NGNBinNotation

+ (NSString *)encode:(double)numberToEncode {
    NSString *binToString = @"";
    NSUInteger x = (NSUInteger)numberToEncode;
    while (x > 0) {
        binToString = [[NSString stringWithFormat:@"%lu", x & 1]stringByAppendingString:binToString];
        x >>= 1;
    }
    return binToString;
}

@end
