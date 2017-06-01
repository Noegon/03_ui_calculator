//
//  NGNNotationFabric.h
//  Calculator
//
//  Created by Alex on 01.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGNAbstractNotation.h"
#import "NGNBinNotation.h"
#import "NGNOctNotation.h"
#import "NGNDecNotation.m"
#import "NGNHexNotation.h"

@interface NGNNotationFabric: NSObject

+ (double)decodeNumberFromStringfiedNumber:(NSString *)stringfiedNumber
                          withNotationType:(CalculatorModelNotations)notationType;

+ (NSString *)encodeNumberToString:(double)number
                withNotationType:(CalculatorModelNotations)notationType;

@end
