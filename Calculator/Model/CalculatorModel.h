//
//  CalculatorModel.h
//  Calculator
//
//  Created by Alex on 24.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class CalculatorModel;
//definition of delegate protocol and methods
@protocol CalculatorModelDelegate <NSObject>

@optional
- (void)calculatorModel:(CalculatorModel *)model
        didChangeResult:(NSString *)stringfiedResult;

@end;

@interface CalculatorModel : NSObject

@property (nonatomic, weak) id<CalculatorModelDelegate> delegate;

#pragma mark - model logic methods
- (void)calculateWithOperator:(NSString *)operator;
- (void)clear;
- (void)equals;
- (void)setCurrentOperandWithString:(NSString *)stringfiedOperand;
- (void)setCurrentNotation:(NSInteger)notation;

#pragma mark - adding additional operations
- (void)addBinaryOperationWithOperationSymbol:(NSString *)symbol block:(operation_t)operationBlock;
- (void)addUnaryOperationWithOperationSymbol:(NSString *)symbol block:(operation_t)operationBlock;

@end
