//
//  XMLDataParser.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 13.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "XMLDataParser.h"

@implementation XMLDataParser


/**
 Function called when the parser starts parsing the document
 instantiate the array if needed and remove all elements in it
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    if (!_savedCharecters) {
        _savedCharecters = [NSMutableString string];
    }
    
    [_dataArray removeAllObjects];
    _savedCharecters.string = @"";
    
    
}

/**
 Function called, when the parser starts parsing an element
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElement = elementName;
    _savedCharecters.string = @"";
}

/**
 Function called, when the parser found charecters
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_savedCharecters appendString:string];
}

/**
 Function called when an error Occoured
 */
-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    _error = validationError;
}

@end
