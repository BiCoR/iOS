//
//  WebViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 19.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
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
