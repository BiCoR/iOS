//
//  ServerConnection.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Released under the GNU General Public License v2
//

#import <Foundation/Foundation.h>
#import "XMLDataParserPeople.h"
#import "XMLDataParserLogin.h"
#import "ServerConnectionInformation.h"

//Constants
extern NSString *const SERVER_CONNECTION_LOGIN_PAGE;
extern NSString *const SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO;
extern NSString *const SERVER_CONNECTION_LOGOUT_PAGE;
extern NSString *const SERVER_CONNECTION_TOKEN_KEY_HEADER;
extern NSString *const SERVER_CONNECTION_AUTHENTICATION_BODY;
extern NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE;

extern NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE_WEB;
extern NSString *const SERVER_CONNECTION_ADD_PEOPLE_PAGE_WEB;
extern NSString *const SERVER_CONNECTION_PERSON_PAGE_WEB;

extern NSString *const SERVER_CONNECTION_LOGIN_FAILED;
extern NSString *const SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
extern NSString *const SERVER_CONNECTION_UNKNOWN_ERROR;

extern int const SERVER_CONNECTION_LOGIN_FAILED_CODE;
extern int const SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
extern int const SERVER_CONNECTION_UNKNOWN_ERROR_CODE;


@interface ServerConnection : NSObject

//Properties
@property NSString *url;
@property NSString *lastError;
@property NSString *authentificationToken;
@property NSString *userName;
@property NSString *password;
@property NSString *userPartOfUrl;
@property bool logedIn;
@property NSRecursiveLock *lockingClass;
@property bool loadDataSecondTry;

/**
 Singleton function
 returns the shared Server Connection
 */
+ (id)sharedServerConnection;

/**
 Function to set the username and the password
 @param username: The username for the connection
 @param password: The password for the connection
 */
- (void)setUserName:(NSString *)userName AndPassword: (NSString *) password;

/**
 Function to perform the login process on the server
 @param delegate: The delegate class
 @return: An integer error code or 0 if successfull
 */
- (int)performLoginProcessWithDelegate:(NSObject *) delegate;

/**
 Function to perform the login process on the server in the background
 @param delegate: The delegate class
 @type password: NSString*
 */
- (void)performBackgroundLoginProcessWithDelegate:(NSObject *) delegate;

/**
 Function to perform the logut process on the server
 @return: An integer error code or 0 if successfull
 */
- (int)performLogoutProcess;

/**
 Function to load or reload all contact entrys
 @param delegate: The delegate class
 @return: An integer error code or 0 if successfull
 */
- (int)loadPeopleDataWithDelegate:(NSObject *) delegate;

/**
 Function to load or reload all contact entrys in the background
 @param delegate: The delegate class
 */
- (void)loadPeopleDataBackgroundWithDelegate: (NSObject *) delegate;

/**
 Function to get the localized Error Message
 @return: the localized Error Message
 */
- (NSString *)getLocalizedErrorMessage;

@end
