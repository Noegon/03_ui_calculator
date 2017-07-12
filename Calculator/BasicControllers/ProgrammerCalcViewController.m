//
//  ProgrammerCalcViewController.m
//  Calculator
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "ProgrammerCalcViewController.h"
#import "CalculatorModel.h"
#import "Constants.h"

@interface ProgrammerCalcViewController ()

@end

@implementation ProgrammerCalcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
