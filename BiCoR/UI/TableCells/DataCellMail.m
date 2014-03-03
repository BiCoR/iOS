//
//  DataCellMail.m
//  BiCoR
//
//  Created by Markus Hinkelmann on 16.02.14.
//  Released under the GNU General Public License v2
//

#import "DataCellMail.h"
#import "PersonDetailsViewController.h"

@implementation DataCellMail

/**
 Called when the Button "call" is clicked
 */
- (IBAction)mailButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setToRecipients:[NSArray arrayWithObject:_mainTextLabel.text]];
        
        _superViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [_superViewController presentViewController:mailViewController animated:YES completion:nil];
        
    }
}

/**
 Function called, when the Mail View is closed
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [_superViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
