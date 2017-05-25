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
@property (retain, nonatomic) NSString *waitingOperation;

@end

@implementation CalculatorModel

#pragma mark - basic methods

- (NSDictionary *)operations {
    if (!_operations) {
        NSDictionary *tmpDict = @{@"√": @"squareRoot",
                                  @"%": @"divisionRemainder",
                                  @"+": @"add",
                                  @"-": @"subtract",
                                  @"x": @"multiply",
                                  @"/": @"divide",
                                  @"+/-": @"reverseSign"};
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
    NSLog(@"%@", self.operations[operator]);
    if (self.currentOperand <= DBL_MAX &&
        self.currentOperand >= -DBL_MAX) {
        SEL tmpSelector = NSSelectorFromString(self.operations[operator]);
        if ([self respondsToSelector:tmpSelector]) {
            [self performSelector:tmpSelector];
            self.waitingOperation = self.currentOperator;
        }
    } else {
        @throw [NSException exceptionWithName:@"Amount overflow"
                                       reason:@"Too big digit"
                                     userInfo:@{@"errMessage": @" - large number!",
                                                @"tag": @"err"}];
    }
}

- (void)squareRoot {
    if (self.displayedResult >= 0) {
        self.displayedResult = sqrt(self.displayedResult);
    } else {
        @throw [NSException exceptionWithName:@"Square root from negative"
                                       reason:@"Sqare root from negative"
                                     userInfo:@{@"errMessage": @" - sq root from neg!",
                                                @"tag": @"err"}];
    }
}

- (void)reverseSign {
    self.displayedResult = -1 * self.displayedResult;
}

- (void)divisionRemainder {
    if (self.currentOperand != 0) {
        self.displayedResult = (NSInteger)round(self.displayedResult) % (NSInteger)round(self.currentOperand);
    } else {
        @throw [NSException exceptionWithName:@"Division by zero"
                                       reason:@"Division by zero"
                                     userInfo:@{@"errMessage": @" - div by zero!",
                                                @"tag": @"err"}];
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
        @throw [NSException exceptionWithName:@"Division by zero"
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
