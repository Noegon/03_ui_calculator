//
//  ViewController.m
//  Calculator
//
//  Created by user on 13.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import "LicenseViewController.h"
#import "CalculatorModel.h"

//static NSString *const errorTitle = @"error - press clear btn";
static NSString *const dotString = @".";
static NSString *const zeroString = @"0";
static NSInteger const maxAmountOfDigitsInInsertionField = 16;
//static const char *formatForOutput = "";
//static NSString *const formatForOutput = @"%.*g";

@interface ViewController ()

#pragma mark - outlets
@property (retain, nonatomic) IBOutlet UILabel *digitInsertionField;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *digitButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *binaryOperationButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *unaryOperationsButtonsArray;
@property (retain, nonatomic) IBOutlet UIButton *dotButton;
@property (retain, nonatomic) IBOutlet UIButton *equalButton;
@property (retain, nonatomic) IBOutlet UIButton *clearButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutButton;

#pragma mark - main logic performing arguments
@property (retain, nonatomic) CalculatorModel *model;
@property (assign, nonatomic, getter=isNewCalculatingChain) BOOL newCalculatingChain;
@property (assign, nonatomic, getter=isSecondOperandTypingInProgress) BOOL secondOperandTypingInProgress;

#pragma mark - helper arguments
@property (retain, nonatomic, readonly) NSString *formatForOutput;

#pragma mark - main logic performing methods
- (IBAction)digitButtonTouched:(UIButton *)sender;
- (IBAction)clearButtonTouched:(UIButton *)sender;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;
- (IBAction)aboutButtonTouched:(UIButton *)sender;
- (IBAction)licenseButtonTouched:(UIBarButtonItem *)sender;
- (IBAction)dotButtonTouched:(UIButton *)sender;
- (IBAction)equalsButtonTouched:(UIButton *)sender;
- (IBAction)operationButtonTouched:(UIButton *)sender;

#pragma mark - helper methods
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled;

@end

@implementation ViewController

#pragma mark - common methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _secondOperandTypingInProgress = NO;
        _newCalculatingChain = YES;
        _formatForOutput = [[NSString alloc]initWithFormat:@"%%.%ldg", maxAmountOfDigitsInInsertionField];
    }
    return self;
}

- (void)dealloc {
    [_digitInsertionField release];
    [_digitButtonsArray release];
    [_dotButton release];
    [_equalButton release];
    [_clearButton release];
    [_aboutButton release];
    [_binaryOperationButtonsArray release];
    [_model release];
    [_unaryOperationsButtonsArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *aboutBarButton = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(aboutButtonTouched:)];
    self.navigationItem.leftBarButtonItem = aboutBarButton;
    [aboutBarButton release];
    
    UIBarButtonItem *licenseBarButton = [[UIBarButtonItem alloc] initWithTitle:@"License"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(licenseButtonTouched:)];
    self.navigationItem.rightBarButtonItem = licenseBarButton;
    [licenseBarButton release];
}

- (CalculatorModel *)model {
    if (!_model) {
        _model = [[CalculatorModel alloc] init];
    }
    return _model;
}

#pragma mark - main logic performing methods

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tappedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSString *tmpStringfiedDigit = nil;
    if (self.isSecondOperandTypingInProgress || self.isNewCalculatingChain) {
        tmpStringfiedDigit = [NSString stringWithFormat:@"%@%@", self.digitInsertionField.text, tappedButtonTitle];
    } else {
        tmpStringfiedDigit = [NSString stringWithFormat:@"%@", tappedButtonTitle];
        self.secondOperandTypingInProgress = YES;
    }
    if ([self.digitInsertionField.text length] < maxAmountOfDigitsInInsertionField) {
        if ([tmpStringfiedDigit containsString:dotString]) {
            self.digitInsertionField.text = tmpStringfiedDigit;
        } else {
            self.digitInsertionField.text = [NSString stringWithFormat:@"%ld", tmpStringfiedDigit.integerValue];
        }
    }
}

- (IBAction)clearButtonTouched:(UIButton *)sender {
    [self.model clear];
    [self switchCalculationButtonsEnabled:YES];
    self.digitInsertionField.text = zeroString;
    self.secondOperandTypingInProgress = NO;
    self.newCalculatingChain = YES;
}

//deletion by swipe left-to-right
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    NSString *value = self.digitInsertionField.text;
    NSString *result = [value substringToIndex:value.length - 1];
    if (result.length == 0) {
        self.digitInsertionField.text = zeroString;
    } else {
        self.digitInsertionField.text = result;
    }
}

- (IBAction)aboutButtonTouched:(UIButton *)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
}

- (IBAction)licenseButtonTouched:(UIBarButtonItem *)sender {
    LicenseViewController *licenseController = [[LicenseViewController alloc] init];
    [self presentViewController:licenseController animated:YES completion: nil];
    [licenseController release];
}

- (IBAction)dotButtonTouched:(UIButton *)sender {
    if (![self.digitInsertionField.text containsString:dotString]) {
        NSString *tmpStringfiedDigit = [NSString stringWithFormat:@"%@%@", self.digitInsertionField.text, dotString];
        self.digitInsertionField.text = tmpStringfiedDigit;
    }
}

- (IBAction)equalsButtonTouched:(UIButton *)sender {
    @try {
        if (self.isSecondOperandTypingInProgress) {
            self.model.currentOperand = self.digitInsertionField.text.doubleValue;
            [self.model executeOperation];
            self.secondOperandTypingInProgress = NO;
        } else {
            [self.model executeLastOperation];
        }
        self.digitInsertionField.text = [NSString stringWithFormat:self.formatForOutput, self.model.displayedResult];
    } @catch (NSException *exception) {
        if (exception.userInfo[@"errMessage"]) {
            self.digitInsertionField.text = [NSString stringWithFormat:@"%@%@",
                                             exception.userInfo[@"tag"],
                                             exception.userInfo[@"errMessage"]];
            [self switchCalculationButtonsEnabled:NO];
        }
    }
}

- (IBAction)operationButtonTouched:(UIButton *)sender {
    @try {
        NSString *operator = sender.titleLabel.text;
        BOOL isBinaryOperator = [self.binaryOperationButtonsArray containsObject:sender];
        if (self.isNewCalculatingChain) {
            self.model.displayedResult = self.digitInsertionField.text.doubleValue;
            self.model.currentOperator = operator;
            self.newCalculatingChain = NO;
            if (!isBinaryOperator) {
                [self.model executeOperationWithOperator:operator];
                self.digitInsertionField.text = [NSString stringWithFormat:self.formatForOutput, self.model.displayedResult];
                self.secondOperandTypingInProgress = NO;
            }
        } else {
            if ([self.binaryOperationButtonsArray containsObject:sender]) {
                if (self.isSecondOperandTypingInProgress) {
                    self.model.currentOperand = self.digitInsertionField.text.doubleValue;
                    [self.model executeOperation];
                    self.digitInsertionField.text = [NSString stringWithFormat:self.formatForOutput, self.model.displayedResult];
                    self.secondOperandTypingInProgress = NO;
                }
            } else {
                self.model.currentOperand = self.digitInsertionField.text.doubleValue;
                [self.model executeOperationWithOperator:operator];
                self.digitInsertionField.text = [NSString stringWithFormat:self.formatForOutput, self.model.displayedResult];
                self.secondOperandTypingInProgress = NO;
            }
            self.model.currentOperator = operator;
        }
    } @catch (NSException *exception) {
        if (exception.userInfo[@"errMessage"]) {
            self.digitInsertionField.text = [NSString stringWithFormat:@"%@%@",
                                             exception.userInfo[@"tag"],
                                             exception.userInfo[@"errMessage"]];
            [self switchCalculationButtonsEnabled:NO];
        }
    }
}

#pragma mark - helper methods

- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled {
    if (!areButtonsEnabled) {
        for (UIView *view in self.view.subviews) {
            if ((view != self.clearButton) &&
                (view != self.aboutButton)) {
                view.userInteractionEnabled = NO;
            }
        }
    } else {
        for (UIView *view in self.view.subviews) {
            view.userInteractionEnabled = YES;
        }
    }
}

@end
