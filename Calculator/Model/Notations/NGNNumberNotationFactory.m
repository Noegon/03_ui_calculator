//
//  NGNNumberNotationFabric.m
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNNumberNotationFactory.h"
#import "NGNAbstractNotation.h"
#import "NGNBinNotation.h"
#import "NGNOctNotation.h"
#import "NGNDecNotation.h"
#import "NGNHexNotation.h"

@interface NGNNumberNotationFactory()

- (NGNAbstractNotation *)chooseNotationClassWithNotationType:(CalculatorModelNotations)notationType;

@end

@implementation NGNNumberNotationFactory

+ (instancetype)sharedInstance {
    static NGNNumberNotationFactory *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NGNNumberNotationFactory alloc] init];
    });
    return sharedInstance;
}

// Decodes number from stringfied number of any notation to double value of decimal notation type
- (double)decodeNumberFromStringfiedNumber:(NSString *)stringfiedNumber
                          withNotationType:(CalculatorModelNotations)notationType {

    return [[self chooseNotationClassWithNotationType:notationType]
            decodeNumber:stringfiedNumber fromNotation:notationType];
}

// Encodes number from double value of decimal notation type to stringfied number of any notation
- (NSString *)encodeNumberToString:(double)number
                  withNotationType:(CalculatorModelNotations)notationType {

    return [[self chooseNotationClassWithNotationType:notationType] encode:number];
}

// helper method to choose necessary notation class
- (NGNAbstractNotation *)chooseNotationClassWithNotationType:(CalculatorModelNotations)notationType {
    NGNAbstractNotation * notation;
    switch (notationType) {
        case BINNotation:
            notation = [[[NGNBinNotation alloc]init]autorelease];
            break;
        case OCTNotation:
            notation = [[[NGNOctNotation alloc]init]autorelease];
            break;
        case DECNotation:
            notation = [[[NGNDecNotation alloc]init]autorelease];
            break;
        case HEXNotation:
            notation = [[[NGNHexNotation alloc]init]autorelease];
            break;
    }
    return notation;
}


@end
