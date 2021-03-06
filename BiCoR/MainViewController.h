//
//  MainViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Released under the GNU General Public License v2
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "Contact.h"
#import "PersonDetailsViewController.h"
#import "WebViewController.h"
#import "NSMutableArray+PersonManager.h"
#import "SettingsViewController.h"

@interface MainViewController : UITableViewController <UIAlertViewDelegate, ServerConnectionInformation>

//Properties
@property NSMutableArray *model;
@property UILabel *statusLabel;
@property bool statusLoadingData;
@property NSInteger switchID;
@property NSInteger firstWarningTime;
@property NSInteger secondWarningTime;

//Functions

/**
 Function to fill the table view the first time
 */
- (void) loadDataFirstTime;

/**
 Functions to inform the user, that the programm currently load data
 @param loadingData: Indicator the define, if the program will load data
 */
- (void) setStatusForLoadingData: (bool) loadingData;


/**
 Function which is called, when the user scrolls up to refresh the data
 @param sender: The sender of the event
 */
- (void)refreshView:(id)sender;

/**
 Function called when the add user button is clicked
 @param sender: The sender of the event
 */
- (void)addUserButtonClicked:(id)sender;

/**
 Function called when the settings button is clicked
 @param sender: The sender of the event
 */
- (void)settingsButtonClicked:(id)sender;

/**
 Function to show the details view of one user
 @param userID: the user id as integer value
 */
- (void)showDetailsViewForUserWithId: (NSNumber *) userID;


@end
