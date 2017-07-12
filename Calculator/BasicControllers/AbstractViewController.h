//
//  AbstractViewController.h
//  Calculator
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorModel;

static const double chosenNotationButtonAlpha = 0.6;
static const double unchosenNotationButtonAlpha = 1.0;

@interface AbstractViewController : UIViewController

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
