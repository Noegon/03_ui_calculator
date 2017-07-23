//
//  Constants.h
//  Calculator
//
//  Created by Alex on 26.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - common constants

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height

typedef struct {
    double result;
    double currentOperand;
} Results;

typedef void(^operation_t)(double result, double currentOperand, Results *results);
typedef void(^no_params_operation_t)(void);

typedef const enum {
    BINNotation, OCTNotation, DECNotation, HEXNotation
} CalculatorModelNotations;

#pragma mark - model constants
static NSString *const CalculatorModelSquareRootSignOperation = @"√";
static NSString *const CalculatorModelDivisonRemainderOperation = @"%";
static NSString *const CalculatorModelPlusSignOperation = @"+";
static NSString *const CalculatorModelMinusSignOperation = @"-";
static NSString *const CalculatorModelMultiplicationSignOperation = @"x";
static NSString *const CalculatorModelDivisionSignOperation = @"/";
static NSString *const CalculatorModelReverseSignOperation = @"+/-";
static NSString *const CalculatorModelEqualsSignOperation = @"=";
static NSString *const CalculatorModelBinaryNotationOperation = @"BIN";
static NSString *const CalculatorModelOctalNotationOperation = @"OCT";
static NSString *const CalculatorModelDecimalNotationOperation = @"DEC";
static NSString *const CalculatorModelHexadecimalNotationOperation = @"HEX";
static NSInteger const CalculatorModelNumFormatterMaximumDisplayedFractionDigits = 6;
static NSInteger const CalculatorModelNumFormatterMinimumDisplayedIntegerDigits = 1;

#pragma mark - controller constants
static NSString *const ViewControllerDotString = @".";
static NSString *const ViewControllerZeroString = @"0";
static NSInteger const ViewControllerMaxAmountOfDigitsInInsertionField = 16;

//notationButtonsBoundedParameters keys
static NSString *const ViewControllerNotationButtonsBoundedParametersNotationTypeKey = @"notationType";
static NSString *const ViewControllerNotationButtonsBoundedParametersDisabledButtonsKey = @"disabledButtons";
static NSString *const ViewControllerNotationButtonsBoundedParametersButtonKey = @"button";

#pragma mark - some view titles
static NSString *const ViewControllerLicenseTitle = @"License";
static NSString *const ViewControllerAboutTitle = @"About";

#pragma mark - exceptions parameters
//user info keys:
static NSString *const ExceptionUserParamsKeysTagKey = @"tag";
static NSString *const ExceptionUserParamsKeysErrMessageKey = @"errMessage";

//user info tag values:
static NSString *const ExceptionUserParamsValuesTagValue = @"err";

//user info errorMessage values:
static NSString *const ExceptionValuesDivisionByZeroExceptionUserParamsErrMessageValue = @" - div by zero!";
static NSString *const ExceptionValuesAmountOverflowExceptionUserParamsErrMessageValue = @" - large number!";
static NSString *const ExceptionValuesSquareRootFromNegativeExceptionUserParamsErrMessageValue = @" - sq root from neg!";

//names:
static NSString *const ExceptionDivisionByZeroExceptionName = @"Division by zero";
static NSString *const ExceptionAmountOverflowExceptionName = @"Amount overflow";
static NSString *const ExceptionSquareRootFromNegativeExceptionName = @"Square root from negative";

//reasons:
static NSString *const ExceptionDivisionByZeroExceptionReason = @"Division by zero";
static NSString *const ExceptionAmountOverflowExceptionReason = @"Too large number";
static NSString *const ExceptionSquareRootFromNegativeExceptionReason = @"Square root from negative";


@interface Constants : NSObject

#pragma mark - exceptions
+ (NSException *)calculatorModelDivisionByZeroException;
+ (NSException *)calculatorModelAmountOverflowException;
+ (NSException *)calculatorModelSquareRootFromNegativeException;

@end
