//
//  ViewController.h
//  Calculator
//
//  Created by user on 13.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *digitInsertionField;

- (IBAction)digitButtonTouched:(UIButton *)sender;
- (IBAction)clearButtonTouched:(UIButton *)sender;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;

@end

