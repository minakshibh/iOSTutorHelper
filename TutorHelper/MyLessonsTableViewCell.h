//
//  MyLessonsTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 17/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLessonsTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *sundayLbl;
    IBOutlet UILabel *satLbl;
    IBOutlet UILabel *friLbl;
    IBOutlet UILabel *thurLbl;
    IBOutlet UILabel *WEDLBL;
    IBOutlet UILabel *TuesLbl;
    IBOutlet UILabel *monLbl;
    IBOutlet UILabel *descripTionLbl;
    IBOutlet UIImageView *backImgView;
    IBOutlet UILabel *durationLbl;
    IBOutlet UILabel *approvedStatusLbl;
    IBOutlet UILabel *numbrStudLbl;
    IBOutlet UILabel *studentsTxt;
    IBOutlet UILabel *rejected_by;
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *contentView;
}
-(void)setLabelText:(NSString*)detailStr :(NSString*)timeStr :(NSString*)DaysStr :(NSString*)students :(NSString*)duration :(NSString*)trigger:(NSString*)isApproved :(NSString*)rejected_by;
@end
