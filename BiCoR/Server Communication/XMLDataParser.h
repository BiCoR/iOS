//
//  XMLDataParser.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 13.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLDataParser : NSObject <NSXMLParserDelegate>


/**
 Function the parse the peopleXML File
 @param: the xml file as NSData *
 @return: An array with Contact objects
 */
- (NSMutableArray *) parsePeopleXMLFile: (NSData *) data;

@end
