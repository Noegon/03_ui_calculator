//
//  CalculatorModel.h
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

@property (retain, nonatomic) NSString *currentOperator;
@property (assign, nonatomic) double currentOperand;
@property (assign, nonatomic) double displayedResult;

- (void)executeOperationWithOperator:(NSString *)operator;
- (void)executeOperation;
- (void)executeLastOperation;
- (void)clear;

@end
