//
//  lessonDetailTableViewCell.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lessonDetailTableViewCell : UITableViewCell
{
    IBOutlet UILabel *descp;
    IBOutlet UILabel *tutorNamelbl;
    IBOutlet UILabel *lessonNameLbl;
    IBOutlet UILabel *feesDueDate;
    IBOutlet UILabel *numberOfStudentsLbl;
    IBOutlet UILabel *bgLbl;
    IBOutlet UILabel *durationLbl;
    
}
-(void)setLabelText:(NSString*)dscp :(NSString*)tutorName :(NSString*)lessonName :(NSString*)feesDue :(NSString*)numberOfStudents;
@end
