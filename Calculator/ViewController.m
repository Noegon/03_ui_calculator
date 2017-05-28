//
//  ViewController.m
//  Calculator
//
//  Created by user on 13.05.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "AboutViewController.h"
#import "LicenseViewController.h"
#import "CalculatorModel.h"

@interface ViewController () <CalculatorModelDelegate>

#pragma mark - outlets
@property (retain, nonatomic) IBOutlet UILabel *digitInsertionField;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *digitButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *binaryOperationButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *unaryOperationsButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *blockableButtonsArray;
@property (retain, nonatomic) IBOutletCollection(UIStackView) NSArray *buttonsStackViews;
@property (retain, nonatomic) IBOutlet UIButton *dotButton;
@property (retain, nonatomic) IBOutlet UIButton *equalButton;
@property (retain, nonatomic) IBOutlet UIButton *clearButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutButton;

#pragma mark - main logic performing arguments
@property (retain, nonatomic) CalculatorModel *model;
@property (assign, nonatomic, getter=isRenewedCalculatingChain) BOOL renewedCalculatingChain;
@property (assign, nonatomic, getter=isSecondOperandTypingInProgress) BOOL secondOperandTypingInProgress;

#pragma mark - helper arguments
@property (retain, nonatomic, readonly) NSNumberFormatter *outputFormatter;

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
- (void)exceptionHandling:(NSException *)exception;
- (void)renewedCalculationChainHandling;
- (void)binaryOperationHandlingWithOperator:(NSString *)operator;
- (void)unaryOperationHandlingWithOperator:(NSString *)operator;
- (void) changeTheViewToPortrait:(BOOL)portrait duration:(NSTimeInterval)duration;

#pragma mark - pre-defined colors
- (UIColor *)enabledViewTextColor;
- (UIColor *)disabledViewTextColor;

@end

@implementation ViewController

#pragma mark - common methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _secondOperandTypingInProgress = NO;
        _renewedCalculatingChain = YES;
        _outputFormatter = [[NSNumberFormatter alloc]init];
        _outputFormatter.maximumFractionDigits = maximumDisplayedFractionDigits;
        _outputFormatter.minimumIntegerDigits = minimumDisplayedIntegerDigits;
        _model = [[CalculatorModel alloc] init];
        _model.delegate = self;
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
    [_outputFormatter release];
    [_blockableButtonsArray release];
    [_buttonsStackViews release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *aboutBarButton = [[UIBarButtonItem alloc] initWithTitle:aboutTitle
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(aboutButtonTouched:)];
    self.navigationItem.leftBarButtonItem = aboutBarButton;
    [aboutBarButton release];
    
    UIBarButtonItem *licenseBarButton = [[UIBarButtonItem alloc] initWithTitle:licenseTitle
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(licenseButtonTouched:)];
    self.navigationItem.rightBarButtonItem = licenseBarButton;
    [licenseBarButton release];
}

#pragma mark - main logic performing methods

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

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tappedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSString *tmpStringfiedDigit = nil;
    if (self.isSecondOperandTypingInProgress || self.isRenewedCalculatingChain) {
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
    self.digitInsertionField.text = zeroString;
    [self switchCalculationButtonsEnabled:YES];
    self.secondOperandTypingInProgress = NO;
    self.renewedCalculatingChain = YES;
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
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
    }
}

- (IBAction)operationButtonTouched:(UIButton *)sender {
    @try {
        NSString *operator = sender.titleLabel.text;
        BOOL isBinaryOperator = [self.binaryOperationButtonsArray containsObject:sender];
        if (self.isRenewedCalculatingChain) {
            [self renewedCalculationChainHandling];
        }
        if (isBinaryOperator) {
            [self binaryOperationHandlingWithOperator:operator];
        } else {
            [self unaryOperationHandlingWithOperator:operator];
        }
    } @catch (NSException *exception) {
        [self exceptionHandling:exception];
    }
}

#pragma mark - helper methods

// if threre's some exception, this method switches all view elements besides clear and about buttons
// than, if clear button is tapped, all views are in enable mode again
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled {
    for (UIButton *button in self.blockableButtonsArray) {
        [button setTitleColor:UIColor.darkGrayColor forState:UIControlStateDisabled];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    if (!areButtonsEnabled) {
        self.digitInsertionField.userInteractionEnabled = NO;
        [self.blockableButtonsArray setValuesForKeysWithDictionary:@{@"enabled": @NO}];
    } else {
        self.digitInsertionField.userInteractionEnabled = YES;
        [self.blockableButtonsArray setValuesForKeysWithDictionary:@{@"enabled": @YES}];
    }
}

// method to help with handling my arithmetic exceptions
- (void)exceptionHandling:(NSException *)exception {
    if (exception.userInfo[errMessageKey]) {
        self.digitInsertionField.text = [NSString stringWithFormat:@"%@%@",
                                         exception.userInfo[tagKey],
                                         exception.userInfo[errMessageKey]];
        [self switchCalculationButtonsEnabled:NO];
    }
}

// method handling situation when we start calculating from "clear page"
- (void)renewedCalculationChainHandling {
    self.model.displayedResult = self.digitInsertionField.text.doubleValue;
    self.renewedCalculatingChain = NO;
}

// performing logic of binary operation
- (void)binaryOperationHandlingWithOperator:(NSString *)operator {
    if (self.isSecondOperandTypingInProgress) {
        self.model.currentOperand = self.digitInsertionField.text.doubleValue;
        [self.model executeOperation];
        self.secondOperandTypingInProgress = NO;
    }
    self.model.currentOperator = operator;
}

// performing logic of unary operation
- (void)unaryOperationHandlingWithOperator:(NSString *)operator {
    self.model.currentOperator = operator;
    [self.model executeOperationWithOperator:operator];
    self.secondOperandTypingInProgress = NO;
}

#pragma mark - delegate methods

// method changes digit in digit input label when 'displayedResult' variable in model changes
- (void)calculatorModel:(CalculatorModel *)model
        didChangeResult:(double)displayedResult {
    self.digitInsertionField.text =
    [self.outputFormatter stringFromNumber:[NSNumber numberWithDouble:self.model.displayedResult]];
}

#pragma mark - pre-defined colors
- (UIColor *)enabledViewTextColor {
    return UIColor.blackColor;
}

- (UIColor *)disabledViewTextColor {
    return UIColor.grayColor;
}

#pragma mark - orientation change handling methods
//Note, that these methods are in use begining of iOS 6 and latest versions
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait |
            UIInterfaceOrientationMaskLandscapeLeft |
            UIInterfaceOrientationMaskLandscapeRight);
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        [self changeTheViewToPortrait:YES duration:duration];
        
    }
    else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        [self changeTheViewToPortrait:NO duration:duration];
    }
}


- (void)changeTheViewToPortrait:(BOOL)portrait duration:(NSTimeInterval)duration {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    if(portrait) {
        //change the view and subview frames for the portrait view here
        NSLog(@"%@", @"portrait orientation");
        for (UIStackView *stackView in self.buttonsStackViews) {
            UIButton *tmpButton = stackView.arrangedSubviews.firstObject;
            [stackView removeArrangedSubview:tmpButton];
            [stackView addArrangedSubview:tmpButton];
        }
    } else {
        //change the view and subview frames for the landscape view here
        NSLog(@"%@", @"landscape orientation");
        for (UIStackView *stackView in self.buttonsStackViews) {
            UIButton *tmpButton = stackView.arrangedSubviews.lastObject;
            [stackView removeArrangedSubview:tmpButton];
            [stackView insertArrangedSubview:tmpButton atIndex:0];
        }
    }
    
    [UIView commitAnimations];
}
@end
