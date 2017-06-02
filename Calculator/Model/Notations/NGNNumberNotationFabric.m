//
//  NGNNumberNotationFabric.m
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNNumberNotationFabric.h"
#import "NGNAbstractNotation.h"
#import "NGNBinNotation.h"
#import "NGNOctNotation.h"
#import "NGNDecNotation.h"
#import "NGNHexNotation.h"

@interface NGNNumberNotationFabric()

+ (Class)chooseNotationClassWithNotationType:(CalculatorModelNotations)notationType;

@end

@implementation NGNNumberNotationFabric

// Decodes number from stringfied number of any notation to double value of decimal notation type
+ (double)decodeNumberFromStringfiedNumber:(NSString *)stringfiedNumber
                          withNotationType:(CalculatorModelNotations)notationType {

    return [[self chooseNotationClassWithNotationType:notationType]
            decodeNumber:stringfiedNumber fromNotation:notationType];
    return 0;
}

// Encodes number from double value of decimal notation type to stringfied number of any notation
+ (NSString *)encodeNumberToString:(double)number
                  withNotationType:(CalculatorModelNotations)notationType {

    return [[self chooseNotationClassWithNotationType:notationType]
            encodeNumberToString:number withNotationType:notationType];
}

// helper method to choose necessary notation class
+ (Class)chooseNotationClassWithNotationType:(CalculatorModelNotations)notationType {
    Class notationClass;
    switch (notationType) {
        case BINNotation:
            notationClass = [NGNBinNotation class];
            break;
        case OCTNotation:
            notationClass = [NGNOctNotation class];
            break;
        case DECNotation:
            notationClass = [NGNDecNotation class];
            break;
        case HEXNotation:
            notationClass = [NGNHexNotation class];
            break;
    }
    return notationClass;
}


@end
