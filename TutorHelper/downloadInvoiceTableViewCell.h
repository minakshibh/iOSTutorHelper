//
//  downloadInvoiceTableViewCell.h
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 26/10/15.
//  Copyright © 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadInvoiceTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *lblMonth;
    IBOutlet UILabel *lblDownloadLink;
    IBOutlet UILabel *lblBackgroundLbl;
}
-(void)setLabelText:(NSString*)monthName :(NSString*)downloadLink;

@end
