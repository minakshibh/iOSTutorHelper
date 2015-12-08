//
//  StudentLessonDetailTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentLessonDetailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation StudentLessonDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLabelText:(NSString*)studentName :(NSString*)emailAddrss :(NSString*)contact :(NSString*)address : (NSString*)fees
{
    
    studBgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    studBgLbl.layer.borderWidth=2.0f;
    studBgLbl.layer.cornerRadius=5.0;
    studBgLbl.clipsToBounds = YES;
    studBgLbl.layer.masksToBounds = YES;
    studentNameLbl.text=studentName;
    emailLbl.text=[NSString stringWithFormat:@": %@",emailAddrss];
    contctLbl.text=[NSString stringWithFormat:@": %@",contact];
    addressLbl.text=[NSString stringWithFormat:@": %@",address];
    feesLbl.text = [NSString stringWithFormat:@": $ %@",fees];
    
}

@end
