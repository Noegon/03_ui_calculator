//
//  EngineerCalcViewController.m
//  Calculator
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "EngineerCalcViewController.h"
#import "CalculatorModel.h"
#import "Constants.h"

@interface EngineerCalcViewController ()

@end

@implementation EngineerCalcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.model addUnaryOperationWithOperationSymbol:@"x²"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand *= currentOperand;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"sin"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = sin(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"cos"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = cos(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"tg"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ctg"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = 1 / tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"e"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_E;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"π"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_PI;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ln"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = log(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"log"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = log10(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model setCurrentNotation:DECNotation];
}

@end
