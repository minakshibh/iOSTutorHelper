//
//  ParentListTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentListTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ParentListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)parentName :(NSString*)Students :(NSString*)balance :(NSString*)lessons
{
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    
    

    
    parentNameLbl.text=parentName;
    NumbrOfStudntsLbl.text=[NSString stringWithFormat:@": %@",Students];
    balanceLbl.text=[NSString stringWithFormat:@": $%@",balance];
    lessonsLbl.text=[NSString stringWithFormat:@": %@",lessons];

}
@end
