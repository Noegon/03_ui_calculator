//
//  BINNotation.m
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNBinNotation.h"

@implementation NGNBinNotation

- (NSString *)encode:(double)numberToEncode {
    NSString *binToString = @"";
    NSInteger x = (NSInteger)numberToEncode;
    while (x > 0) {
        binToString = [[NSString stringWithFormat:@"%lu", x & 1]stringByAppendingString:binToString];
        x >>= 1;
    }
    if (!binToString.length) {
        binToString = ViewControllerZeroString;
    }
    return binToString;
}

@end
