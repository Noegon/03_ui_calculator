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

static NSString *const errorTitle = @"error - press clear btn";
static NSString *const dotString = @".";
static NSString *const zeroString = @"0";
static NSInteger const maxAmountOfDigitsInInsertionField = 18;

@interface ViewController ()

@property (retain, nonatomic) IBOutlet UILabel *digitInsertionField;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *digitButtonsArray;
@property (retain, nonatomic) IBOutlet UIButton *dotButton;
@property (retain, nonatomic) IBOutlet UIButton *equalButton;
@property (retain, nonatomic) IBOutlet UIButton *clearButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutButton;

- (IBAction)digitButtonTouched:(UIButton *)sender;
- (IBAction)clearButtonTouched:(UIButton *)sender;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;
- (IBAction)aboutButtonTouched:(UIButton *)sender;
- (IBAction)licenseButtonTouched:(UIBarButtonItem *)sender;
- (IBAction)dotButtonTouched:(UIButton *)sender;

- (void)switchCalculationButtonsEnabled:(BOOL)areButtonsEnabled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    //Create temporary var (ret count == 1)
    UIBarButtonItem *aboutBarButton = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(aboutButtonTouched:)];
    //Assign value of temp var to leftBarButton (ret count == 2)
    self.navigationItem.leftBarButtonItem = aboutBarButton;
    /*
    Release aboutButton once (ret count == 1 i.e. var retaining only by
    self.navigationItem.leftBarButtonItem, that will be released in [super dealoc] because it is a property of
    UIViewController - superclass of current class. Isn't it? Or I did some mistakes in my reasonings?
     */
    [aboutBarButton release];
    NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) aboutBarButton)); //refcount == 1
    
    
    UIBarButtonItem *licenseBarButton = [[UIBarButtonItem alloc] initWithTitle:@"License"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(licenseButtonTouched:)];
    self.navigationItem.rightBarButtonItem = licenseBarButton;
    [licenseBarButton release];
    NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) licenseBarButton));
}

- (IBAction)digitButtonTouched:(UIButton *)sender {
    NSString *tapedButtonTitle = [sender titleForState:UIControlStateNormal];
    NSString *tmpStringfiedDigit = [NSString stringWithFormat:@"%@%@", self.digitInsertionField.text, tapedButtonTitle];
    if (![self.digitInsertionField.text isEqualToString:errorTitle]) {
        if ((self.digitInsertionField.text.doubleValue < CGFLOAT_MAX) &&
            [self.digitInsertionField.text length] < maxAmountOfDigitsInInsertionField) {
            if ([tmpStringfiedDigit containsString:dotString]) {
                self.digitInsertionField.text = tmpStringfiedDigit;
            } else {
                self.digitInsertionField.text = [NSString stringWithFormat:@"%ld", tmpStringfiedDigit.integerValue];
            }
        } else {
            self.digitInsertionField.text = errorTitle;
            [self switchCalculationButtonsEnabled:NO];
        }
    }
}

- (IBAction)clearButtonTouched:(UIButton *)sender {
    if ([self.digitInsertionField.text isEqualToString:errorTitle]) {
        [self switchCalculationButtonsEnabled:YES];
    }
    self.digitInsertionField.text = zeroString;
}

//deletion by swipe left-to-right
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    NSString *value = self.digitInsertionField.text;
    NSString *result = [value substringToIndex:value.length - 1];
    if (![self.digitInsertionField.text isEqualToString:errorTitle]) {
        if (result.length == 0) {
            self.digitInsertionField.text = zeroString;
        } else {
            self.digitInsertionField.text = result;
        }
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

- (void)dealloc {
    [_digitInsertionField release];
    [_digitButtonsArray release];
    [_dotButton release];
    [_equalButton release];
    [_clearButton release];
    [_aboutButton release];
    [super dealloc];
}
@end
