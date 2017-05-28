//
//  Constants.h
//  Calculator
//
//  Created by Alex on 26.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - common constants

static NSString *const squareRootSign = @"√";
static NSString *const percentSign = @"%";
static NSString *const plusSign = @"+";
static NSString *const minusSign = @"-";
static NSString *const multiplicationSign = @"x";
static NSString *const divisionSign = @"/";
static NSString *const reverseSign = @"+/-";
static NSString *const dotString = @".";
static NSString *const zeroString = @"0";
static NSInteger const maxAmountOfDigitsInInsertionField = 16;
static NSInteger const maximumDisplayedFractionDigits = 6;
static NSInteger const minimumDisplayedIntegerDigits = 1;

#pragma mark - some view titles
static NSString *const licenseTitle = @"License";
static NSString *const aboutTitle = @"About";

#pragma mark - exceptions parameters
//user info keys:
static NSString *const tagKey = @"tag";
static NSString *const errMessageKey = @"errMessage";

//user info tag values:
static NSString *const tagValue = @"err";

//user info errorMessage values:
static NSString *const divisionByZeroExceptionUserInfoErrMessageValue = @" - div by zero!";
static NSString *const amountOverflowExceptionUserInfoErrMessageValue = @" - large number!";
static NSString *const squareRootFromNegativeExceptionUserInfoErrMessageValue = @" - sq root from neg!";

//names:
static NSString *const divisionByZeroExceptionName = @"Division by zero";
static NSString *const amountOverflowExceptionName = @"Amount overflow";
static NSString *const squareRootFromNegativeExceptionName = @"Square root from negative";

//reasons:
static NSString *const divisionByZeroExceptionReason = @"Division by zero";
static NSString *const amountOverflowExceptionReason = @"Too large number";
static NSString *const squareRootFromNegativeExceptionReason = @"Square root from negative";

@interface Constants : NSObject

#pragma mark - exceptions
+ (NSException *)divisionByZeroException;
+ (NSException *)amountOverflowException;
+ (NSException *)squareRootFromNegativeException;

@end
