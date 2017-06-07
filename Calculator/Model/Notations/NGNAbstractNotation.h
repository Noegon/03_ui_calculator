//
//  AbstractNotation.h
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol NGNNotationConvertible <NSObject>

@optional
- (NSString *)encode:(double)numberToEncode;
@required
- (double)decodeNumber:(NSString *)stringfiedNumber
          fromNotation:(CalculatorModelNotations)notation;

@end

@interface NGNAbstractNotation: NSObject <NGNNotationConvertible>

@end
