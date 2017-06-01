//
//  CalculatorModel.m
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "CalculatorModel.h"
#import "Constants.h"

@interface CalculatorModel ()

#pragma mark - model logic properties
@property (assign, nonatomic) double result;
@property (retain, nonatomic) NSMutableDictionary *operations;
@property (retain, nonatomic) NSDictionary *binaryOperations;
@property (retain, nonatomic) NSDictionary *unaryOperations;
@property (retain, nonatomic) NSString *waitingOperation;
@property (assign, nonatomic) NSString *stringfiedResult;

#pragma mark - flags
@property (assign, nonatomic, getter=isRenewedCalculationChain, readwrite) BOOL renewedCalculationChain;
@property (assign, nonatomic, getter=isSecondOperandAdded, readwrite) BOOL secondOperandAdded;
@property (assign, nonatomic, getter=isEqualsOperationPerformed, readwrite) BOOL equalsOperationPerformed;

#pragma mark - helper properties
@property (retain, nonatomic) NSNumberFormatter *outputFormatter;

#pragma mark - model logic methods
- (void) performBinaryOperationWithOperator:(NSString *)operator;
- (void) performUnaryOperationWithOperator:(NSString *)operator;

#pragma mark - helper methods
- (BOOL) isBinaryOperation:(NSString *)operator;
- (BOOL) isUnaryOperation:(NSString *)operator;
- (void)exceptionHandling:(NSException *)exception;

#pragma mark - delegate helper methods
- (void)setStringfiedResultFromDoubleValue:(double)newResult;
- (void)sendMessageForDelegateWithNumber:(double)number;
- (void)sendMessageForDelegate:(NSString *)message;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (instancetype)init {
    if (self = [super init]) {
        _result = NAN;
        _renewedCalculationChain = YES;
        _secondOperandAdded = NO;
        _unaryOperations = [@{CalculatorModelSquareRootSignOperation: @"squareRoot",
                              CalculatorModelReverseSignOperation: @"reverseSign"} retain];
        
        _binaryOperations = [@{CalculatorModelDivisonRemainderOperation: @"divisionRemainder",
                               CalculatorModelPlusSignOperation: @"add",
                               CalculatorModelMinusSignOperation: @"subtract",
                               CalculatorModelMultiplicationSignOperation: @"multiply",
                               CalculatorModelDivisionSignOperation: @"divide"} retain];
        
        _operations = [[NSMutableDictionary alloc] initWithDictionary:_unaryOperations];
        [_operations addEntriesFromDictionary:_binaryOperations];
    }
    return self;
}

- (void)dealloc
{
    [_operations release];
    [_unaryOperations release];
    [_binaryOperations release];
    [_waitingOperation release];
    [_outputFormatter release];
    [super dealloc];
}

- (NSNumberFormatter *)outputFormatter {
    if (!_outputFormatter) {
        _outputFormatter = [[NSNumberFormatter alloc]init];
        _outputFormatter.maximumFractionDigits = CalculatorModelNumFormatterMaximumDisplayedFractionDigits;
        _outputFormatter.minimumIntegerDigits = CalculatorModelNumFormatterMinimumDisplayedIntegerDigits;
    }
    return _outputFormatter;
}

#pragma mark - model logic methods
// template for operations executing
- (void)executeOperationWithOperator:(NSString *)operator {
    SEL tmpSelector = NSSelectorFromString([self.operations valueForKey:operator]);
    if ([self respondsToSelector:tmpSelector]) {
        [self performSelector:tmpSelector];
    }
}

// helper method to perform binary operations
- (void) performBinaryOperationWithOperator:(NSString *)operator {
    if (self.isRenewedCalculationChain) {
        self.renewedCalculationChain = NO;
        if (self.isEqualsOperationPerformed) {
            self.currentOperand = self.result;
            self.secondOperandAdded = NO;
            self.equalsOperationPerformed = NO;
        }
        self.result = self.currentOperand;
    }
    if ([self isSecondOperandAdded]) {
        self.secondOperandAdded = NO;
        [self executeOperationWithOperator:self.waitingOperation];
    }
    self.currentOperand = self.result;
    self.secondOperandAdded = NO;
    self.waitingOperation = operator;
    [self sendMessageForDelegateWithNumber:self.result];
}

// helper method to perform unary operations
- (void) performUnaryOperationWithOperator:(NSString *)operator {
    if (self.isEqualsOperationPerformed) {
        self.currentOperand = self.result;
        self.equalsOperationPerformed = NO;
    }
    [self executeOperationWithOperator:operator];
    if (self.isRenewedCalculationChain) {
        self.result = self.currentOperand;
    }
    [self sendMessageForDelegateWithNumber:self.currentOperand];
}

// main method for executing inserted operation
- (void)calculateWithOperator:(NSString *)operator {
    @try {
        if (self.currentOperand <= DBL_MAX &&
            self.currentOperand >= -DBL_MAX) {
            
            if (isnan(self.result)) {
                self.result = self.currentOperand;
            }
            
            if ([self isBinaryOperation:operator]) {
                [self performBinaryOperationWithOperator:operator];
            }
            
            if ([self isUnaryOperation:operator]) {
                [self performUnaryOperationWithOperator:operator];
            }
        } else {
            @throw Constants.calculatorModelAmountOverflowException;
        }
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
        [self sendMessageForDelegate:self.stringfiedResult];
    }
}

- (void)setCurrentOperand:(double)currentOperand {
    if (!self.isSecondOperandAdded && !self.isRenewedCalculationChain) {
        self.secondOperandAdded = YES;
    }
    _currentOperand = currentOperand;
}

- (void)clear {
    self.result = NAN;
    self.waitingOperation = nil;
    self.currentOperand = 0;
    self.stringfiedResult = nil;
}

- (void)equals {
    @try {
        [self executeOperationWithOperator:self.waitingOperation];
        self.secondOperandAdded = NO;
        self.renewedCalculationChain = YES;
        self.equalsOperationPerformed = YES;
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
    } @finally {
        [self sendMessageForDelegateWithNumber:self.result];
    }
}

#pragma mark - mathematic operations
- (void)squareRoot {
    if (self.currentOperand >= 0) {
        self.currentOperand = sqrt(self.currentOperand);
    } else {
        @throw Constants.calculatorModelSquareRootFromNegativeException;
    }
}

- (void)reverseSign {
    self.currentOperand = -1 * self.currentOperand;
}

- (void)divisionRemainder {
    if (self.currentOperand != 0) {
        self.result = (NSInteger)round(self.result) % (NSInteger)round(self.currentOperand);
    } else {
        @throw Constants.calculatorModelDivisionByZeroException;
    }
}

- (void)add {
    self.result += self.currentOperand;
}

- (void)subtract {
    self.result -= self.currentOperand;
}

- (void)multiply {
    self.result *= self.currentOperand;
}

- (void)divide {
    if (self.currentOperand != 0) {
        self.result /= self.currentOperand;
    } else {
        @throw Constants.calculatorModelDivisionByZeroException;
    }
}

#pragma mark - helper methods

- (BOOL) isBinaryOperation:(NSString *)operator {
    return [[self.binaryOperations allKeys]containsObject:operator];
}

- (BOOL) isUnaryOperation:(NSString *)operator {
    return [[self.unaryOperations allKeys]containsObject:operator];
}

// method to help with handling my arithmetic exceptions
- (void)exceptionHandling:(NSException *)exception {
    if (exception.userInfo[ExceptionUserParamsKeysErrMessageKey]) {
        self.stringfiedResult = [NSString stringWithFormat:@"%@%@",
                                 exception.userInfo[ExceptionUserParamsKeysTagKey],
                                 exception.userInfo[ExceptionUserParamsKeysErrMessageKey]];
    }
}

#pragma mark - delegate helper methods

- (void)setStringfiedResultFromDoubleValue:(double)newResult {
    NSString *tmpStringfiedResult = [[NSMutableString stringWithString:
                                      [self.outputFormatter stringFromNumber:
                                       [NSNumber numberWithDouble:newResult]]]retain];
    [_stringfiedResult release];
    _stringfiedResult = tmpStringfiedResult;
}

- (void)sendMessageForDelegateWithNumber:(double)number {
    if (!isnan(number)) {
        [self setStringfiedResultFromDoubleValue:number];
        [self sendMessageForDelegate:self.stringfiedResult];
    }
}

- (void)sendMessageForDelegate:(NSString *)message {
    self.stringfiedResult = message;
    id<CalculatorModelDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(calculatorModel:didChangeResult:)]) {
        [strongDelegate calculatorModel:self didChangeResult:message];
    }
}

@end
