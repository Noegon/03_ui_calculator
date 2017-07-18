//
//  NGNNavigationController.m
//  Calculator
//
//  Created by Alex on 18.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNNavigationController.h"

@interface NGNNavigationController ()

@end

@implementation NGNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(panGestureRecognized:)]];
}

#pragma mark - Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
