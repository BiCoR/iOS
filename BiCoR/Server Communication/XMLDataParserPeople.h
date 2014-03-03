//
//  XMLDataParserPeople.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 24.01.14.
//  Released under the GNU General Public License v2
//

#import "XMLDataParser.h"
#import "Contact.h"

extern NSString *const XML_DATA_PARSER_PEOPLE_IMAGE_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_MAIL_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_FIRST_NAME_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_BIRTH_DATE_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_LAST_NAME_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_PHONE_LANDLINE_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_PHONE_MOBILE_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_ID_TAG;
extern NSString *const XML_DATA_PARSER_PEOPLE_PERSON_TAG;

@interface XMLDataParserPeople : XMLDataParser

@property Contact *person;

@end
