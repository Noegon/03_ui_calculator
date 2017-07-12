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

@interface CalculatorModel ()

#pragma mark - model logic properties
@property (assign, nonatomic) __block double currentOperand;
@property (assign, nonatomic) __block double result;
@property (strong, nonatomic) NSMutableDictionary *operations; //contains both of unary and binary operations
@property (strong, nonatomic) NSMutableDictionary *binaryOperations;
@property (strong, nonatomic) NSMutableDictionary *unaryOperations;
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
- (void)fillResults:(Results *)results WithResult:(double)result CurrentOperand:(double)currentOperand;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (instancetype)init {
    if (self = [super init]) {
        _result = NAN;
        _renewedCalculationChain = YES;
        _secondOperandAdded = NO;

        __weak CalculatorModel *weakSelf = self;
        
        _unaryOperations = [@{CalculatorModelSquareRootSignOperation: ^(double result, double currentOperand, Results *results){
                                 if (weakSelf.currentOperand >= 0) {
                                     currentOperand = sqrt(currentOperand);
                                     [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                                 } else {
                                     [weakSelf fillResults:results WithResult:0 CurrentOperand:0];
                                     @throw Constants.calculatorModelSquareRootFromNegativeException;
                                 }
                             },
                             CalculatorModelReverseSignOperation: ^(double result, double currentOperand, Results *results){
                                 currentOperand *= -1;
                                 [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                             },
                             CalculatorModelBinaryNotationOperation: ^(double result, double currentOperand, Results *results){
                                 weakSelf.currentNotation = BINNotation;
                                 [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                             },
                             CalculatorModelOctalNotationOperation: ^(double result, double currentOperand, Results *results){
                                 weakSelf.currentNotation = OCTNotation;
                                 [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                             },
                             CalculatorModelDecimalNotationOperation: ^(double result, double currentOperand, Results *results){
                                 weakSelf.currentNotation = DECNotation;
                                 [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                             },
                             CalculatorModelHexadecimalNotationOperation: ^(double result, double currentOperand, Results *results){
                                 weakSelf.currentNotation = DECNotation;
                                 [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                             }} mutableCopy];
        
        _binaryOperations = [@{CalculatorModelDivisonRemainderOperation: ^(double result, double currentOperand, Results *results){
                                  if (currentOperand != 0) {
                                      result = (NSInteger)result % (NSInteger)currentOperand;
                                      [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                                  } else {
                                      [weakSelf fillResults:results WithResult:0 CurrentOperand:0];
                                      @throw Constants.calculatorModelDivisionByZeroException;
                                  }
                              },
                              CalculatorModelPlusSignOperation: ^(double result, double currentOperand, Results *results){
                                  result += currentOperand;
                                  [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                              },
                              CalculatorModelMinusSignOperation: ^(double result, double currentOperand, Results *results){
                                  result -= currentOperand;
                                  [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                              },
                              CalculatorModelMultiplicationSignOperation: ^(double result, double currentOperand, Results *results){
                                  result *= currentOperand;
                                  [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                              },
                              CalculatorModelDivisionSignOperation: ^(double result, double currentOperand, Results *results){
                                  if (currentOperand != 0) {
                                      result /= currentOperand;
                                      [weakSelf fillResults:results WithResult:result CurrentOperand:currentOperand];
                                  } else {
                                      [weakSelf fillResults:results WithResult:0 CurrentOperand:0];
                                      @throw Constants.calculatorModelDivisionByZeroException;
                                  }
                              }} mutableCopy];
    
        _operations = [[NSMutableDictionary alloc] initWithDictionary:_unaryOperations];
        [_operations addEntriesFromDictionary:_binaryOperations];
    }
    return self;
}


#pragma mark - model logic methods

// template for operations executing
- (void)executeOperationWithOperator:(NSString *)operator {
    operation_t operation = self.operations[operator];
    __block Results *results = malloc(sizeof(Results));
    results->currentOperand = NAN;
    results->result = NAN;
    operation(self.result, self.currentOperand, results);
    self.result = (!isnan(results->result)) ? results->result : self.result;
    [self setCurrentOperandWithoutSideEffects:(!isnan(results->currentOperand) ? results->currentOperand : self.currentOperand)];
    free(results);
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

#pragma mark - adding additional operations

- (NSDictionary *)addOperationWithOperationSymbol:(NSString *)symbol WithBlock:(operation_t)operationBlock {
    operationBlock = [operationBlock copy];
    NSDictionary *resultPair = @{symbol: operationBlock};
    [self.operations addEntriesFromDictionary:resultPair];
    return @{symbol: operationBlock};
}

- (void)addBinaryOperationWithOperationSymbol:(NSString *)symbol WithBlock:(operation_t)operationBlock {
    [self.binaryOperations addEntriesFromDictionary:[self addOperationWithOperationSymbol:symbol WithBlock:operationBlock]];
}

- (void)addUnaryOperationWithOperationSymbol:(NSString *)symbol WithBlock:(operation_t)operationBlock {
    [self.unaryOperations addEntriesFromDictionary:[self addOperationWithOperationSymbol:symbol WithBlock:operationBlock]];
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

- (void)fillResults:(Results *)results WithResult:(double)result CurrentOperand:(double)currentOperand {
    results->result = result;
    results->currentOperand = currentOperand;
}

@end
