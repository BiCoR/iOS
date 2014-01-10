//
//  Contact.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 10.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject


//Properties

@property NSString *firstName;
@property NSString *lastName;
@property NSData *birthDate;
@property NSString *mail;
@property NSString *phoneLandline;
@property NSString *phoneMobile;
@property UIImage *picture;

//Functions

/**
 Function the generate the age of the user
 @return: the age as an integer value
 */
- (int) ageOfUser;

@end
