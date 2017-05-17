//
//  ViewController.m
//  Calculator
//
//  Created by user on 13.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // we should to create an instance of UIGestureRecognizer to use it
    // (if we didn't do it in interface builder)
    // And, ofcourse, we should to release it in dealloc method if we don't use ARC
//    UIGestureRecognizer *swipeRec = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRecognizer:)];
//    [[self nameTextField] addGestureRecognizer:swipeRec];
}

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tapedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSString *tmpString = [NSString stringWithFormat:@"%@%@", self.digitInsertionField.text, tapedButtonTitle];
    if ([tmpString containsString:@"."]) {
        self.digitInsertionField.text = tmpString;
    } else {
        self.digitInsertionField.text = [NSString stringWithFormat:@"%ld", tmpString.integerValue];
    }
}

- (IBAction)clearButtonTouched:(UIButton *)sender {
    self.digitInsertionField.text = @"0";
}

//deletion by swipe left-to-right
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    NSString *value = self.digitInsertionField.text;
    NSString *result = [value substringToIndex:value.length - 1];
    if (result.length == 0) {
        self.digitInsertionField.text = @"0";
    } else {
        self.digitInsertionField.text = result;
    }
}

- (void)dealloc {
    [_digitInsertionField release];
    [super dealloc];
}
@end
