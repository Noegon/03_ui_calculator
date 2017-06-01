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

#pragma mark - flags
@property (assign, nonatomic, getter=isValueEditingInProgress) BOOL valueEditingInProgress;

#pragma mark - main logic performing methods
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;
- (IBAction)aboutButtonTouched:(UIButton *)sender;
- (IBAction)licenseButtonTouched:(UIBarButtonItem *)sender;
- (IBAction)digitButtonTouched:(UIButton *)sender;
- (IBAction)clearButtonTouched:(UIButton *)sender;
- (IBAction)dotButtonTouched:(UIButton *)sender;
- (IBAction)equalsButtonTouched:(UIButton *)sender;
- (IBAction)operationButtonTouched:(UIButton *)sender;

#pragma mark - helper methods
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled;

#pragma mark - pre-defined colors
- (UIColor *)enabledViewTextColor;
- (UIColor *)disabledViewTextColor;

#pragma mark - orientation change handling methods
//- (void)changeTheViewToPortrait:(BOOL)portrait duration:(NSTimeInterval)duration;
- (void)changeTheViewToPortrait:(BOOL)portrait;

@end

@implementation ViewController

#pragma mark - common methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
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
    [_blockableButtonsArray release];
    [_buttonsStackViews release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SCREEN_HEIGHT < SCREEN_WIDTH) {
        [self changeTheViewToPortrait:NO];
    }
    
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *aboutBarButton = [[UIBarButtonItem alloc] initWithTitle:ViewControllerAboutTitle
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(aboutButtonTouched:)];
    self.navigationItem.leftBarButtonItem = aboutBarButton;
    [aboutBarButton release];
    
    UIBarButtonItem *licenseBarButton = [[UIBarButtonItem alloc] initWithTitle:ViewControllerLicenseTitle
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
        self.digitInsertionField.text = ViewControllerZeroString;
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

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tappedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSString *tmpStringfiedDigit  = [NSString stringWithFormat:@"%@%@", self.digitInsertionField.text, tappedButtonTitle];
    if ([tmpStringfiedDigit containsString:ViewControllerDotString]) {
        self.digitInsertionField.text = tmpStringfiedDigit;
    } else {
        self.digitInsertionField.text = [NSString stringWithFormat:@"%ld", tmpStringfiedDigit.integerValue];
    }
    if (!self.isValueEditingInProgress) {
        self.digitInsertionField.text = tappedButtonTitle;
    }
    self.valueEditingInProgress = YES;
}

- (IBAction)clearButtonTouched:(UIButton *)sender {
    [self.model clear];
    self.digitInsertionField.text = ViewControllerZeroString;
    [self switchCalculationButtonsEnabled:YES];
}

- (IBAction)dotButtonTouched:(UIButton *)sender {
    if (![self.digitInsertionField.text containsString:ViewControllerDotString]) {
        self.digitInsertionField.text = [NSString stringWithFormat:@"%@%@",
                                         self.digitInsertionField.text,
                                         ViewControllerDotString];
    }
}

- (IBAction)equalsButtonTouched:(UIButton *)sender {
    if (self.isValueEditingInProgress) {
        self.valueEditingInProgress = NO;
        self.model.currentOperand = self.digitInsertionField.text.doubleValue;
    }
    [self.model equals]; //waiting operation always calculates, unary operation cannot be waiting operation
}

- (IBAction)operationButtonTouched:(UIButton *)sender {
    if (self.isValueEditingInProgress) {
        self.model.currentOperand = self.digitInsertionField.text.doubleValue;
        self.valueEditingInProgress = NO;
    }
    NSString *operator = [sender titleForState:UIControlStateNormal];
    [self.model calculateWithOperator:operator];
}

#pragma mark - helper methods

// if threre's some exception, this method switches all view elements besides clear and about buttons
// than, if clear button is tapped, all views are in enable mode again
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled {
    for (UIButton *button in self.blockableButtonsArray) {
        [button setTitleColor:[self disabledViewTextColor] forState:UIControlStateDisabled];
        [button setTitleColor:[self enabledViewTextColor] forState:UIControlStateNormal];
    }
    if (!areButtonsEnabled) {
        self.digitInsertionField.userInteractionEnabled = NO;
        [self.blockableButtonsArray setValuesForKeysWithDictionary:@{@"enabled": @NO}];
    } else {
        self.digitInsertionField.userInteractionEnabled = YES;
        [self.blockableButtonsArray setValuesForKeysWithDictionary:@{@"enabled": @YES}];
    }
}

#pragma mark - pre-defined colors

- (UIColor *)enabledViewTextColor {
    return UIColor.blackColor;
}

- (UIColor *)disabledViewTextColor {
    return UIColor.darkGrayColor;
}

#pragma mark - delegate methods

// method changes digit in digit input label when 'displayedResult' variable in model changes
- (void)calculatorModel:(CalculatorModel *)model
        didChangeResult:(NSString *)stringfiedResult {
    self.digitInsertionField.text = stringfiedResult;
    if ([self.digitInsertionField.text containsString:ExceptionUserParamsValuesTagValue]) {
        [self switchCalculationButtonsEnabled:NO];
    }
}

#pragma mark - orientation change handling methods

//Note, that these two methods are in use begining from iOS 6 and latest versions:
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait |
            UIInterfaceOrientationMaskPortraitUpsideDown |
            UIInterfaceOrientationMaskLandscapeLeft |
            UIInterfaceOrientationMaskLandscapeRight);
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
             withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [self changeTheViewToPortrait:YES];
    }
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [self changeTheViewToPortrait:NO];
    }
}

//method changes the view and subview frames for the portrait/landscape view here
- (void)changeTheViewToPortrait:(BOOL)portrait {    
    if(portrait) {
        NSLog(@"%@", @"portrait orientation");
        for (UIStackView *stackView in self.buttonsStackViews) {
            UIButton *tmpButton = stackView.arrangedSubviews.firstObject;
            [stackView removeArrangedSubview:tmpButton];
            [stackView addArrangedSubview:tmpButton];
        }
    } else {
        NSLog(@"%@", @"landscape orientation");
        for (UIStackView *stackView in self.buttonsStackViews) {
            UIButton *tmpButton = stackView.arrangedSubviews.lastObject;
            [stackView removeArrangedSubview:tmpButton];
            [stackView insertArrangedSubview:tmpButton atIndex:0];
        }
    }
}

@end
