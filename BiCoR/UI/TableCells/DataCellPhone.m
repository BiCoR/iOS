//
//  DataCellPhone.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
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
