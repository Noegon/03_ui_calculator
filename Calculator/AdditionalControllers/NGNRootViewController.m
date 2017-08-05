//
//  DEMOViewController.m
//  Calculator
//
//  Created by Alex on 18.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNRootViewController.h"
#import "Constants.h"

@interface NGNRootViewController ()

@end

@implementation NGNRootViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierContentController];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierMenuController];
}

@end
