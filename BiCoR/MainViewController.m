//
//  MainViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "MainViewController.h"

//CONSTANTS
NSString * const SETTINGS_USERNAME_KEY = @"USERNAME";
NSString * const SETTINGS_PASSWORD_KEY = @"PASSWORD";

@implementation MainViewController

/**
 Called when the nib file is loaded
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    _model = [[NSMutableArray alloc] init];
    
    //Fill the toolbar
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 23)];
//    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.backgroundColor = [UIColor clearColor];

    _statusLabel.text = @"Put in text here";
    [_statusLabel sizeToFit];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:_statusLabel];
    
    [self setToolbarItems:[NSArray arrayWithObjects:toolBarTitle, nil] animated:NO];
    
    //TODO: Handle the Text Label
}

/**
 Callend when view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get username and password
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefaults stringForKey:SETTINGS_USERNAME_KEY];
    NSString *password = [userDefaults stringForKey:SETTINGS_PASSWORD_KEY];
    
    //Check if userName / Password allready exists
    if ((userName == nil) || (password == nil)) {
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TITLE", @"title for login credentials") message:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TEXT", @"text for login credentials") delegate:self cancelButtonTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_OK", @"ok button") otherButtonTitles:nil, nil];
        dataAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [dataAlert show];
    }
    //If allready exists start loading data
    else
    {
        [self loadDataFirstTime];
    }
}


/**
 Function to fill the table view the first time
 */
- (void)loadDataFirstTime
{
    //_statusText.title = NSLocalizedString(@"Load Data", @"String to identify the loading of data");
    //TODO: Handle the Text field
    
    //Get username and password
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:SETTINGS_USERNAME_KEY];
    NSString *password = [userDefaults stringForKey:SETTINGS_PASSWORD_KEY];
    
    //Start Connection
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    [connection setUserName:userName AndPassword:password];
    [connection loadPeopleDataBackgroundWithDelegate:self];
    
    //_statusText.title = @"";
}


/**
 Called if the view recive a memory warning
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////
// Delegates for the Username/Password alert view//
//////////////////////////////////////////////////

/**
 Function called, when the allert view is closed
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex == 0) && (alertView.tag == 0)) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[alertView textFieldAtIndex:0].text forKey:SETTINGS_USERNAME_KEY];
        [userDefaults setObject:[alertView textFieldAtIndex:1].text forKey:SETTINGS_PASSWORD_KEY];
        [self loadDataFirstTime];
    }
}

/////////////////////////////////////////
// Delegates for the Server Connection//
///////////////////////////////////////

/**
 Called when a data request is finished
 */
- (void)serverConnectionFinishedDataRequest:(NSArray *)resultObjects
{
    for (Contact *person in resultObjects[1]) {
        NSLog(@"%@", person.lastName);
        [_model addObject:person];
        [self.tableView reloadData];
    }
}

/**
 Called when the server connection Fails during the login
 */
- (void)serverConnectionFailedDuringLogin:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TITLE_FAILED", @"title for login credentials failed") message:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TEXT", @"text for login credentials") delegate:self cancelButtonTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_OK", @"ok button") otherButtonTitles:nil, nil];
    dataAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    dataAlert.tag = 0;
    [dataAlert show];
}

/**
 Called, when it was not possibe to reach the server
 */
- (void)serverConnectionCouldNotReachTheServer:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REACH_SERVER_FAILED", @"title for reach Server failed") message:[serverConnectionObject getLocalizedErrorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"OK_BUTTON", @"ok button") otherButtonTitles:nil, nil];
    dataAlert.alertViewStyle = UIAlertViewStyleDefault;
    dataAlert.tag = 1;
    [dataAlert show];
}

/**
 Called, when the Server process failed with an unknown error
 */
-(void)serverConnectionFailedWithError:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SERVER_UNKNOWN_ERROR", @"unknown error occoured") message:[serverConnectionObject getLocalizedErrorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"OK_BUTTON", @"ok button") otherButtonTitles:nil, nil];
    dataAlert.tag = 1;
    dataAlert.alertViewStyle = UIAlertViewStyleDefault;
    [dataAlert show];
}

/////////////////////////////////
// Settings for the table view//
///////////////////////////////


/**
 Returns the number of sections in the table
 In this application 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Returns the number rows in the current section
 In this app the size of the array
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.count;
}

/**
 Functions the customize the table view cell ...
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[_model objectAtIndex:indexPath.row] lastName];
    cell.detailTextLabel.text = @"01.01.2000";
    
    
    return cell;
}

/////////////////////////
//Navigation Functions//
///////////////////////

/**
 Function called, before the seque is called
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PersonDetailsViewController *newController = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    [newController setContactData:[_model objectAtIndex:path.row]];
}

@end
