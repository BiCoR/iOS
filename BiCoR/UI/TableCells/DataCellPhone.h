//
//  DataCellPhone.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataCellPhone : UITableViewCell

//Properties
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//Functions

/**
 Called when the Button "call" is clicked
 */
- (IBAction)callButtonClicked:(id)sender;

@end
