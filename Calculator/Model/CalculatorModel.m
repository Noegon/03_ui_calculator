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

@property (retain, nonatomic) NSMutableDictionary *operations;
@property (retain, nonatomic) NSDictionary *binaryOperations;
@property (retain, nonatomic) NSDictionary *unaryOperations;
@property (retain, nonatomic) NSString *waitingOperation;
@property (assign, nonatomic) NSMutableString *stringfiedResult;
@property (assign, nonatomic, getter=isNewOperand) BOOL newOperand;
@property (assign, nonatomic, getter=isNewOperandInTypingProgress) BOOL newOperandInTypingProgress;

#pragma mark - helper arguments
@property (retain, nonatomic) NSNumberFormatter *outputFormatter;

#pragma mark - helper methods
- (BOOL) isBinaryOperation:(NSString *)operator;
- (BOOL) isUnaryOperation:(NSString *)operator;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (instancetype)init {
    if (self = [super init]) {
        _result = NAN;
        _newOperand = YES;
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
// executing last operation
- (void)executeOperation {
    SEL tmpSelector = NSSelectorFromString([self.operations valueForKey:self.waitingOperation]);
    if ([self respondsToSelector:tmpSelector]) {
        [self performSelector:tmpSelector];
    }
    self.newOperandInTypingProgress = NO;
    id<CalculatorModelDelegate> strongDelegate = self.delegate;
    self.stringfiedResult = [NSMutableString stringWithString:
                             [self.outputFormatter stringFromNumber:
                              [NSNumber numberWithDouble:self.result]]];
    
    if ([strongDelegate respondsToSelector:@selector(calculatorModel:didChangeResult:)]) {
        [strongDelegate calculatorModel:self didChangeResult:self.stringfiedResult];
    }
}

//executing inserted operation
- (void)executeOperationWithOperator:(NSString *)operator {
    
    if (self.currentOperand <= DBL_MAX &&
        self.currentOperand >= -DBL_MAX) {
    
        if (isnan(self.result)) {
            self.result = self.currentOperand;
        }
        
        if (self.isNewOperandInTypingProgress) {
            [self executeOperation];
        }

        if (self.isNewOperand && [self isBinaryOperation:operator]) {
            [self executeOperation];
        }
        
        self.waitingOperation = operator;
        
        if ([self isUnaryOperation:operator]) {
            [self executeOperation];
            if ([operator isEqualToString:reverseSign]) {
                self.newOperandInTypingProgress = YES;
            }
        }
    } else {
        @throw Constants.amountOverflowException;
    }
}

- (void)clear {
    self.result = NAN;
    self.waitingOperation = nil;
}

- (void)equals {
    self.newOperand = YES;
    [self executeOperation];
}

- (BOOL) isBinaryOperation:(NSString *)operator {
    return [[self.binaryOperations allKeys]containsObject:operator];
}

- (BOOL) isUnaryOperation:(NSString *)operator {
    return [[self.unaryOperations allKeys]containsObject:operator];
}

- (void)setCurrentOperand:(double)currentOperand {
    if (isnan(self.result)) {
        self.newOperand = YES;
    }
    _currentOperand = currentOperand;
}

#pragma mark - mathematic operations
- (void)squareRoot {
    if (self.result >= 0) {
        self.result = sqrt(self.result);
    } else {
        @throw Constants.squareRootFromNegativeException;
    }
}

- (void)reverseSign {
    self.result = -1 * self.result;
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
