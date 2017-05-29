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

@property (retain, nonatomic) NSDictionary *operations;
@property (retain, nonatomic) NSString *waitingOperation;
@property (assign, nonatomic) NSMutableString *stringfiedResult;

#pragma mark - helper arguments
@property (retain, nonatomic) NSNumberFormatter *outputFormatter;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (NSDictionary *)operations {
    if (!_operations) {
        _operations = [[NSDictionary alloc]initWithDictionary:@{squareRootSign: @"squareRoot",
                                                                percentSign: @"divisionRemainder",
                                                                plusSign: @"add",
                                                                minusSign: @"subtract",
                                                                multiplicationSign: @"multiply",
                                                                divisionSign: @"divide",
                                                                reverseSign: @"reverseSign"}];
    }
    return _operations;
}

- (NSNumberFormatter *)outputFormatter {
    if (!_outputFormatter) {
        _outputFormatter = [[NSNumberFormatter alloc]init];
        _outputFormatter.maximumFractionDigits = maximumDisplayedFractionDigits;
        _outputFormatter.minimumIntegerDigits = minimumDisplayedIntegerDigits;
    }
    return _outputFormatter;
}

- (void)dealloc
{
    [_operations release];
    [_currentOperator release];
    [_waitingOperation release];
    [_outputFormatter release];
    [super dealloc];
}

#pragma mark - model logic methods

- (void)executeOperation {
    [self executeOperationWithOperator:self.currentOperator];
}

- (void)executeLastOperation {
    [self executeOperationWithOperator:self.waitingOperation];
}

- (void)executeOperationWithOperator:(NSString *)operator {
    id<CalculatorModelDelegate> strongDelegate = self.delegate;
    
    if (self.currentOperand <= DBL_MAX &&
        self.currentOperand >= -DBL_MAX) {
        SEL tmpSelector = NSSelectorFromString(self.operations[operator]);
        if ([self respondsToSelector:tmpSelector]) {
            [self performSelector:tmpSelector];
            self.waitingOperation = self.currentOperator;
            self.stringfiedResult = [NSMutableString stringWithString:
                                     [self.outputFormatter stringFromNumber:
                                                                       [NSNumber numberWithDouble:self.displayedResult]]];
            
            if ([strongDelegate respondsToSelector:@selector(calculatorModel:didChangeResult:)]) {
                [strongDelegate calculatorModel:self didChangeResult:self.displayedResult];
            }
        }
    } else {
        @throw Constants.amountOverflowException;
    }
}

- (void)squareRoot {
    if (self.displayedResult >= 0) {
        self.displayedResult = sqrt(self.displayedResult);
    } else {
        @throw Constants.squareRootFromNegativeException;
    }
}

- (void)reverseSign {
    self.displayedResult = -1 * self.displayedResult;
}

- (void)divisionRemainder {
    if (self.currentOperand != 0) {
        self.displayedResult = (NSInteger)round(self.displayedResult) % (NSInteger)round(self.currentOperand);
    } else {
        @throw Constants.divisionByZeroException;
    }
}

- (void)add {
    self.displayedResult += self.currentOperand;
}

- (void)subtract {
    self.displayedResult -= self.currentOperand;
}

- (void)multiply {
    self.displayedResult *= self.currentOperand;
}

- (void)divide {
    if (self.currentOperand != 0) {
        self.displayedResult /= self.currentOperand;
    } else {
        @throw Constants.divisionByZeroException;
    }
}

- (void)clear {
    self.displayedResult = 0;
    self.waitingOperation = nil;
}

@end
