//
//  NGNDecNotation.m
//  Calculator
//
//  Created by Alex on 01.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNDecNotation.h"

@interface NGNDecNotation ()

@property (strong, nonatomic) NSNumberFormatter *outputFormatter;

@end

@implementation NGNDecNotation

- (instancetype)init {
    if (self = [super init]) {
        _outputFormatter = [[NSNumberFormatter alloc]init];
        _outputFormatter.maximumFractionDigits = CalculatorModelNumFormatterMaximumDisplayedFractionDigits;
        _outputFormatter.minimumIntegerDigits = CalculatorModelNumFormatterMinimumDisplayedIntegerDigits;
    }
    return self;
}

- (NSString *)encode:(double)numberToEncode {
    return [NSString stringWithFormat:@"%@", [self.outputFormatter stringFromNumber:@(numberToEncode)]];
}


@end
