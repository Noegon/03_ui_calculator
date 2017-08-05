//
//  NGNMenuViewController.m
//  Calculator
//
//  Created by Alex on 18.07.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NGNMenuViewController.h"
#import "NGNNavigationController.h"
#import "SimpleCalcViewController.h"
#import "EngineerCalcViewController.h"
#import "ProgrammerCalcViewController.h"
#import "Constants.h"

@interface NGNMenuViewController ()

@end

@implementation NGNMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 75.0f)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25.0f, 0, 50.0f)];
        label.text = @"MAIN MENU";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:label];
        view;
    });
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NGNNavigationController *navigationController =
        [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierContentController];
    
    if (indexPath.row == 0) {
        SimpleCalcViewController *simpleViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierSimpleCalcController];
        navigationController.viewControllers = @[simpleViewController];
    } else if (indexPath.row == 1) {
        EngineerCalcViewController *engineerViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierEngineerCalcController];
        navigationController.viewControllers = @[engineerViewController];
    } else {
        ProgrammerCalcViewController *programmerViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:ControllerIdentifierProgrammerCalcController];
        navigationController.viewControllers = @[programmerViewController];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

@end
