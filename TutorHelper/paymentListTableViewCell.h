//
//  paymentListTableViewCell.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paymentListTableViewCell : UITableViewCell
{
    IBOutlet UILabel *priceLbl;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *bgLbl;
    
}
-(void)setLabelText:(NSString*)price :(NSString*)name :(NSString*)date;
@end
