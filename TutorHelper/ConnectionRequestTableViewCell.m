//
//  ConnectionRequestTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ConnectionRequestTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConnectionRequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr
{
    
    BackImgView.layer.borderColor=[UIColor clearColor].CGColor;
    BackImgView.layer.borderWidth=2.0f;
    BackImgView.layer.cornerRadius=5.0;
    BackImgView.clipsToBounds = YES;
    BackImgView.layer.masksToBounds = YES;

    sender_idlbl.text=[NSString stringWithFormat:@"%@",sendrIdStr];
    senderNamelbl.text=[NSString stringWithFormat:@"%@",senderNameStr];
}

@end
