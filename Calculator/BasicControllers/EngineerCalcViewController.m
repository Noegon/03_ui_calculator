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
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand *= currentOperand;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"sin"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = sin(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"cos"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = cos(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"tg"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ctg"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = 1 / tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"e"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_E;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"π"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_PI;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ln"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = log(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"log"
                                           block:^(double result, double currentOperand, Results *results){
                                               currentOperand = log10(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model setCurrentNotation:DECNotation];
}

@end
