//
//  WebViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 19.02.14.
//  Released under the GNU General Public License v2
//

#import "WebViewController.h"

int const WEB_VIEW_CONTROLLER_MANAGE_USERS = 0;
int const WEB_VIEW_CONTROLLER_ADD_USER = 1;
int const WEB_VIEW_CONTROLLER_EDIT_USER = 2;

@implementation WebViewController

/**
 Function called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;
    _loadCounter = 0;
    
    //Prepate the Connection
    
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    
    NSString *dataUrl;
    
    //Choose the Type
    switch (_actionType) {
        case WEB_VIEW_CONTROLLER_MANAGE_USERS:
             dataUrl = [connection.url stringByAppendingString:[connection.userPartOfUrl stringByAppendingString:SERVER_CONNECTION_ALL_PEOPLE_PAGE_WEB]];
            break;
        case WEB_VIEW_CONTROLLER_ADD_USER:
            dataUrl = [connection.url stringByAppendingString:[connection.userPartOfUrl stringByAppendingString:SERVER_CONNECTION_ADD_PEOPLE_PAGE_WEB]];
            break;
        case WEB_VIEW_CONTROLLER_EDIT_USER:
            dataUrl = [connection.url stringByAppendingString:[connection.userPartOfUrl stringByAppendingString:[SERVER_CONNECTION_PERSON_PAGE_WEB stringByAppendingString:[NSString stringWithFormat:@"%i/edit", _userId]]]];
            break;
        default:
            break;
    }
    
    //Prepare and send the request
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataUrl]];
    
    [requestData addValue:connection.authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
    [_activityIndicator startAnimating];
    
    [_webView loadRequest:requestData];
    
}

/**
 Called when a memory warning is received
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Function called when the view will disappear
 Needed to reanable to UI Toolbar
 */
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    _userId = -1;
}

///////////////////////////////////////
//Delegate Methods for the UIWebView//
/////////////////////////////////////

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    _loadCounter++;
    if ((_actionType != WEB_VIEW_CONTROLLER_MANAGE_USERS) && (_loadCounter >= 2)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
