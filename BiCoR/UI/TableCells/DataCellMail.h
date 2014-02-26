//
//  DataCellMail.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class PersonDetailsViewController;

@interface DataCellMail : UITableViewCell <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak) PersonDetailsViewController *superViewController;

//Actions

/**
 Called when the Button "call" is clicked
 */
- (IBAction)mailButtonPressed:(id)sender;

@end
