//
//  DataCellPhone.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Released under the GNU General Public License v2
//

#import "DataCellPhone.h"

@implementation DataCellPhone

/**
 Called when the Button "call" is clicked
 */
- (IBAction)callButtonClicked:(id)sender {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:_mainTextLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
