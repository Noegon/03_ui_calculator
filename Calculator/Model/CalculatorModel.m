//
//  CalculatorModel.m
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "CalculatorModel.h"

@interface CalculatorModel ()

@property (retain, nonatomic) NSDictionary *operations;
@property (assign, nonatomic) double currentOperand;
@property (retain, nonatomic) NSString *waitingOperation;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (NSDictionary *)operations {
    if (!_operations) {
        NSDictionary *tmpDict = @{@"√": @"squareRoot",
                                  @"mod": @"divisionRemainder",
                                  @"+": @"add",
                                  @"-": @"subtract",
                                  @"x": @"multiply",
                                  @"/": @"divide"};
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

- (void)executeLastOperation {
    [self executeOperationWithOperator:self.waitingOperation];
}

- (void)executeOperationWithOperator:(NSString *)operator {
    NSLog(@"%@", self.operations[operator]);
    if (self.currentOperand <= DBL_MAX &&
        self.currentOperand >= -DBL_MAX) {
        SEL tmpSelector = NSSelectorFromString([self.operations valueForKey:operator]);
        if ([self respondsToSelector:tmpSelector]) {
            [self performSelector:tmpSelector];
            self.waitingOperation = self.currentOperator;
        }
    } else {
        @throw [NSException exceptionWithName:@"AmountOverflow"
                                       reason:@"Too big digit"
                                     userInfo:@{@"errMessage": @" - large number!",
                                                @"tag": @"err"}];
    }
}

- (void)squareRoot {
    self.displayedResult = sqrt(self.displayedResult);
}

- (void)divisionRemainder {
    self.displayedResult = (NSInteger)round(self.displayedResult) % (NSInteger)round(self.currentOperand);
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
        @throw [NSException exceptionWithName:@"DivByZero"
                                       reason:@"Division by zero"
                                     userInfo:@{@"errMessage": @" - div by zero!",
                                                @"tag": @"err"}];
    }
}

- (void)clear {
    self.displayedResult = 0;
    self.waitingOperation = nil;
}

@end
