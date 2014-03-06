//
//  SettingsViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 01.03.14.
//  Released under the GNU General Public License v2
//

#import "SettingsViewController.h"

//CONSTANTS
NSString * const SETTINGS_USERNAME_KEY = @"USERNAME";
NSString * const SETTINGS_PASSWORD_KEY = @"PASSWORD";
NSString * const SETTINGS_URL_KEY = @"URL";
NSString *const SETTINGS_FIRST_WARNING_TIME_KEY = @"FIRST_WARNING_TIME";
NSString *const SETTINGS_SECOND_WARNING_TIME_KEY = @"SECOND_WARNING_TIME";


@implementation SettingsViewController

/**
 Called when the nib file is loaded
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    //Hide the toolbar
    
    //Fill the toolbar
    //////////////////
    //About Buttons
    UIBarButtonItem *aboutBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", nil) style:UIBarButtonItemStylePlain target:self action:@selector(aboutButtonClicked:)];
    
    
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
    
    [self setToolbarItems:[NSArray arrayWithObjects:spacer, toolBarTitle, spacer, aboutBtn, nil] animated:NO];
    
}


/**
 Called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    //Set up the Cancel Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    
    //Save the old data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _oldUserName = [userDefaults stringForKey:SETTINGS_USERNAME_KEY];
    _oldPassword = [userDefaults stringForKey:SETTINGS_PASSWORD_KEY];
    _oldURL = [userDefaults stringForKey:SETTINGS_URL_KEY];
    
    //Enter the values into the text field
    _userNameLabel.text = _oldUserName;
    _passwordLabel.text = _oldPassword;
    _serverURLLabel.text = _oldURL;
    _firstWarningLabel.text = [userDefaults stringForKey:SETTINGS_FIRST_WARNING_TIME_KEY];
    _secondWarningLabel.text = [userDefaults stringForKey:SETTINGS_SECOND_WARNING_TIME_KEY];
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
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    connection.userName = _oldUserName;
    connection.password = _oldPassword;
    connection.url = _oldURL;
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.toolbarHidden = NO;
}

/**
 Function called when the save Button is clicked
 @param sender: The sender, which calls the event
 */
- (IBAction)saveButtonClicked:(id)sender {
    
    //Hide the keyboard
    [self.view endEditing:YES];
    
    //Check if the entered Values are valid
    
    //Check the Warning Times
    NSInteger newFirstWarningTime = [_firstWarningLabel.text integerValue];
    NSInteger newSecondWarningTime = [_secondWarningLabel.text integerValue];
    
    if (newFirstWarningTime <= 0) {
        _firstWarningLabel.layer.borderWidth = 1.0f;
        _firstWarningLabel.layer.borderColor = [[UIColor redColor] CGColor];
        return;
    }
    else if ((newSecondWarningTime <= 0) || (newSecondWarningTime >= newFirstWarningTime))
    {
        _secondWarningLabel.layer.borderWidth = 1.0f;
        _secondWarningLabel.layer.borderColor = [[UIColor redColor] CGColor];
        return;
    }
    else
    {
        _firstWarningLabel.layer.borderWidth = 0.0f;
        _secondWarningLabel.layer.borderWidth = 0.0f;
        
        //Set the user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld", (long)newFirstWarningTime] forKey:SETTINGS_FIRST_WARNING_TIME_KEY];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld", (long)newSecondWarningTime] forKey:SETTINGS_SECOND_WARNING_TIME_KEY];
    }
    
    //Check the connection
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    
    //Enter the new values
    connection.userName = _userNameLabel.text;
    connection.password = _passwordLabel.text;
    connection.url = _serverURLLabel.text;
    
    //Start testing the login process
    [self setStatusForLoadingData:YES];
    [connection performBackgroundLoginProcessWithDelegate:self];
    self.navigationController.toolbarHidden = NO;
}
    
/**
 Function called, when the about button is clicked
 @param sender: The sender, which calls the event
 */
    
- (void)aboutButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"AboutSegue" sender:self];
}

/**
 Functions to inform the user, that the programm currently load data
 @param loadingData: Indicator the define, if the program will load data
 */
- (void) setStatusForLoadingData: (bool) loadingData;
{
    if (loadingData)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        _saveButton.enabled = NO;
        _statusLabel.text = NSLocalizedString(@"Check entered information", nil);
        [_statusLabel sizeToFit];
    }
    else
    {
        _statusLabel.text = @"";
        [_statusLabel sizeToFit];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        _saveButton.enabled = YES;
    }
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

/////////////////////////////////////////
// Delegates for the Server Connection//
///////////////////////////////////////

/**
 Called when the login Process is successfull
 */
- (void)serverConnectionFinishedLoginProcess:(ServerConnection *)serverConnectionObject
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:_userNameLabel.text forKey:SETTINGS_USERNAME_KEY];
    [userDefaults setObject:_passwordLabel.text forKey:SETTINGS_PASSWORD_KEY];
    [userDefaults setObject:_serverURLLabel.text forKey:SETTINGS_URL_KEY];
    [self setStatusForLoadingData:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 Called when the server connection Fails during the login
 */
- (void)serverConnectionFailedDuringLogin:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SETTINGS_LOGIN_INFORMATION_WRONG", @"title for wrong username / passwd") message:NSLocalizedString(@"SETTINGS_LOGIN_INFORMATION_WRONG_TEXT", @"text for wrong username / passwd") delegate:self cancelButtonTitle:NSLocalizedString(@"OK_BUTTON", @"ok button") otherButtonTitles:nil, nil];
    dataAlert.alertViewStyle = UIAlertViewStyleDefault;
    dataAlert.tag = 1;
    [self setStatusForLoadingData:NO];
    [dataAlert show];
}

/**
 Called, when it was not possibe to reach the server
 */
- (void)serverConnectionCouldNotReachTheServer:(ServerConnection *)serverConnectionObject
{
    UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REACH_SERVER_FAILED", @"title for reach Server failed") message:NSLocalizedString(@"SETTINGS_COULDNT_REACH_SERVER_TEXT", @"text for reach Server failed") delegate:self cancelButtonTitle:NSLocalizedString(@"OK_BUTTON", @"ok button") otherButtonTitles:nil, nil];
    dataAlert.alertViewStyle = UIAlertViewStyleDefault;
    dataAlert.tag = 1;
    [self setStatusForLoadingData:NO];
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
    [self setStatusForLoadingData:NO];
    [dataAlert show];
}


@end
