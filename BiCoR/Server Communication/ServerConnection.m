//
//  ServerConnection.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Released under the GNU General Public License v2
//

#import "ServerConnection.h"
#import "SettingsViewController.h"

//CONSTANTS
NSString * const SERVER_CONNECTION_LOGIN_PAGE = @"/login.xml";
NSString *const SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO = @"/signin";
NSString *const SERVER_CONNECTION_LOGOUT_PAGE = @"/signout";
NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE = @"/people.xml";
NSString *const SERVER_CONNECTION_TOKEN_KEY_HEADER = @"x-csrf-token";
NSString *const SERVER_CONNECTION_AUTHENTICATION_BODY = @"authenticity_token=\"%@\"&user[email]=%@&user[password]=%@";

NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE_WEB = @"/people";
NSString *const SERVER_CONNECTION_ADD_PEOPLE_PAGE_WEB = @"/people/new";
NSString *const SERVER_CONNECTION_PERSON_PAGE_WEB = @"/people/";

NSString *const SERVER_CONNECTION_LOGIN_FAILED = @"SERVER_CONNECTION_LOGIN_FAILED";
NSString *const SERVER_CONNECTION_COULD_NOT_REACH_SERVER = @"SERVER_CONNECTION_COULD_NOT_REACH_SERVER";
NSString *const SERVER_CONNECTION_UNKNOWN_ERROR = @"SERVER_CONNECTION_UNKNOWN_ERROR";

int const SERVER_CONNECTION_LOGIN_FAILED_CODE = 1;
int const SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE = 2;
int const SERVER_CONNECTION_UNKNOWN_ERROR_CODE = 3;

@implementation ServerConnection

/**
 Constructor
 */
-(id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *serverUL = [userDefaults objectForKey:SETTINGS_URL_KEY];
        if (serverUL == nil) {
            serverUL = @"https://quiet-crag-9089.herokuapp.com";
            [userDefaults setObject:serverUL forKey:SETTINGS_URL_KEY];
        }
        _url = serverUL;
        _logedIn = NO;
        _lockingClass = [[NSRecursiveLock alloc] init];
        _loadDataSecondTry = NO;
    }
    
    return self;
}

/**
 Singleton function
 returns the shared Server Connection
 */
+ (id)sharedServerConnection
{
    static ServerConnection *sharedConnection = nil;
    @synchronized(self) {
        if (sharedConnection == nil)
        {
            sharedConnection = [[self alloc] init];
        }
        
    }
    
    return sharedConnection;
}


/**
 Function to perform the login process on the server in the background
 @param delegate: The delegate class
 @type
 */
- (void)performBackgroundLoginProcessWithDelegate:(NSObject *) delegate
{
    [self performSelectorInBackground:@selector(performLoginProcessWithDelegate:) withObject:delegate];
}



/**
 Function to perform the login process on the server
 @param delegate: The delegate class
 @return: An integer error code or 0 if successfull
 */
- (int)performLoginProcessWithDelegate:(NSObject *) delegate
{
    
    //define variables
    NSData *returnedData;
    NSURLResponse *response;
    NSError *error;
    
    //Lock the thread
    [_lockingClass lock];

    //Check if a logout is needed
    /////////////////////////////
    if (_logedIn) {
        if ([self performLogoutProcess] != 0) {
            if([delegate respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
                [delegate performSelectorOnMainThread:@selector(serverConnectionCouldNotReachTheServer:) withObject:self waitUntilDone:NO];
            }
            return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
        }
    }
    
    //Generate the Request - Connection to login.xml
    ////////////////////////////////////////////////
    NSString *loginUrl = [_url stringByAppendingString:SERVER_CONNECTION_LOGIN_PAGE];
    
    NSMutableURLRequest *requestLogin = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestLogin returningResponse:&response error:&error];
    
    if (!returnedData) {
        NSLog(@"Connection error");
        _lastError = SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
        [_lockingClass unlock];
        if([delegate respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionCouldNotReachTheServer:) withObject:self waitUntilDone:NO];
        }
        return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:returnedData];
    XMLDataParserLogin *loginParser = [[XMLDataParserLogin alloc] init];
    parser.delegate = loginParser;
    
    if (![parser parse])
    {
        NSLog(@"Parse Error");
        _lastError = SERVER_CONNECTION_UNKNOWN_ERROR;
        [_lockingClass unlock];
        if([delegate respondsToSelector:@selector(serverConnectionFailedWithError:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionFailedWithError:) withObject:self waitUntilDone:NO];
        }
        return SERVER_CONNECTION_UNKNOWN_ERROR_CODE;
    }
    
    _authentificationToken = [[loginParser.dataArray objectAtIndex:0] objectForKey:XML_DATA_PARSER_LOGIN_AUTHENTICITY_TOKEN];
    
    //Generate the Request - Connection to signin
    /////////////////////////////////////////////
    NSString *signInUrl = [_url stringByAppendingString:SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO];
    
    NSMutableURLRequest *requestSignIn = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:signInUrl]];
    
    [requestSignIn addValue:_authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
    [requestSignIn setHTTPBody:[[NSString stringWithFormat:SERVER_CONNECTION_AUTHENTICATION_BODY, _authentificationToken, _userName, _password] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestSignIn setHTTPMethod:@"POST"];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestSignIn returningResponse:&response error:&error];
    
    if (!returnedData) {
        NSLog(@"Connection error %@", [error localizedDescription]);
        _lastError = SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
        [_lockingClass unlock];
        if([delegate respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionCouldNotReachTheServer:) withObject:self waitUntilDone:NO];
        }
        
        return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
    }
    
    NSMutableString *newToken = [[NSMutableString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    
    //Check if the login was successfull
    ////////////////////////////////////
    if ([response.URL.path isEqualToString:SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO]) {
        NSLog(@"Login error: %@", response.URL.path);
        _lastError = SERVER_CONNECTION_LOGIN_FAILED;
        
        [_lockingClass unlock];
        if([delegate respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionFailedDuringLogin:) withObject:self waitUntilDone:NO];
        }
        return SERVER_CONNECTION_LOGIN_FAILED_CODE;
    }
    
    
    //Parse the result to get the new session token
    ///////////////////////////////////////////////
    
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"<meta content=\".+\" name=\"csrf-token\" />" options:0 error:&error];
    
    NSRange rangePosition = [regEx rangeOfFirstMatchInString:newToken options:0 range:NSMakeRange(0, newToken.length)];
    
    [newToken deleteCharactersInRange:NSMakeRange(rangePosition.length + rangePosition.location, newToken.length - (rangePosition.length + rangePosition.location))];
    [newToken deleteCharactersInRange:NSMakeRange(0, rangePosition.location)];
    
    [newToken deleteCharactersInRange:NSMakeRange(0, [newToken rangeOfString:@"\""].location+1)];

    _authentificationToken = [newToken substringToIndex:[newToken rangeOfString:@"\""].location];
    
    
    //Parse additional informations to get the url
    //////////////////////////////////////////////
    _userPartOfUrl = [response.URL.path substringToIndex:response.URL.path.length - 7];
    _logedIn = YES;
    
    [_lockingClass unlock];
    if([delegate respondsToSelector:@selector(serverConnectionFinishedLoginProcess:)]) {
        [delegate performSelectorOnMainThread:@selector(serverConnectionFinishedLoginProcess:) withObject:self waitUntilDone:NO];
    }
    
    _lastError = nil;
    return 0;
}

/**
 Function to perform the logut process on the server
 @return: An integer error code or 0 if successfull
 */
- (int)performLogoutProcess
{
    NSURLResponse *response;
    NSError *error;
    
    NSString *logoutURL = [_url stringByAppendingString:SERVER_CONNECTION_LOGOUT_PAGE];
    
    NSMutableURLRequest *requestLogOut = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logoutURL]];
    [requestLogOut addValue:_authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:requestLogOut returningResponse:&response error:&error];
    
    if (!returnedData) {
        NSLog(@"Connection error");
        _lastError = SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
        [_lockingClass unlock];

        return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
    }
    _logedIn = NO;
    return 0;
}

/**
 Function to load or reload all contact entrys in the background
 @param delegate: The delegate class
 */
-(void)loadPeopleDataBackgroundWithDelegate: (NSObject *) delegate
{
    [self performSelectorInBackground:@selector(loadPeopleDataWithDelegate:) withObject:delegate];
}

/**
 Function to load or reload all contact entrys
 @param delegate: The delegate class
 @return: An integer error code or 0 if successfull
 */
-(int)loadPeopleDataWithDelegate:(NSObject *) delegate;
{
    //define variables
    NSData *returnedData;
    NSURLResponse *response;
    NSError *error;
    
    //Lock the script
    [_lockingClass lock];
    
    if (!_logedIn)
    {
        switch ([self performLoginProcessWithDelegate:nil]) {
            case SERVER_CONNECTION_LOGIN_FAILED_CODE:
                [_lockingClass unlock];
                if([delegate respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
                    [delegate performSelectorOnMainThread:@selector(serverConnectionFailedDuringLogin:) withObject:self waitUntilDone:NO];
                }
                return SERVER_CONNECTION_LOGIN_FAILED_CODE;
                break;
            case SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE:
                [_lockingClass unlock];
                if([delegate respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
                    [delegate performSelectorOnMainThread:@selector(serverConnectionCouldNotReachTheServer:) withObject:self waitUntilDone:NO];
                }
                return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
                break;
            case SERVER_CONNECTION_UNKNOWN_ERROR_CODE:
                [_lockingClass unlock];
                if([delegate respondsToSelector:@selector(serverConnectionFailedWithError:)]) {
                    [delegate performSelectorOnMainThread:@selector(serverConnectionFailedWithError:) withObject:self waitUntilDone:NO];
                }
                return SERVER_CONNECTION_UNKNOWN_ERROR_CODE;
                break;
        }
    }
    
    NSString *dataUrl = [_url stringByAppendingString:[_userPartOfUrl stringByAppendingString:SERVER_CONNECTION_ALL_PEOPLE_PAGE]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataUrl]];
    
    [requestData addValue:_authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&error];
    
    //Check if errror appears
    if (!returnedData) {
        NSLog(@"Connection error %@", [error localizedDescription]);
        _lastError = SERVER_CONNECTION_COULD_NOT_REACH_SERVER;
        [_lockingClass unlock];
        
        if([delegate respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionCouldNotReachTheServer:) withObject:self waitUntilDone:NO];
        }
        return SERVER_CONNECTION_COULD_NOT_REACH_SERVER_CODE;
    }
    
    //Check if login failed
    if(![dataUrl isEqualToString:response.URL.absoluteString])
    {
        NSLog(@"Login no longer valid");
        _logedIn = NO;
        
        if (_loadDataSecondTry) {
            _lastError = SERVER_CONNECTION_LOGIN_FAILED;
            
            if([delegate respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
                [delegate performSelectorOnMainThread:@selector(serverConnectionFailedDuringLogin:) withObject:self waitUntilDone:NO];
            }
            
            [_lockingClass unlock];
            return SERVER_CONNECTION_LOGIN_FAILED_CODE;
        } else {
            //Call the server to get the right Redirect URL
            NSString *dataUrl = [_url stringByAppendingString:[_userPartOfUrl stringByAppendingString:SERVER_CONNECTION_ALL_PEOPLE_PAGE_WEB]];
            
            NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataUrl]];
            
            [requestData addValue:_authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
            
            [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&error];
            
            //Try to login
            
            if ([self performLoginProcessWithDelegate:nil] != 0) {
                _lastError = SERVER_CONNECTION_LOGIN_FAILED;
                
                [_lockingClass unlock];
                
                if([delegate respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
                    [delegate performSelectorOnMainThread:@selector(serverConnectionFailedDuringLogin:) withObject:self waitUntilDone:NO];
                }
                return SERVER_CONNECTION_LOGIN_FAILED_CODE;
            }
            else //Restart load data process
            {
                _loadDataSecondTry = YES;
                [_lockingClass unlock];
                return [self loadPeopleDataWithDelegate:delegate];
            }
        }
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:returnedData];
    XMLDataParserPeople *peopleParser = [[XMLDataParserPeople alloc] init];
    parser.delegate = peopleParser;
    
    if (![parser parse])
    {
        NSLog(@"Parse Error");
        _lastError = SERVER_CONNECTION_UNKNOWN_ERROR;
        [_lockingClass unlock];
        
        if([delegate respondsToSelector:@selector(serverConnectionFailedWithError:)]) {
            [delegate performSelectorOnMainThread:@selector(serverConnectionFailedWithError:) withObject:self waitUntilDone:NO];
        }
        return SERVER_CONNECTION_UNKNOWN_ERROR_CODE;
    }

    
    [_lockingClass unlock];
    
    if([delegate respondsToSelector:@selector(serverConnectionFinishedDataRequest:)]) {
        NSArray *array = [[NSArray alloc] initWithObjects:self, peopleParser.dataArray, nil];
        [delegate performSelectorOnMainThread:@selector(serverConnectionFinishedDataRequest:) withObject:array waitUntilDone:NO];
    }
    
    _lastError = nil;
    return 0;
}


/**
 Function to get the localized Error Message
 @return: the localized Error Message
 */
-(NSString *)getLocalizedErrorMessage
{
    return NSLocalizedString(_lastError, nil);
}

/**
 Function to set the username and the password
 @param username: The username for the connection
 @param password: The password for the connection
 */
- (void)setUserName:(NSString *)userName AndPassword:(NSString *)password
{
    _userName = userName;
    _password = password;
}




@end
