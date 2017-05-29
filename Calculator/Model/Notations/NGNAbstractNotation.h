//
//  AbstractNotation.h
//  Calculator
//
//  Created by Alex on 29.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NGNAbstractNotation : NSObject

+ (double)decodeNumber:(NSString *)stringfiedNumber fromNotation:(Notations)notation;
+ (NSString *)encode:(double)numberToEncode;

@end
