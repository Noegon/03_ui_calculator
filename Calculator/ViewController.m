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

static const double chosenNotationButtonAlpha = 0.6;
static const double unchosenNotationButtonAlpha = 1.0;

@interface ViewController () <CalculatorModelDelegate>

#pragma mark - outlets
  
@property (strong, nonatomic) IBOutlet UILabel *digitInsertionField;
@property (strong, nonatomic) IBOutlet UIButton *dotButton;
@property (strong, nonatomic) IBOutlet UIButton *equalButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIStackView *notationButtonsStackView;
@property (strong, nonatomic) IBOutlet UIStackView *innerVerticalButtonContainerStackView;
@property (strong, nonatomic) IBOutlet UIStackView *outerHorizontalButtonContainerStackView;

#pragma mark - common outlet collections
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *digitButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *binaryOperationButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *unaryOperationsButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *blockableButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIStackView) NSArray *buttonsStackViews;

#pragma mark - notations maintenance outlet collections
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deprecatedForBinaryNotationButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deprecatedForOctalNotationButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deprecatedForDecimalNotationButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deprecatedForHexadecimalNotationButtonsArray;

#pragma mark - notation maintenance properties
@property (strong, nonatomic) NSDictionary *notationButtonsBoundedParameters;
@property (strong, nonatomic) NSString *currentNotationButtonTitle;

#pragma mark - main logic performing properties
@property (strong, nonatomic) CalculatorModel *model;

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
- (IBAction)notationButtonTouched:(UIButton *)sender;

#pragma mark - helper methods
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled
                       excludingButtons:(NSArray *)excludedButonsArray;

#pragma mark - pre-defined colors
- (UIColor *)enabledViewTextColor;
- (UIColor *)disabledViewTextColor;

#pragma mark - orientation change handling methods
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
    
    UIBarButtonItem *licenseBarButton = [[UIBarButtonItem alloc] initWithTitle:ViewControllerLicenseTitle
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(licenseButtonTouched:)];
    self.navigationItem.rightBarButtonItem = licenseBarButton;
    
    [self.model addUnaryOperationWithOperationSymbol:@"x²"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand *= currentOperand;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"sin"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = sin(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"cos"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = cos(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"tg"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ctg"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = 1 / tan(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"e"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_E;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"π"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = M_PI;
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"ln"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = log(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    [self.model addUnaryOperationWithOperationSymbol:@"log"
                                           WithBlock:^(double result, double currentOperand, Results *results){
                                               currentOperand = log10(currentOperand);
                                               results->currentOperand = currentOperand;
                                           }];
    
    for (UIButton *button in self.blockableButtonsArray) {
        [button setTitleColor:[self disabledViewTextColor] forState:UIControlStateDisabled];
        [button setTitleColor:[self enabledViewTextColor] forState:UIControlStateNormal];
    }
    
    self.notationButtonsBoundedParameters = @{CalculatorModelBinaryNotationOperation:
                                                  @{ViewControllerNotationButtonsBoundedParametersNotationTypeKey:
                                                        @(BINNotation),
                                                    ViewControllerNotationButtonsBoundedParametersDisabledButtonsKey:
                                                        self.deprecatedForBinaryNotationButtonsArray,
                                                    ViewControllerNotationButtonsBoundedParametersButtonKey:
                                                        [self.notationButtonsStackView viewWithTag:BINNotation]},
                                              
                                              CalculatorModelOctalNotationOperation:
                                                  @{ViewControllerNotationButtonsBoundedParametersNotationTypeKey:
                                                        @(OCTNotation),
                                                    ViewControllerNotationButtonsBoundedParametersDisabledButtonsKey:
                                                        self.deprecatedForOctalNotationButtonsArray,
                                                    ViewControllerNotationButtonsBoundedParametersButtonKey:
                                                        [self.notationButtonsStackView viewWithTag:OCTNotation]},
                                              
                                              CalculatorModelDecimalNotationOperation:
                                                  @{ViewControllerNotationButtonsBoundedParametersNotationTypeKey:
                                                        @(DECNotation),
                                                    ViewControllerNotationButtonsBoundedParametersDisabledButtonsKey:
                                                        self.deprecatedForDecimalNotationButtonsArray,
                                                    ViewControllerNotationButtonsBoundedParametersButtonKey:
                                                        [self.notationButtonsStackView viewWithTag:DECNotation]},
                                              
                                              CalculatorModelHexadecimalNotationOperation:
                                                  @{ViewControllerNotationButtonsBoundedParametersNotationTypeKey:
                                                        @(HEXNotation),
                                                    ViewControllerNotationButtonsBoundedParametersDisabledButtonsKey:
                                                        self.deprecatedForHexadecimalNotationButtonsArray,
                                                    ViewControllerNotationButtonsBoundedParametersButtonKey:
                                                        [self.notationButtonsStackView viewWithTag:HEXNotation]}
                                              };
    
    [self notationButtonTouched: self.notationButtonsBoundedParameters[CalculatorModelDecimalNotationOperation][@"button"]];
    [self.model clear];
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
}

- (IBAction)licenseButtonTouched:(UIBarButtonItem *)sender {
    LicenseViewController *licenseController = [[LicenseViewController alloc] init];
    [self presentViewController:licenseController animated:YES completion: nil];
}

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tappedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSMutableString *tmpStringfiedDigit = [NSMutableString stringWithFormat:@"%@%@",
                                           self.digitInsertionField.text,
                                           tappedButtonTitle];
    if (![tmpStringfiedDigit containsString:ViewControllerDotString]) {
        if ([self.digitInsertionField.text characterAtIndex:0] == '0') {
            tmpStringfiedDigit = (NSMutableString *)[tmpStringfiedDigit substringFromIndex:1];
        }
    }
    self.digitInsertionField.text = tmpStringfiedDigit;
    
    if (!self.isValueEditingInProgress) {
        self.digitInsertionField.text = tappedButtonTitle;
    }
    self.valueEditingInProgress = YES;
}

- (IBAction)clearButtonTouched:(UIButton *)sender {
    [self.model clear];
    self.digitInsertionField.text = ViewControllerZeroString;
    [self switchCalculationButtonsEnabled:YES
                         excludingButtons:self.notationButtonsBoundedParameters
                            [self.currentNotationButtonTitle][@"disabledButtons"]];
}

- (IBAction)dotButtonTouched:(UIButton *)sender {
    if (![self.digitInsertionField.text containsString:ViewControllerDotString]) {
        self.digitInsertionField.text = [NSString stringWithFormat:@"%@%@",
                                         self.digitInsertionField.text,
                                         ViewControllerDotString];
    }
    self.valueEditingInProgress = YES;
}

- (IBAction)equalsButtonTouched:(UIButton *)sender {
    if (self.isValueEditingInProgress) {
        self.valueEditingInProgress = NO;
        [self.model setCurrentOperandWithString:self.digitInsertionField.text];
    }
    [self.model equals]; //waiting operation always calculates, unary operation cannot be waiting operation
}

- (IBAction)operationButtonTouched:(UIButton *)sender {
    if (self.isValueEditingInProgress) {
        [self.model setCurrentOperandWithString:self.digitInsertionField.text];
        self.valueEditingInProgress = NO;
    }
    NSString *operator = [sender titleForState:UIControlStateNormal];
    [self.model calculateWithOperator:operator];
}

- (IBAction)notationButtonTouched:(UIButton *)sender {
    NSString *tappedButtonTitle = [sender titleForState:UIControlStateNormal];
    [[self.notationButtonsStackView arrangedSubviews]setValuesForKeysWithDictionary:
        @{@"alpha": @(unchosenNotationButtonAlpha)}];
    sender.alpha = chosenNotationButtonAlpha;
    [self switchCalculationButtonsEnabled:NO
                         excludingButtons:nil];
    [self switchCalculationButtonsEnabled:YES
                         excludingButtons:self.notationButtonsBoundedParameters[tappedButtonTitle][@"disabledButtons"]];
    self.currentNotationButtonTitle = tappedButtonTitle;
    [self operationButtonTouched:sender];
    self.valueEditingInProgress = YES;
}

#pragma mark - helper methods

// if threre's some exception, this method switches all view elements besides clear and about buttons
// than, if clear button is tapped, all views (depends of chosen notation) are in enable mode again
- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled
                       excludingButtons:(NSArray *)excludedButonsArray {
    if (!areButtonsEnabled) {
        self.digitInsertionField.userInteractionEnabled = NO;
        [self.blockableButtonsArray setValuesForKeysWithDictionary:@{@"enabled": @NO}];
    } else {
        self.digitInsertionField.userInteractionEnabled = YES;
        NSArray *buttonsToEnable = [self filterButtons:self.blockableButtonsArray
                                  withButtonsToExclude:excludedButonsArray];
        
        [buttonsToEnable setValuesForKeysWithDictionary:@{@"enabled": @YES}];
    }
}

// method filters blockable buttons to find what kind of buttons could be enabled
// considering chosen notation type
- (NSArray *)filterButtons:(NSArray *)objects
      withButtonsToExclude:(NSArray *)buttonsToExclude {
    return [objects filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"!SELF IN %@", buttonsToExclude]];
}

#pragma mark - pre-defined colors

- (UIColor *)enabledViewTextColor {
    return [UIColor blackColor];
}

- (UIColor *)disabledViewTextColor {
    return [UIColor darkGrayColor];
}

#pragma mark - delegate methods

// method changes digit in digit input label when 'displayedResult' variable in model changes
- (void)calculatorModel:(CalculatorModel *)model
        didChangeResult:(NSString *)stringfiedResult {
    self.digitInsertionField.text = stringfiedResult;
    if ([self.digitInsertionField.text containsString:ExceptionUserParamsValuesTagValue]) {
        [self switchCalculationButtonsEnabled:NO
                             excludingButtons:nil];
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
        [self.outerHorizontalButtonContainerStackView removeArrangedSubview:self.notationButtonsStackView];
        [self.innerVerticalButtonContainerStackView insertArrangedSubview:self.notationButtonsStackView
                                                                  atIndex:0];
        self.notationButtonsStackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        NSLog(@"%@", @"landscape orientation");
        [self.innerVerticalButtonContainerStackView removeArrangedSubview:self.notationButtonsStackView];
        [self.outerHorizontalButtonContainerStackView addArrangedSubview:self.notationButtonsStackView];
        self.notationButtonsStackView.axis = UILayoutConstraintAxisVertical;
    }
}

@end
