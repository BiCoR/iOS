//
//  MainViewController.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 09.01.14.
//  Copyright (c) 2014 Markus Hinkelmann. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

/**
 Called when view is loaded from the nib
 @param style: style of the UITableview,
 */
- (void)awakeFromNib
{
     _model = [NSMutableArray arrayWithObjects:@"Max Mustermann", @"Maxi Musterfrau", nil];
}

/**
 Callend when view is loaded
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 Called if the view recive a memory warning
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
 Returns the number of sections in the table
 In this application 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Returns the number rows in the current section
 In this app the size of the array
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.count;
}

/**
 Functions the customize the table view cell ...
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_model objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"01.01.2000";
    
    
    return cell;
}

/////////////////////////
//Navigation Functions//
///////////////////////

/**
 Function called, before the seque is called
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
