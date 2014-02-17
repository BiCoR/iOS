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
    _birthdayID = -1;
    _mailID = -1;
    _landlinePhoneID = -1;
    _mobilePhoneID = -1;
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
    _birthdayID = 0;
    if (![_contactData.mail isEqualToString:@""])
    {
        _mailID = counter;
        counter++;
    }
    if (![_contactData.phoneLandline isEqualToString:@""])
    {
        _landlinePhoneID = counter;
        counter++;
    }
    if (![_contactData.phoneMobile isEqualToString:@""])
    {
        _mobilePhoneID = counter;
        counter++;
    }

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
    UITableViewCell *cell;
    
    
    if (indexPath.row == _birthdayID) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
        ((DataCell *) cell).mainTextLabel.text = @"1.1.2010";
        ((DataCell *) cell).titleLabel.text = NSLocalizedString(@"Birthday", nil);
    }
    else if (indexPath.row == _mailID)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataCellMail" forIndexPath:indexPath];
        ((DataCell *) cell).mainTextLabel.text = _contactData.mail;
        ((DataCell *) cell).titleLabel.text = NSLocalizedString(@"Mail", nil);
    }
    else if (indexPath.row == _landlinePhoneID)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataCellPhone" forIndexPath:indexPath];
        ((DataCell *) cell).mainTextLabel.text = _contactData.phoneLandline;
        ((DataCell *) cell).titleLabel.text = NSLocalizedString(@"Landline Phone", nil);
    }
    else if (indexPath.row == _mobilePhoneID)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataCellPhone" forIndexPath:indexPath];
        ((DataCell *) cell).mainTextLabel.text = _contactData.phoneMobile;
        ((DataCell *) cell).titleLabel.text = NSLocalizedString(@"Mobile Phone", nil);
    }
    
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
