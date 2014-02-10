//
//  MainViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"

//Constants
extern NSString *const SETTINGS_USERNAME_KEY;
extern NSString *const SETTINGS_PASSWORD_KEY;

@interface MainViewController : UITableViewController

//Properties
@property NSMutableArray *model;

@end
