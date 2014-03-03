//
//  NSMutableArray+PersonManager.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 26.02.14.
//  Released under the GNU General Public License v2
//

#import <Foundation/Foundation.h>
#import "Contact.h"


@interface NSMutableArray (PersonManager)

/**
 Function to sort the data array
 */
- (void) sort;

/**
 Function to set up the UILocalNotification
 */
- (void) setUpLocalNotification;

/**
 Function to get the a contact identified with the id of the contact
 @param: userID: the id of the contact
 @return: the contact object, nil if no contact found
 */
- (Contact *) getContactWithId: (NSInteger)userID;

@end
