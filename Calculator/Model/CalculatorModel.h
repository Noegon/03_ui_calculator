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
        didChangeResult:(NSString *)stringfiedResult;

@end;

@interface CalculatorModel : NSObject

@property (assign, nonatomic) double currentOperand;
@property (assign, nonatomic, readonly) NSString *stringfiedResult;
@property (assign, nonatomic, getter=isNewOperand) BOOL newOperand;
@property (assign, nonatomic, getter=isNewOperatorAdded) BOOL newOperatorAdded;
@property (nonatomic, assign) id<CalculatorModelDelegate> delegate;

- (void)executeOperationWithOperator:(NSString *)operator;
- (void)executeOperation;
- (void)clear;
- (void)equals;

@end
