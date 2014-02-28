//
//  AppDelegate.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

/**
 Function called, when the application finished the launching with options
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0;
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];

    if (localNotif) {
        [self handleNotification:localNotif];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 Function called when the application receive a local notifcation
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self handleNotification:notification];
}

/**
 Function to handle a notifcation
 @param (UILocalNotification *) localNotification: the notification object;
 */
- (void)handleNotification:(UILocalNotification *)localNotification
{
    //Call the View Controller to show the user
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    if (!([navController.visibleViewController isKindOfClass:[MainViewController class]])) {
        [navController popToRootViewControllerAnimated:NO];
    }
    
    MainViewController *mainController = (MainViewController *)navController.visibleViewController;
    [mainController showDetailsViewForUserWithId:(NSNumber *)[localNotification.userInfo objectForKey:@"USERID"]];
}

/**
 Function called when the Applications enters the Background
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_model setUpLocalNotification];
}

/**
 Function called when the application enters the foreground
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
        application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
