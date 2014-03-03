//
//  WebViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 19.02.14.
//  Released under the GNU General Public License v2
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"

extern int const WEB_VIEW_CONTROLLER_MANAGE_USERS;
extern int const WEB_VIEW_CONTROLLER_ADD_USER;
extern int const WEB_VIEW_CONTROLLER_EDIT_USER;

@interface WebViewController : UIViewController <UIWebViewDelegate>

//Properties
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property int actionType;
@property int userId;

@end
