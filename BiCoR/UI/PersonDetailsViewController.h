//
//  PersonDetailsViewController.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 15.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "HeaderCell.h"
#import "DataCell.h"

@interface PersonDetailsViewController : UITableViewController

//Properties
@property Contact* contactData;
@property int numberOfRows;

//Functions

@end
