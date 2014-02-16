//
//  DataCellMail.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataCellMail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//Actions

/**
 Called when the Button "call" is clicked
 */
- (IBAction)mailButtonPressed:(id)sender;

@end
