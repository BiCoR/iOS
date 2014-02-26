//
//  Contact.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 10.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "Contact.h"

@implementation Contact

/**
 Function the generate the age of the user
 @return: the age as an integer value
 */
- (NSInteger)ageOfUser
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [[calendar components:NSYearCalendarUnit fromDate:_birthDate toDate:[[NSDate alloc] init] options:0] year];
}



/**
 Function to get the first and the last name as one String
 @return: FIRSTNAME LASTNAME as String
 */
- (NSString *)getFullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

/**
 Function which will return the sortable value
 @return: a value for sorting purposes
 */
- (NSInteger)sortValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =  @"MMdd";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    return [[dateFormatter stringFromDate:_birthDate] integerValue];
}

/**
 Function which will identify if the contact has birthday today
 @return: a boolean to identify if the contact has birthday today
 */
- (bool)hasBirthday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =  @"MMdd";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    return self.sortValue == [[dateFormatter stringFromDate:[[NSDate alloc] init]] integerValue];
}

@end
