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
    int fieldsToMove = 0;
    int compareValueNow;
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

@end
