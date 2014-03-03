//
//  ServerConnectionInformation.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 27.01.14.
//  Released under the GNU General Public License v2
//

#import <Foundation/Foundation.h>

@class ServerConnection;

@protocol ServerConnectionInformation <NSObject>

//Optional Methods
@optional

/**
 Function called, when the server connection finished the login process
 @param serverConnectionObject: A instance of the ServerConnection
 */
- (void) serverConnectionFinishedLoginProcess: (ServerConnection *) serverConnectionObject;

/**
 Function called when a data request is finished
 @param resultObjects: [0] The Server Connection Object / [1]: The result array
 */
- (void) serverConnectionFinishedDataRequest: (NSArray *) resultObjects;

/**
 Function called, when the server connection failed in the login process
 @param serverConnectionObject: A instance of the ServerConnection
 */
- (void) serverConnectionFailedDuringLogin: (ServerConnection *) serverConnectionObject;

/**
 Function called, when the server connection failed to reach the server
 @param serverConnectionObject: A instance of the ServerConnection
 */
- (void) serverConnectionCouldNotReachTheServer: (ServerConnection *) serverConnectionObject;


/**
 Function called, when the server connection failed and it wasn't an login or connection problem
 @param serverConnectionObject: A instance of the ServerConnection
 */
- (void) serverConnectionFailedWithError: (ServerConnection *) serverConnectionObject;
@end
