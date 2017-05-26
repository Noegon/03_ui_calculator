//
//  CalculatorModel.h
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalculatorModel;
//definition of delegate protocol and methods
@protocol CalculatorModelDelegate <NSObject>

@optional
- (void)calculatorModel:(CalculatorModel *)model
        didChangeResult:(double)displayedResult;

@end;

@interface CalculatorModel : NSObject

@property (retain, nonatomic) NSString *currentOperator;
@property (assign, nonatomic) double currentOperand;
@property (assign, nonatomic) double displayedResult;
// Delegate properties should always be weak references
// See http://stackoverflow.com/a/4796131/263871 for the rationale
// (Tip: If you're not using ARC, use `assign` instead of `weak`)
@property (nonatomic, assign) id<CalculatorModelDelegate> delegate;

- (void)executeOperationWithOperator:(NSString *)operator;
- (void)executeOperation;
- (void)executeLastOperation;
- (void)clear;

@end
