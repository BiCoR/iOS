//
//  XMLDataParserLogin.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 25.01.14.
//  Released under the GNU General Public License v2
//

#import "XMLDataParserLogin.h"

NSString *const XML_DATA_PARSER_LOGIN_AUTHENTICITY_TOKEN = @"authenticity-token";

@implementation XMLDataParserLogin


/**
 Function called when the parser finished parsing one element
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:XML_DATA_PARSER_LOGIN_AUTHENTICITY_TOKEN])
        [self.dataArray addObject:[NSDictionary dictionaryWithObject:[NSString stringWithString:self.savedCharecters] forKey:XML_DATA_PARSER_LOGIN_AUTHENTICITY_TOKEN]];
}

@end
