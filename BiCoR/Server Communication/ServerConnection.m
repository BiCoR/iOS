//
//  ServerConnection.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "ServerConnection.h"

//CONSTANTS
NSString * const SERVER_CONNECTION_LOGIN_PAGE = @"/login.xml";
NSString *const SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO = @"/signin";
NSString *const SERVER_CONNECTION_ALL_PEOPLE_PAGE = @"/people.xml";
NSString *const SERVER_CONNECTION_TOKEN_KEY_HEADER = @"x-csrf-token";
NSString *const SERVER_CONNECTION_AUTHENTICATION_BODY = @"authenticity_token=\"%@\"&user[email]=%@&user[password]=%@";

@implementation ServerConnection

/**
 Constructor
 */
-(id)init
{
    self = [super init];
    if (self)
    {
        _url = @"http://quiet-crag-9089.herokuapp.com"; //TODO: Get URL from properties
        _logedIn = NO;
        _lockingClass = [[NSLock alloc] init];
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
 @param username: The username
 @type username: NSString*
 @param password: The password
 @type password: NSString*
 */
- (void)performBackgroundLoginProcessWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    NSArray *array = [[NSArray alloc] initWithObjects:username, password, nil];
    
    [self performSelectorInBackground:@selector(performLoginProcessWithDataArray:) withObject:array];
}

/**
 Function to perform the login process on the server
 @param username: The username
 @type username: NSString*
 @param password: The password
 @type password: NSString*
 @return: YES if successfull, else NO
 */
-(bool)performLoginProcessWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    NSArray *array = [[NSArray alloc] initWithObjects:username, password, nil];
    
    return [self performLoginProcessWithDataArray:array];
}



/**
 Function to perform the login process on the server in the background
 @param dataArray: The Array with the following content: [0]: username, [1]: password
 @type dataArray: NSArray*
 @return: YES if successfull, else NO
 */
- (bool)performLoginProcessWithDataArray:(NSArray *)dataArray
{
    
    //define variables
    NSData *returnedData;
    NSURLResponse *response;
    NSError *error;
    
    //Lock the thread
    [_lockingClass lock];
    
    //get variables
    _userName = dataArray[0];
    _password = dataArray[1];

    
    //Generate the Request - Connection to login.xml
    ////////////////////////////////////////////////
    NSString *loginUrl = [_url stringByAppendingString:SERVER_CONNECTION_LOGIN_PAGE];
    
    NSMutableURLRequest *requestLogin = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestLogin returningResponse:&response error:&error];
    
    if (!returnedData) {
        NSLog(@"Connection error"); //TODO: Handle Error
        
        [_lockingClass unlock];
        if([[self delegate] respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [[self delegate] serverConnectionCouldNotReachTheServer:self];
        }
        return NO;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:returnedData];
    XMLDataParserLogin *loginParser = [[XMLDataParserLogin alloc] init];
    parser.delegate = loginParser;
    
    if (![parser parse])
    {
        NSLog(@"Parse Error");
        
        [_lockingClass unlock];
        if([[self delegate] respondsToSelector:@selector(serverConnectionFailedWithError:)]) {
            [[self delegate] serverConnectionFailedWithError:self];
        }
        return NO;
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
        
        [_lockingClass unlock];
        if([[self delegate] respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [[self delegate] serverConnectionCouldNotReachTheServer:self];
        }
        
        return NO;
    }
    
    NSMutableString *newToken = [[NSMutableString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    
    //Check if the login was successfull
    ////////////////////////////////////
    if ([response.URL.path isEqualToString:SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO]) {
        NSLog(@"Login error");
        [_lockingClass unlock];
        
        if([[self delegate] respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
            [[self delegate] serverConnectionFailedDuringLogin:self];
        }
        return NO;
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
    if([[self delegate] respondsToSelector:@selector(serverConnectionFinishedLoginProcess:)]) {
        [[self delegate] serverConnectionFinishedLoginProcess:self];
    }
    return YES;
}

/**
 Function to load or reload all contact entrys in the background
 */
-(void)loadPeopleDataBackground
{
    [self performSelectorInBackground:@selector(loadPeopleData) withObject:nil];
}

/**
 Function to load or reload all contact entrys
 @return: YES if successfull, else NO
 */
-(bool)loadPeopleData
{
    //define variables
    NSData *returnedData;
    NSURLResponse *response;
    NSError *error;
    
    //Lock the script
    [_lockingClass lock];
    
    if (!_logedIn)
    {
        [self performLoginProcessWithUsername:_userName AndPassword:_password];
    }
    
    NSString *dataUrl = [_url stringByAppendingString:[_userPartOfUrl stringByAppendingString:SERVER_CONNECTION_ALL_PEOPLE_PAGE]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataUrl]];
    
    [requestData addValue:_authentificationToken forHTTPHeaderField:SERVER_CONNECTION_TOKEN_KEY_HEADER];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&error];
    
    //Check if errror appears
    if (!returnedData) {
        NSLog(@"Connection error %@", [error localizedDescription]);

        [_lockingClass unlock];
        
        if([[self delegate] respondsToSelector:@selector(serverConnectionCouldNotReachTheServer:)]) {
            [[self delegate] serverConnectionCouldNotReachTheServer:self];
        }
        return NO;
    }
    
    //Check if login failed
    if(![dataUrl isEqualToString:response.URL.absoluteString])
    {
        NSLog(@"Login no longer valid");
        _logedIn = NO;
        
        [_lockingClass unlock];
        
        if([[self delegate] respondsToSelector:@selector(serverConnectionFailedDuringLogin:)]) {
            [[self delegate] serverConnectionFailedDuringLogin:self];
        }
        return NO;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:returnedData];
    XMLDataParserPeople *peopleParser = [[XMLDataParserPeople alloc] init];
    parser.delegate = peopleParser;
    
    if (![parser parse])
    {
        NSLog(@"Parse Error");
        
        [_lockingClass unlock];
        
        if([[self delegate] respondsToSelector:@selector(serverConnectionFailedWithError:)]) {
            [[self delegate] serverConnectionFailedWithError:self];
        }
        return NO;
    }

    
    [_lockingClass unlock];
    
    if([[self delegate] respondsToSelector:@selector(serverConnectionFinishedDataRequest:)]) {
        NSArray *array = [[NSArray alloc] initWithObjects:self, peopleParser.dataArray, nil];
        [[self delegate] serverConnectionFinishedDataRequest:array];
    }
    return YES;
}




@end
