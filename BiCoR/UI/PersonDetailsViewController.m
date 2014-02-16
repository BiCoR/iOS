//
//  PersonDetailsViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 15.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "PersonDetailsViewController.h"

@implementation PersonDetailsViewController

@synthesize contactData = _contactData;

/**
 Function called, when the UI is loaded from the Storyboard file
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
}

/**
 Function called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 Function called, when the view controller receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Function to set the Contact Data
 Analyse the entered data and prepars the table
 */
- (void)setContactData:(Contact *)contactData
{
    _contactData = contactData;
    int counter = 1;
    if (_contactData.birthDate != nil)
        counter++;
    else if (_contactData.phoneLandline != nil)
        counter++;
    else if (_contactData.phoneMobile != nil)
        counter++;
    else if (_contactData.mail != nil)
        counter++;
    _numberOfRows = counter;
}

/**
 Function to return the contact data
 */
- (Contact *)contactData
{
    return _contactData;
}


/////////////////////////////////
// Settings for the table view//
///////////////////////////////

/**
 Returns the numbers of the sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/**
 Returns the numbers of rows in the section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfRows;
}


/**
 Returns the cell for the specific row
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DataCell";
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = @"Max Mustermann";
    
    return cell;
}


/**
 Returns the Header of the Cell
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    headerCell.textLabel.text = _contactData.getFullName;
    
    return headerCell;
}

/**
 Returns the height for a header Cell
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 43;
}

@end
