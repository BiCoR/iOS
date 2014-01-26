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
@property NSDate *birthDate;
@property NSString *mail;
@property NSString *phoneLandline;
@property NSString *phoneMobile;
@property UIImage *picture;
@property int ID;

//Functions


/**
 Function the generate the age of the user
 @return: the age as an integer value
 */
- (int) ageOfUser;

@end
