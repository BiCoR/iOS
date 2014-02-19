//
//  WebViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 19.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

/**
 Function called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;
    
    //Adapt the insets to match the Toolbar
    UIEdgeInsets inset =  _webView.scrollView.contentInset;
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.right, 88);
    
    
    //Open the Website: Add edit information
    ServerConnection *connection = [ServerConnection sharedServerConnection];
    
	NSString *dataUrl = [connection.url stringByAppendingString:[connection.userPartOfUrl stringByAppendingString:@"/people"]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataUrl]];
    
    [requestData addValue:connection.authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
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
}
@end
