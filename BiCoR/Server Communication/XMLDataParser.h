//
//  XMLDataParser.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 13.01.14.
//  Released under the GNU General Public License v2
//

#import <Foundation/Foundation.h>

@interface XMLDataParser : NSObject <NSXMLParserDelegate>

///////////////
//Properties//
/////////////

@property (copy) NSMutableArray *dataArray;
@property NSString *currentElement;
@property NSMutableString *savedCharecters;
@property NSError *error;


@end
