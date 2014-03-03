//
//  SettingsViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 01.03.14.
//  Released under the GNU General Public License v2
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "ServerConnectionInformation.h"

//Constants
extern NSString *const SETTINGS_USERNAME_KEY;
extern NSString *const SETTINGS_PASSWORD_KEY;
extern NSString *const SETTINGS_URL_KEY;

@interface SettingsViewController : UITableViewController <UITextFieldDelegate, ServerConnectionInformation>

//Properties
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *serverURLLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property UILabel *statusLabel;

@property (copy) NSString *oldUserName;
@property (copy) NSString *oldPassword;
@property (copy) NSString *oldURL;


//Functions
/**
 Function called, when the cancel Button is clicked
 @param sender: The sender, which calls the event
 */
- (void) cancelButtonClicked: (id) sender;

/**
 Functions to inform the user, that the programm currently load data
 @param loadingData: Indicator the define, if the program will load data
 */
- (void) setStatusForLoadingData: (bool) loadingData;

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
