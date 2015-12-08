//
//  StudentRequestsTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 13/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentRequestsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation StudentRequestsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr :(NSString*) feesStr :(NSString*)emailStr :(NSString*)contactStr {
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    
    idLbl.text=sendrIdStr;
    nameLbl.text=senderNameStr;
    feesLbl.text=feesStr;
    emailLbl.text=emailStr;
    contactLbl.text=contactStr;
}
@end
