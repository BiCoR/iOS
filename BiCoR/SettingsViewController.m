//
//  SettingsViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 01.03.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

/**
 Called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up the Cancel Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    
    //Load the User Data
    
    
}

/**
 Called when a Memory Warning appears
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/**
 Function called, when the cancel Button is clicked
 @param sender: The sender, which calls the event
 */
- (void)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 Function called when the save Button is clicked
 @param sender: The sender, which calls the event
 */
- (IBAction)saveButtonClicked:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 Function called when the user taps inside the table view
 Hides the keyboard
 @param sender: The sender, which calls the event
 */
- (IBAction)tapInsideTableView:(id)sender {
    [self.view endEditing:YES];
}

/**
 Function called when the user clicks the return button on the textfield
 @param textField: The textfield which fires the event
 @return: Yes if action was successfull
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


@end
