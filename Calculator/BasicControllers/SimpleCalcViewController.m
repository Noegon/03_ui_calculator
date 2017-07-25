//
//  ViewController.m
//  Calculator
//
//  Created by user on 13.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "SimpleCalcViewController.h"
#import "Constants.h"
#import "CalculatorModel.h"


@implementation SimpleCalcViewController

#pragma mark - common methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.model setCurrentNotation:DECNotation];
}
@end
