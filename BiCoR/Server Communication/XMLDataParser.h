//
//  XMLDataParser.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 13.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLDataParser : NSObject <NSXMLParserDelegate>

///////////////
//Properties//
/////////////
@property NSMutableArray *dataArray;
@property NSString *currentElement;
@property NSMutableString *savedCharecters;
@property NSError *error;


@end
