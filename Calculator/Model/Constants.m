//
//  Constants.m
//  Calculator
//
//  Created by Alex on 26.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - exceptions

+ (NSException *)divisionByZeroException {
    return [NSException exceptionWithName:divisionByZeroExceptionName
                                   reason:divisionByZeroExceptionReason
                                 userInfo:@{errMessageKey: divisionByZeroExceptionUserInfoErrMessageValue,
                                                   tagKey: tagValue}];
}

+ (NSException *)amountOverflowException {
    return [NSException exceptionWithName:amountOverflowExceptionName
                                   reason:amountOverflowExceptionReason
                                 userInfo:@{errMessageKey: amountOverflowExceptionUserInfoErrMessageValue,
                                                   tagKey: tagValue}];
}

+ (NSException *)squareRootFromNegativeException {
    return [NSException exceptionWithName:squareRootFromNegativeExceptionName
                                   reason:squareRootFromNegativeExceptionReason
                                 userInfo:@{errMessageKey: squareRootFromNegativeExceptionUserInfoErrMessageValue,
                                                   tagKey: tagValue}];
}

@end
