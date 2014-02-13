//
//  ServerConnection.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDataParserPeople.h"
#import "XMLDataParserLogin.h"
#import "ServerConnectionInformation.h"

//Constants
extern NSString *const SERVER_CONNECTION_LOGIN_PAGE;
extern NSString *const SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO;
extern NSString *const SERVER_CONNECTION_TOKEN_KEY_HEADER;
extern NSString *const SERVER_CONNECTION_AUTHENTICATION_BODY;
extern NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE;

extern NSString *const SERVER_CONNECTION_LOGIN_FAILED;
extern NSString *const SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
extern NSString *const SERVER_CONNECTION_UNKNOWN_ERROR;


@interface ServerConnection : NSObject

//Properties
@property NSString *url;
@property NSString *lastError;
@property NSString *authentificationToken;
@property NSString *userName;
@property NSString *password;
@property NSString *userPartOfUrl;
@property bool logedIn;
@property (weak) NSObject <ServerConnectionInformation> *delegate;
@property NSRecursiveLock *lockingClass;
@property bool loadDataSecondTry;

/**
 Singleton function
 returns the shared Server Connection
 */
+ (id)sharedServerConnection;


/**
 Function to perform the login process on the server
 @param username: The username
 @type username: NSString*
 @param password: The password
 @type password: NSString*
 @return: YES if successfull, else NO
 */
- (bool)performLoginProcessWithUsername: (NSString *)username AndPassword: (NSString *)password;

/**
 Function to perform the login process on the server in the background
 @param username: The username
 @type username: NSString*
 @param password: The password
 @type password: NSString*
 */
- (void)performBackgroundLoginProcessWithUsername: (NSString *)username AndPassword: (NSString *)password;

/**
 Function to perform the login process on the server in the background
 @param dataArray: The Array with the following content: [0]: username, [1]: password
 @type dataArray: NSArray*
 @return: YES if successfull, else NO
 */
- (bool)performLoginProcessWithDataArray: (NSArray *)dataArray;

/**
 Function to load or reload all contact entrys
 @return: YES if successfull, else NO
 */
- (bool)loadPeopleData;

/**
 Function to load or reload all contact entrys in the background
 */
- (void)loadPeopleDataBackground;

/**
 Function to get the localized Error Message
 @return: the localized Error Message
 */
- (NSString *)getLocalizedErrorMessage;

@end
