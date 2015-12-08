//
//  lessonDetailTableViewCell.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "lessonDetailTableViewCell.h"

@implementation lessonDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)dscp :(NSString*)tutorName :(NSString*)lessonName :(NSString*)feesDue :(NSString*)numberOfStudents{
    bgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    bgLbl.layer.borderWidth=2.0f;
    bgLbl.layer.cornerRadius=5.0;
    
    bgLbl.clipsToBounds = YES;
    bgLbl.layer.masksToBounds = YES;
    descp.text = [NSString stringWithFormat:@"%@",dscp];
    tutorNamelbl.text = [NSString stringWithFormat:@": %@",tutorName];
    lessonNameLbl.text = [NSString stringWithFormat:@": %@",lessonName];
    numberOfStudentsLbl.text = [NSString stringWithFormat:@": %@",numberOfStudents];
    durationLbl.text = [NSString stringWithFormat:@": %@",feesDue];
}
@end
