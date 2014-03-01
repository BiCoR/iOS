//
//  SettingsViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 01.03.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController <UITextFieldDelegate>

//Properties
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *serverURLLabel;


//Functions
/**
 Function called, when the cancel Button is clicked
 @param sender: The sender, which calls the event
 */
- (void) cancelButtonClicked: (id) sender;

/**
 Function called when the save Button is clicked
 @param sender: The sender, which calls the event
 */
- (IBAction)saveButtonClicked:(id)sender;

/**
 Function called when the user taps inside the table view
 @param sender: The sender, which calls the event
 */
- (IBAction)tapInsideTableView:(id)sender;

@end
