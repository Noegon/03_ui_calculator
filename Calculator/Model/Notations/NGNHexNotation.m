//
//  NGNHexNotation.m
//  Calculator
//
//  Created by Alex on 01.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNHexNotation.h"

@implementation NGNHexNotation

- (NSString *)encode:(double)numberToEncode {
    return [NSString stringWithFormat:@"%lX", (NSUInteger)numberToEncode];
}

@end
