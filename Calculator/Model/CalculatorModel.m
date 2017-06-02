//
//  CalculatorModel.m
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "CalculatorModel.h"
#import "NSMutableArray+QueueAdditions.h"
#import "Constants.h"

@interface CalculatorModel ()

#pragma mark - model logic properties
@property (assign, nonatomic) double result;
@property (retain, nonatomic) NSMutableDictionary *operations; //contains both of unary and binary operations
@property (retain, nonatomic) NSDictionary *binaryOperations;
@property (retain, nonatomic) NSDictionary *unaryOperations;
@property (retain, nonatomic) NSString *waitingOperation;
@property (assign, nonatomic) NSString *stringfiedResult;
@property (retain, nonatomic) NSMutableArray<NSNumber *> *operandQueue; // could contain from 0 to 2 values

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
        _operandQueue = [[NSMutableArray alloc]init];
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
    [_operandQueue release];
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
    if (!self.operandQueue.count) {
        [self.operandQueue ngn_enqueue:[NSNumber numberWithFloat: self.currentOperand]];
    }
    
    if (self.operandQueue.count == 1 &&
        self.operandQueue.firstObject.doubleValue != self.currentOperand) {
        [self.operandQueue ngn_enqueue:[NSNumber numberWithFloat: self.currentOperand]];
        self.secondOperandAdded = YES;
    }
    
    if (self.isSecondOperandAdded) {
        [self executeOperationWithOperator:operator];
        [self.operandQueue ngn_enqueue:[NSNumber numberWithFloat: self.result]];
        self.result = self.currentOperand;
        self.secondOperandAdded = NO;
        [self sendMessageForDelegateWithNumber:self.result];
    }
    
    self.waitingOperation = operator;
}

// helper method to perform unary operations
- (void) performUnaryOperationWithOperator:(NSString *)operator {

}

// main method for executing inserted operation
- (void)calculateWithOperator:(NSString *)operator {
    @try {
        if (self.currentOperand <= DBL_MAX &&
            self.currentOperand >= -DBL_MAX) {
            
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
    _currentOperand = currentOperand;
}

- (void)clear {
    self.result = NAN;
    self.waitingOperation = nil;
    self.currentOperand = 0;
    self.stringfiedResult = nil;
    [self.operandQueue ngn_eraseQueue];
}

- (void)equals {
    @try {
        if (!self.operandQueue.count) {
            [self.operandQueue ngn_enqueue:[NSNumber numberWithFloat:self.result]];
            [self.operandQueue ngn_enqueue:[NSNumber numberWithFloat:self.currentOperand]];
        }
        [self executeOperationWithOperator:self.waitingOperation];
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
    } @finally {
        [self sendMessageForDelegateWithNumber:self.result];
    }
}

#pragma mark - mathematic operations
- (void)squareRoot {
    if (self.currentOperand >= 0) {
        self.result = sqrt(self.currentOperand);
    } else {
        @throw Constants.calculatorModelSquareRootFromNegativeException;
    }
}

- (void)reverseSign {
    self.result = -1 * self.currentOperand;
}

- (void)divisionRemainder {
    if ([[self.operandQueue lastObject]longValue] != 0) {
        self.result = [self.operandQueue.ngn_dequeue longValue] % [self.operandQueue.ngn_dequeue longValue];
    } else {
        @throw Constants.calculatorModelDivisionByZeroException;
    }
}

- (void)add {
    self.result = [self.operandQueue.ngn_dequeue doubleValue] + [self.operandQueue.ngn_dequeue doubleValue];
}

- (void)subtract {
    self.result = [self.operandQueue.ngn_dequeue doubleValue] - [self.operandQueue.ngn_dequeue doubleValue];
}

- (void)multiply {
    self.result = [self.operandQueue.ngn_dequeue doubleValue] * [self.operandQueue.ngn_dequeue doubleValue];
}

- (void)divide {
    if ([[self.operandQueue lastObject]longValue] != 0) {
        self.result = [self.operandQueue.ngn_dequeue doubleValue] / [self.operandQueue.ngn_dequeue doubleValue];
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
