//
//  NGNOctNotation.m
//  Calculator
//
//  Created by Alex on 01.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNOctNotation.h"

@implementation NGNOctNotation

+ (NSString *)encode:(double)numberToEncode {
    return [NSString stringWithFormat:@"%lo", (NSUInteger)numberToEncode];
}

@end
