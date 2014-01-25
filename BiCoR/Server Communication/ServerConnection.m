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
 Function to perform the login process on the server
 @param username: The username
 @type username: NSString*
 @param password: The password
 @type password: NSString*
 @return: YES if successfull, else NO
 */
- (bool)performLoginProcessWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    //define variables
    NSData *returnedData;
    
    //get variables
    _userName = username;
    _password = password;
    
    //Definie used Variables
    NSURLResponse *response;
    NSError *error;
    
    //Generate the Request - Connection to login.xml
    ////////////////////////////////////////////////
    NSString *loginUrl = [_url stringByAppendingString:SERVER_CONNECTION_LOGIN_PAGE];
    
    NSMutableURLRequest *requestLogin = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    
    returnedData = [NSURLConnection sendSynchronousRequest:requestLogin returningResponse:&response error:&error];
    
    if (!returnedData) {
        NSLog(@"Connection error"); //TODO: Handle Error
        return NO;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:returnedData];
    XMLDataParserLogin *loginParser = [[XMLDataParserLogin alloc] init];
    parser.delegate = loginParser;
    
    if (![parser parse])
    {
        NSLog(@"Parse Error"); //TODO: Handle Error
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
        NSLog(@"Connection error %@", [error localizedDescription]); //TODO: Handle Error
        return NO;
    }
    
    NSMutableString *newToken = [[NSMutableString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    
    //Check if the login was successfull
    ////////////////////////////////////
    if ([response.URL.path isEqualToString:SERVER_CONNECTION_LOGIN_PAGE_STEP_TWO]) {
        NSLog(@"Login error"); //TODO: Handle error
        
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
    
    
    return YES;
}



@end
