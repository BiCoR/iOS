//
//  ServerConnection.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 12.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDataParser.h"

@interface ServerConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property NSString *url;
@property NSError *lastError;
@property NSMutableData *receivedData;
@property XMLDataParser *xmlDataParser;
@property NSString *authentificationToken;

/**
 Singleton function
 returns the shared Server Connection
 */
+ (id)sharedServerConnection;

/**
 Function to read the peopleData from the Server
 @return: YES if successfull, else NO
 */
- (bool)readData;

@end
