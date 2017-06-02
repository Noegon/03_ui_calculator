//
//  LicenseViewController.m
//  Calculator
//
//  Created by user on 16.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "LicenseViewController.h"

@interface LicenseViewController ()

- (IBAction)closeButtonTouched:(UIButton *)sender;

@end

@implementation LicenseViewController

- (IBAction)closeButtonTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
