//
//  NGNDecNotation.m
//  Calculator
//
//  Created by Alex on 01.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNDecNotation.h"

@implementation NGNDecNotation

+ (NSString *)encode:(double)numberToEncode {
    return [NSString stringWithFormat:@"%g", numberToEncode];
}

@end
