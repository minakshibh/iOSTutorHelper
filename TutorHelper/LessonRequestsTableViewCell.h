//
//  LessonRequestsTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 17/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonRequestsTableViewCell : UITableViewCell
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
    IBOutlet UILabel *datelbl;
    IBOutlet UILabel *durationLbl;

}
-(void)setLabelText:(NSString*)messageStr :(NSString*)detailStr :(NSString*) feesStr :(NSString*)timeStr :(NSString*)DaysStr  :(NSString*)DatesStr  :(NSString*)DurationStr;
@end
