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

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (NSDictionary *)operations {
    if (!_operations) {
        NSDictionary *tmpDict = @{squareRootSign: @"squareRoot",
                                  percentSign: @"divisionRemainder",
                                  plusSign: @"add",
                                  minusSign: @"subtract",
                                  multiplicationSign: @"multiply",
                                  divisionSign: @"divide",
                                  reverseSign: @"reverseSign"};
        _operations = [[NSDictionary alloc]initWithDictionary:tmpDict];
    }
    return _operations;
}

- (void)dealloc
{
    [_operations release];
    [_currentOperator release];
    [_waitingOperation release];
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
    // Xcode will complain if we access a weak property more than
    // once here, since it could in theory be nilled between accesses
    // leading to unpredictable results. So we'll start by taking
    // a local, strong reference to the delegate.
    id<CalculatorModelDelegate> strongDelegate = self.delegate;
    
    if (self.currentOperand <= DBL_MAX &&
        self.currentOperand >= -DBL_MAX) {
        SEL tmpSelector = NSSelectorFromString(self.operations[operator]);
        if ([self respondsToSelector:tmpSelector]) {
            [self performSelector:tmpSelector];
            self.waitingOperation = self.currentOperator;
            
            // Our delegate method is optional, so we should
            // check that the delegate implements it
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
