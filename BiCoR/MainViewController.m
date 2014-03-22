//
//  MainViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Released under the GNU General Public License v2
//

#import "MainViewController.h"
#import "AppDelegate.h"

@implementation MainViewController

/**
 Called when the nib file is loaded
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    _model = [[NSMutableArray alloc] init];
    _switchID = -1;
    
    //Add a reference of the model to the App Delegate
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.model = _model;
    
    //Fill the toolbar
    //////////////////
    //Settings Buttons
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonClicked:)];
    
    //Spacer
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];    
    
    //Text Label
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 23)];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.backgroundColor = [UIColor clearColor];
    
    _statusLabel.font = [_statusLabel.font fontWithSize:15];
    _statusLabel.text = @"";
    [_statusLabel sizeToFit];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:_statusLabel];
    
    //Create new User Button
    UIBarButtonItem *newUserBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUserButtonClicked:)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:settingsBtn, spacer, toolBarTitle, spacer, newUserBtn, nil] animated:NO];
    
}

/**
 Callend when view is loaded
 */
- (void)viewDidLoad
{
    //Set the refresh Controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    //Get first and second warning time
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _firstWarningTime = [[userDefaults stringForKey:SETTINGS_FIRST_WARNING_TIME_KEY] integerValue];
    _secondWarningTime = [[userDefaults stringForKey:SETTINGS_SECOND_WARNING_TIME_KEY] integerValue];
    
    if (_firstWarningTime <= 0) {
        _firstWarningTime = 30;
        [userDefaults setObject:[NSString stringWithFormat:@"%li", (long)_firstWarningTime] forKey:SETTINGS_FIRST_WARNING_TIME_KEY];
    }
    if (_secondWarningTime <= 0)
    {
        _secondWarningTime = 5;
        [userDefaults setObject:[NSString stringWithFormat:@"%li", (long)_secondWarningTime] forKey:SETTINGS_SECOND_WARNING_TIME_KEY];
    }
    
    //Get username and password
    NSString *userName = [userDefaults stringForKey:SETTINGS_USERNAME_KEY];
    NSString *password = [userDefaults stringForKey:SETTINGS_PASSWORD_KEY];
    
    //Check if userName / Password allready exists
    if ((userName == nil) || (password == nil)) {
        [self setStatusForLoadingData:YES];
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TITLE", @"title for login credentials") message:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TEXT", @"text for login credentials") delegate:self cancelButtonTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_OK", @"ok button") otherButtonTitles:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_REGISTER", @"Register Button"), nil];
        dataAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [dataAlert show];
    }
    //If allready exists start loading data
    else
    {
        [self loadDataFirstTime];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshView:self];
}


/**
 Function to fill the table view the first time
 */
- (void)loadDataFirstTime
{
    [self setStatusForLoadingData:YES];
    
    //Get username and password
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:SETTINGS_USERNAME_KEY];
    NSString *password = [userDefaults stringForKey:SETTINGS_PASSWORD_KEY];
    
    //Start Connection
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    [connection setUserName:userName AndPassword:password];
    [connection loadPeopleDataBackgroundWithDelegate:self];
}

/**
 Functions to inform the user, that the programm currently load data
 @param loadingData: Indicator the define, if the program will load data
 */
- (void) setStatusForLoadingData: (bool) loadingData;
{
    if (loadingData)
    {
        _statusLabel.text = NSLocalizedString(@"Load Data", nil);
        [_statusLabel sizeToFit];
        _statusLoadingData = YES;
    }
    else
    {
        _statusLabel.text = @"";
        [_statusLabel sizeToFit];
        _statusLoadingData = NO;
        [self.refreshControl endRefreshing];
    }
}

/**
 Function which is called, when the user scrolls up to refresh the data
 @param sender: The sender of the event
 */
- (void)refreshView:(id)sender {
    if (!_statusLoadingData) {
        
        [self setStatusForLoadingData:YES];
        
        //Start Connection
        ServerConnection *connection = [ServerConnection sharedServerConnection];
        [connection loadPeopleDataBackgroundWithDelegate:self];
    }
}

/**
 Function called when the add user button is clicked
 @param sender: The sender of the event
 */
- (void)addUserButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"personAdd" sender:sender];
}

/**
 Function called when the settings button is clicked
 @param sender: The sender of the event
 */
- (void)settingsButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:sender];
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
    else if ((buttonIndex == 1) && (alertView.tag == 0))
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://quiet-crag-9089.herokuapp.com/sign_up"]];
        [self setStatusForLoadingData:NO];
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
    [_model removeAllObjects];
    for (Contact *person in resultObjects[1]) {
        [_model addObject:person];
    }
    
    [_model sort];
    
    [self.tableView reloadData];
    
    [self setStatusForLoadingData:NO];
}

/**
 Called when the server connection Fails during the login
 */
- (void)serverConnectionFailedDuringLogin:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TITLE", @"title for login credentials") message:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_TEXT", @"text for login credentials") delegate:self cancelButtonTitle:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_OK", @"ok button") otherButtonTitles:NSLocalizedString(@"ENTER_LOGIN_CREDENTIALS_REGISTER", @"Register Button"), nil];
    dataAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    dataAlert.tag = 0;
    [dataAlert show];
    [self setStatusForLoadingData:NO];
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
    [self setStatusForLoadingData:NO];
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
    [self setStatusForLoadingData:NO];
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
    Contact *c = [_model objectAtIndex:indexPath. row];
    cell.textLabel.text = [c getFullName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =  @"dd'.'MM'.'yyyy";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:c.birthDate];
    //If the user has Birthday mark the cell and add a image
    if (c.hasBirthday)
    {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.623529 blue:0.364706 alpha:1.0];
        cell.imageView.image = [UIImage imageNamed:@"BirthdayImage"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        //Reset birthday values
        cell.imageView.image = nil;
        cell.backgroundColor = [UIColor whiteColor];
        
        //Get the components of the current date
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *daysToBirthday = [calendar components:(NSDayCalendarUnit) fromDate:[[NSDate alloc] init] toDate:c.nextBirthday options:0];
        
        if (((daysToBirthday.day + 1) < _secondWarningTime)) {
            cell.textLabel.textColor = [UIColor redColor];
        } else if((daysToBirthday.day + 1 < _firstWarningTime)) {
            cell.textLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    
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
    
    if ([segue.identifier isEqualToString:@"personDetails"]) {
        PersonDetailsViewController *newController = [segue destinationViewController];
        if (_switchID != -1) {
            [newController setContactData:[_model getContactWithId:_switchID]];
            _switchID= -1;
        } else {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            [newController setContactData:[_model objectAtIndex:path.row]];
        }
    }
    else if ([segue.identifier isEqualToString:@"personEdit"])
    {
        WebViewController *newController = [segue destinationViewController];
        newController.actionType = WEB_VIEW_CONTROLLER_MANAGE_USERS;
    }
    else if ([segue.identifier isEqualToString:@"personAdd"])
    {
        WebViewController *newController = [segue destinationViewController];
        newController.actionType = WEB_VIEW_CONTROLLER_ADD_USER;
    }
}

/**
 Function to show the details view of one user
 @param userID: the user id as integer value
 */
- (void)showDetailsViewForUserWithId:(NSNumber *)userID
{
    _switchID = [userID integerValue];
    [self performSegueWithIdentifier:@"personDetails" sender:self];
    
}

@end
