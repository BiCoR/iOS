//
//  ServerConnection.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection

/**
 Constructor
 */
-(id)init
{
    self = [super init];
    if (self)
    {
        _url = @"http://localhost:8080/people.xml"; //TODO: Get URL from properties
        _xmlDataParser = [[XMLDataParser alloc] init];
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
 Function to read the peopleData from the Server
 @return: YES if successfull, else NO
 */
-(bool)readData
{
    //Setting the variables
    bool errorOccoured = NO;
    
    //Get the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    if (!connection) {
        NSLog(@"Connection error");
       errorOccoured = YES;
        _receivedData = nil;
    }
    
    return errorOccoured;
}


//////////////////////////////////////////////
//Delegate Methods for the NSURL Connection//
////////////////////////////////////////////

/**
 Function called, when the connection recive an results
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

/**
 Called when the Connection will recive data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

/**
 Function called when the loading of the data is finished
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", result);
}



@end
