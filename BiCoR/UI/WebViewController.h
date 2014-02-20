//
//  WebViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 19.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"


@interface WebViewController : UIViewController <UIWebViewDelegate>

//Properties
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//Methods

@end
