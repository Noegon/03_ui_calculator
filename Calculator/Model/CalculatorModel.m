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

@property (assign, nonatomic) double result;
@property (assign, nonatomic) double lastInsertedOperand;

@property (retain, nonatomic) NSMutableDictionary *operations;
@property (retain, nonatomic) NSDictionary *binaryOperations;
@property (retain, nonatomic) NSDictionary *unaryOperations;
@property (retain, nonatomic) NSString *waitingOperation;

@property (assign, nonatomic) NSString *stringfiedResult;

@property (assign, nonatomic, getter=isRenewedCalculationChain, readwrite) BOOL renewedCalculationChain;
@property (assign, nonatomic, getter=isSecondOperandAdded, readwrite) BOOL secondOperandAdded;
@property (assign, nonatomic, getter=isEqualsOperationPerformed, readwrite) BOOL equalsOperationPerformed;

#pragma mark - main logic methods
- (void)executeBinaryOperation;
- (void)executeUnaryOperationWithOperator:(NSString *)operator;
- (void)executeOperationWithOperator:(NSString *)operator;

#pragma mark - helper arguments
@property (retain, nonatomic) NSNumberFormatter *outputFormatter;

#pragma mark - helper methods
- (BOOL) isBinaryOperation:(NSString *)operator;
- (BOOL) isUnaryOperation:(NSString *)operator;
- (void) performBinaryOperationWithOperator:(NSString *)operator;
- (void) performUnaryOperationWithOperator:(NSString *)operator;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (instancetype)init {
    if (self = [super init]) {
        _result = NAN;
        _renewedCalculationChain = YES;
        _secondOperandAdded = NO;
        _unaryOperations = [@{squareRootSign: @"squareRoot",
                              reverseSign: @"reverseSign"} retain];
        
        _binaryOperations = [@{percentSign: @"divisionRemainder",
                               plusSign: @"add",
                               minusSign: @"subtract",
                               multiplicationSign: @"multiply",
                               divisionSign: @"divide"} retain];
        
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
        _outputFormatter.maximumFractionDigits = maximumDisplayedFractionDigits;
        _outputFormatter.minimumIntegerDigits = minimumDisplayedIntegerDigits;
    }
    return _outputFormatter;
}

#pragma mark - model logic methods
// template for operations executing
- (void)executeRawOperation:(NSString *)operator {
    SEL tmpSelector = NSSelectorFromString([self.operations valueForKey:operator]);
    if ([self respondsToSelector:tmpSelector]) {
        [self performSelector:tmpSelector];
    }
}

// executing last inserted binary operation
- (void)executeBinaryOperation {
    [self executeRawOperation:self.waitingOperation];
    self.secondOperandAdded = NO;
    [self sendMessageWithResultForDelegate];
}

// executing current unary operation
- (void)executeUnaryOperationWithOperator:(NSString *)operator {
    [self executeRawOperation:operator];
    [self sendMessageWithCurrentOperandForDelegate];
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
        [self executeBinaryOperation];
    }
    self.currentOperand = self.result;
    self.secondOperandAdded = NO;
    self.waitingOperation = operator;
}

// helper method to perform unary operations
- (void) performUnaryOperationWithOperator:(NSString *)operator {
    if (self.isEqualsOperationPerformed) {
        self.currentOperand = self.result;
        self.equalsOperationPerformed = NO;
    }
    [self executeUnaryOperationWithOperator:operator];
    if (self.isRenewedCalculationChain) {
        self.result = self.currentOperand;
    }
}

// main method for executing inserted operation
- (void)executeOperationWithOperator:(NSString *)operator {
    
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
        @throw Constants.amountOverflowException;
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
    [self executeBinaryOperation];
    self.renewedCalculationChain = YES;
    self.equalsOperationPerformed = YES;
}

- (BOOL) isBinaryOperation:(NSString *)operator {
    return [[self.binaryOperations allKeys]containsObject:operator];
}

- (BOOL) isUnaryOperation:(NSString *)operator {
    return [[self.unaryOperations allKeys]containsObject:operator];
}

#pragma mark - delegate helper methods

- (void)setStringfiedResultFromDoubleValue:(double)newResult {
    NSString *tmpStringfiedResult = [[NSMutableString stringWithString:
                                     [self.outputFormatter stringFromNumber:
                                      [NSNumber numberWithDouble:newResult]]]retain];
    [_stringfiedResult release];
    _stringfiedResult = tmpStringfiedResult;
}

- (void)sendMessageWithResultForDelegate {
    [self sendMessageForDelegateWithNumber:self.result];
}

- (void)sendMessageWithCurrentOperandForDelegate {
    [self sendMessageForDelegateWithNumber:self.currentOperand];
}

- (void)sendMessageForDelegateWithNumber:(double)number {
    if (!isnan(number)) {
        [self setStringfiedResultFromDoubleValue:number];
        
        id<CalculatorModelDelegate> strongDelegate = self.delegate;
        
        if ([strongDelegate respondsToSelector:@selector(calculatorModel:didChangeResult:)]) {
            [strongDelegate calculatorModel:self didChangeResult:self.stringfiedResult];
        }
    }
}

#pragma mark - mathematic operations
- (void)squareRoot {
    if (self.currentOperand >= 0) {
        self.currentOperand = sqrt(self.currentOperand);
    } else {
        @throw Constants.squareRootFromNegativeException;
    }
}

- (void)reverseSign {
    self.currentOperand = -1 * self.currentOperand;
}

- (void)divisionRemainder {
    if (self.currentOperand != 0) {
        self.result = (NSInteger)round(self.result) % (NSInteger)round(self.currentOperand);
    } else {
        @throw Constants.divisionByZeroException;
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
        @throw Constants.divisionByZeroException;
    }
}

@end
