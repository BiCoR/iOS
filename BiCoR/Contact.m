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
- (int)ageOfUser
{
    return 0; //TODO: Add function
}

/**
 Function to get the first and the last name as one String
 @return: FIRSTNAME LASTNAME as String
 */
- (NSString *)getFullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end
