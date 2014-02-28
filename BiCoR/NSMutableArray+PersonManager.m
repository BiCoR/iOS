//
//  NSMutableArray+PersonManager.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 26.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "NSMutableArray+PersonManager.h"

@implementation NSMutableArray (PersonManager)

/**
 Function to sort the data array
 */
- (void)sort
{
    //Sort the array by the data
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortValue"
                                                 ascending:YES];
    [self sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //Search the position in the array where the birthdate is behind the current date
    NSInteger fieldsToMove = 0;
    NSInteger compareValueNow;
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =  @"MMdd";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    compareValueNow = [[dateFormatter stringFromDate:now] integerValue];
    
    for (Contact *c in self) {
        if ((c.sortValue == compareValueNow) || (c.sortValue > compareValueNow)) {
            break;
        }
        fieldsToMove++;
    }
    
    //Move the values to the end
    for (int i=0; i < fieldsToMove; i++) {
        [self addObject:[self objectAtIndex:0]];
        [self removeObjectAtIndex:0];
    }
}

/**
 Function to set up the UILocalNotification
 */
- (void)setUpLocalNotification
{
    //TEST CODE
    NSDate *alertTime = [[NSDate date]
                         dateByAddingTimeInterval:10];
    //END TEST CODE
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.applicationIconBadgeNumber = 1;
    notification.alertAction = nil;
    notification.alertBody = @"Body text";
    notification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:49] forKey:@"USERID"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}


/**
 Function to get the a contact identified with the id of the contact
 @param: userID: the id of the contact
 @return: the contact object, nil if no contact found
 */
- (Contact *)getContactWithId:(NSInteger)userID
{
    for (Contact *c in self) {
        if (c.ID == userID) {
            return c;
        }
    }
    
    return nil;
}

@end
