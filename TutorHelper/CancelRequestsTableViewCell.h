//
//  CancelRequestsTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelRequestsTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *feesbl;
    IBOutlet UILabel *sundayLbl;
    IBOutlet UILabel *satLbl;
    IBOutlet UILabel *friLbl;
    IBOutlet UILabel *thurLbl;
    IBOutlet UILabel *WEDLBL;
    IBOutlet UILabel *TuesLbl;
    IBOutlet UILabel *monLbl;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *descripTionLbl;
    IBOutlet UIImageView *backImgView;
    
    IBOutlet UITextView *reasonLbl;
}
-(void)setLabelText:(NSString*)messageStr :(NSString*)detailStr :(NSString*) feesStr :(NSString*)timeStr :(NSString*)DaysStr :(NSString*)reasonStr;

@end
