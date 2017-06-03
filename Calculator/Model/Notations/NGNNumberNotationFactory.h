//
//  NGNNumberNotationFabric.h
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NGNNumberNotationFactory : NSObject

+ (instancetype)sharedInstance;

- (double)decodeNumberFromStringfiedNumber:(NSString *)stringfiedNumber
                          withNotationType:(CalculatorModelNotations)notationType;

- (NSString *)encodeNumberToString:(double)number
                withNotationType:(CalculatorModelNotations)notationType;

@end
