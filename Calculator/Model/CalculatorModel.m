//
//  CalculatorModel.m
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "CalculatorModel.h"
#import "NGNNumberNotationFactory.h"
#import "Constants.h"

typedef struct {
    double result;
    double currentOperand;
} Results;
//typedef Results(^operation_t)(double result, double currentOperand, );
//typedef void(^operation_t)(double *result, double *currentOperand);
typedef void(^operation_t)(void);

@interface CalculatorModel ()

#pragma mark - model logic properties
@property (assign, nonatomic) __block double currentOperand;
@property (assign, nonatomic) __block double result;
@property (strong, nonatomic) NSMutableDictionary *operations; //contains both of unary and binary operations
@property (strong, nonatomic) NSDictionary *binaryOperations;
@property (strong, nonatomic) NSDictionary *unaryOperations;
@property (strong, nonatomic) NSString *waitingOperation;
@property (strong, nonatomic) NSString *stringfiedResult;
@property (assign, nonatomic) __block NSInteger currentNotation;

#pragma mark - flags
@property (assign, nonatomic, getter=isRenewedCalculationChain, readwrite) BOOL renewedCalculationChain;
@property (assign, nonatomic, getter=isSecondOperandAdded, readwrite) BOOL secondOperandAdded;
@property (assign, nonatomic, getter=isEqualsOperationPerformed, readwrite) BOOL equalsOperationPerformed;

#pragma mark - model logic methods
- (void)performBinaryOperationWithOperator:(NSString *)operator;
- (void)performUnaryOperationWithOperator:(NSString *)operator;

#pragma mark - helper methods
- (BOOL)isBinaryOperation:(NSString *)operator;
- (BOOL)isUnaryOperation:(NSString *)operator;
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

        __weak CalculatorModel *weakSelf = self;
        
        _unaryOperations = @{CalculatorModelSquareRootSignOperation: ^{
                                 if (weakSelf.currentOperand >= 0) {
                                     [weakSelf setCurrentOperandWithoutSideEffects:sqrt(weakSelf.currentOperand)];
                                 }
                                 else {
                                     @throw Constants.calculatorModelSquareRootFromNegativeException;
                                 }
                             },
                             CalculatorModelReverseSignOperation: ^{
                                 [weakSelf setCurrentOperandWithoutSideEffects:(-1 * weakSelf.currentOperand)];
                             },
                             CalculatorModelBinaryNotationOperation: ^{
                                 weakSelf.currentNotation = BINNotation;
                             },
                             CalculatorModelOctalNotationOperation: ^{
                                 weakSelf.currentNotation = OCTNotation;
                             },
                             CalculatorModelDecimalNotationOperation: ^{
                                 weakSelf.currentNotation = DECNotation;
                             },
                             CalculatorModelHexadecimalNotationOperation: ^{
                                 weakSelf.currentNotation = DECNotation;
                             }};
        
        _binaryOperations = @{CalculatorModelDivisonRemainderOperation: ^{
                                  if (weakSelf.currentOperand != 0) {
                                      weakSelf.result = (NSInteger)weakSelf.result % (NSInteger)weakSelf.currentOperand;
                                  } else {
                                      @throw Constants.calculatorModelDivisionByZeroException;
                                  }
                              },
                              CalculatorModelPlusSignOperation: ^{
                                  weakSelf.result += weakSelf.currentOperand;
                              },
                              CalculatorModelMinusSignOperation: ^{
                                  weakSelf.result -= weakSelf.currentOperand;
                              },
                              CalculatorModelMultiplicationSignOperation: ^{
                                  weakSelf.result *= weakSelf.currentOperand;
                              },
                              CalculatorModelDivisionSignOperation: ^{
                                  if (weakSelf.currentOperand != 0) {
                                      weakSelf.result /= weakSelf.currentOperand;
                                  }
                                  else {
                                      @throw Constants.calculatorModelDivisionByZeroException;
                                  }
                              }};
    
        _operations = [[NSMutableDictionary alloc] initWithDictionary:_unaryOperations];
        [_operations addEntriesFromDictionary:_binaryOperations];
    }
    return self;
}


#pragma mark - model logic methods
// template for operations executing
- (void)executeOperationWithOperator:(NSString *)operator {
    operation_t operation = self.operations[operator];
    operation();
    self.secondOperandAdded = NO;
}

// helper method to perform binary operations
- (void) performBinaryOperationWithOperator:(NSString *)operator {
    if (self.isEqualsOperationPerformed) {
        self.equalsOperationPerformed = NO;
    }
    if (self.isRenewedCalculationChain) {
        self.renewedCalculationChain = NO;
    }
    if (self.isSecondOperandAdded) {
        self.secondOperandAdded = NO;
        [self executeOperationWithOperator:self.waitingOperation];
        [self sendMessageForDelegateWithNumber:self.result];
    }
    self.waitingOperation = operator;
}

// helper method to perform unary operations
- (void) performUnaryOperationWithOperator:(NSString *)operator {
    if (self.isEqualsOperationPerformed) {
        self.equalsOperationPerformed = NO;
        [self setCurrentOperandWithoutSideEffects:self.result];
    }
    [self executeOperationWithOperator:operator];
    if (self.isRenewedCalculationChain ||
        isnan(self.result)) {
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
        }
        else {
            @throw Constants.calculatorModelAmountOverflowException;
        }
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
        [self sendMessageForDelegate:self.stringfiedResult];
    }
}

- (void)setCurrentOperand:(double)currentOperand {
    if (!isnan(self.result) && !self.isRenewedCalculationChain) {
        self.secondOperandAdded = YES;
    }
//    if (isnan(_currentOperand)) {
//        _currentOperand = 0;
//    }
    if (self.isEqualsOperationPerformed && !self.isSecondOperandAdded) {
        self.equalsOperationPerformed = NO;
        self.result = currentOperand;
    }
    _currentOperand = currentOperand;
}

- (void)setCurrentOperandWithoutSideEffects:(double)currentOperand {
    _currentOperand = currentOperand;
}

- (void)setCurrentOperandWithString:(NSString *)stringfiedCurrentOperand {
    NSLog(@"notation = %ld", (long)self.currentNotation);
    double decimalNotationValue =
    [[NGNNumberNotationFactory sharedInstance] decodeNumberFromStringfiedNumber:stringfiedCurrentOperand
                                                               withNotationType:(CalculatorModelNotations)self.currentNotation];
    self.currentOperand = decimalNotationValue;
}

- (void)setCurrentNotation:(NSInteger)notation {
    _currentNotation = notation;
}

- (void)clear {
    self.result = NAN;
    self.waitingOperation = nil;
    [self setCurrentOperandWithoutSideEffects:0];
    self.stringfiedResult = nil;
    self.secondOperandAdded = NO;
    self.renewedCalculationChain = YES;
    self.equalsOperationPerformed = NO;
    
}

- (void)equals {
    @try {
        [self executeOperationWithOperator:self.waitingOperation];
        self.renewedCalculationChain = YES;
        self.equalsOperationPerformed = YES;
        [self sendMessageForDelegateWithNumber:self.result];
    }
    @catch (NSException *exception) {
        [self exceptionHandling:exception];
        [self sendMessageForDelegate:self.stringfiedResult];
    }
}

#pragma mark - helper methods

- (BOOL) isBinaryOperation:(NSString *)operator {
    return self.binaryOperations[operator];
}

- (BOOL) isUnaryOperation:(NSString *)operator {
    return self.unaryOperations[operator];
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
    NSString *tmpStringfiedResult =
        [[NGNNumberNotationFactory sharedInstance] encodeNumberToString:newResult
                                                       withNotationType:(CalculatorModelNotations)self.currentNotation];
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
    if ([self.delegate respondsToSelector:@selector(calculatorModel:didChangeResult:)]) {
        [self.delegate calculatorModel:self didChangeResult:self.stringfiedResult];
    }
}

@end
