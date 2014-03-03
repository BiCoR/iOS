//
//  DataCell.h
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Released under the GNU General Public License v2
//

#import <UIKit/UIKit.h>

@interface DataCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;

@end
