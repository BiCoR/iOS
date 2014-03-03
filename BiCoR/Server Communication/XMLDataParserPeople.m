//
//  XMLDataParserPeople.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 24.01.14.
//  Released under the GNU General Public License v2
//

#import "XMLDataParserPeople.h"

NSString *const XML_DATA_PARSER_PEOPLE_IMAGE_TAG = @"bild";
NSString *const XML_DATA_PARSER_PEOPLE_MAIL_TAG = @"email";
NSString *const XML_DATA_PARSER_PEOPLE_FIRST_NAME_TAG = @"first-name";
NSString *const XML_DATA_PARSER_PEOPLE_BIRTH_DATE_TAG = @"geburtsdatum";
NSString *const XML_DATA_PARSER_PEOPLE_LAST_NAME_TAG = @"last-name";
NSString *const XML_DATA_PARSER_PEOPLE_PHONE_LANDLINE_TAG = @"telefon-fest";
NSString *const XML_DATA_PARSER_PEOPLE_PHONE_MOBILE_TAG = @"telefon-mobil";
NSString *const XML_DATA_PARSER_PEOPLE_ID_TAG = @"id";
NSString *const XML_DATA_PARSER_PEOPLE_PERSON_TAG = @"person";

@implementation XMLDataParserPeople

/**
 Function called, when the parser starts parsing an element
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    
    if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_PERSON_TAG])
        _person = [[Contact alloc] init];
}

/**
 Function called when the parser finish one element
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_PERSON_TAG])
        [self.dataArray addObject:_person];
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_MAIL_TAG])
        _person.mail = self.savedCharecters.copy;
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_FIRST_NAME_TAG])
        _person.firstName = self.savedCharecters.copy;
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_LAST_NAME_TAG])
        _person.lastName = self.savedCharecters.copy;
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_PHONE_LANDLINE_TAG])
        _person.phoneLandline = self.savedCharecters.copy;
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_PHONE_MOBILE_TAG])
        _person.phoneMobile = self.savedCharecters.copy;
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_ID_TAG])
        _person.ID = [self.savedCharecters integerValue];
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_IMAGE_TAG])
    {
        NSString *str = @"data:image/jpg;base64,";
        str = [NSString stringWithFormat:@"data:image/jpg;base64,%@", self.savedCharecters];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        _person.picture = [UIImage imageWithData:imageData];
    }
    else if ([elementName isEqualToString:XML_DATA_PARSER_PEOPLE_BIRTH_DATE_TAG])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat =  @"yyyy'-'MM'-'dd";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _person.birthDate = [dateFormatter dateFromString:self.savedCharecters];
    }
    
}



@end
