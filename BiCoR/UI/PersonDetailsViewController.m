//
//  PersonDetailsViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 15.02.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "PersonDetailsViewController.h"

@implementation PersonDetailsViewController

/**
 Function called, when the UI is loaded from the Storyboard file
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"Awake from Nib");
}

/**
 Function called when the view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
}

/**
 Function called, when the view controller receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/////////////////////////////////
// Settings for the table view//
///////////////////////////////

/**
 Returns the numbers of the sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


/**
 Returns the numbers of rows in the section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
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
    
    headerCell.textLabel.text = @"Max Mustermann";
    
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
