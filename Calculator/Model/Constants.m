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

+ (NSException *)calculatorModelDivisionByZeroException {
    return [NSException exceptionWithName:ExceptionDivisionByZeroExceptionName
                                   reason:ExceptionDivisionByZeroExceptionReason
                                 userInfo:@{ExceptionUserParamsKeysErrMessageKey:
                                                ExceptionValuesDivisionByZeroExceptionUserParamsErrMessageValue,
                                            ExceptionUserParamsKeysTagKey: ExceptionUserParamsValuesTagValue}];
}

+ (NSException *)calculatorModelAmountOverflowException {
    return [NSException exceptionWithName:ExceptionAmountOverflowExceptionName
                                   reason:ExceptionAmountOverflowExceptionReason
                                 userInfo:@{ExceptionUserParamsKeysErrMessageKey:
                                                ExceptionValuesAmountOverflowExceptionUserParamsErrMessageValue,
                                            ExceptionUserParamsKeysTagKey: ExceptionUserParamsValuesTagValue}];
}

+ (NSException *)calculatorModelSquareRootFromNegativeException {
    return [NSException exceptionWithName:ExceptionSquareRootFromNegativeExceptionName
                                   reason:ExceptionSquareRootFromNegativeExceptionReason
                                 userInfo:@{ExceptionUserParamsKeysErrMessageKey: ExceptionValuesSquareRootFromNegativeExceptionUserParamsErrMessageValue,                                                  ExceptionUserParamsKeysTagKey: ExceptionUserParamsValuesTagValue}];
}

@end
