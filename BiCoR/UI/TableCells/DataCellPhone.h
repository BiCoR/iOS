//
//  DataCellPhone.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Released under the GNU General Public License v2
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
