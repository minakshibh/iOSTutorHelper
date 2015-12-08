//
//  StudentDetailTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentDetailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation StudentDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)studentName :(NSString*)emailAddrss :(NSString*)contact :(NSString*)notes
{
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    
    studentNameLbl.text=studentName;
    emailAddressLbl.text=[NSString stringWithFormat:@"%@",emailAddrss];
    contactNumberLbl.text=[NSString stringWithFormat:@"%@",contact];
    notesLbl.text=[NSString stringWithFormat:@"%@",notes];

}
@end
