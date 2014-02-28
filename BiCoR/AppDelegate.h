//
//  AppDelegate.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray+PersonManager.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSMutableArray *model;

/**
 Function to handle a notifcation
 @param (UILocalNotification *) localNotification: the notification object;
 */
- (void) handleNotification: (UILocalNotification *) localNotification;

@end
