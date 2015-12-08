//
//  paymentListTableViewCell.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "paymentListTableViewCell.h"

@implementation paymentListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)price :(NSString*)name :(NSString*)date{
    bgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    bgLbl.layer.borderWidth=2.0f;
    bgLbl.layer.cornerRadius=5.0;
    bgLbl.clipsToBounds = YES;
    bgLbl.layer.masksToBounds = YES;
    priceLbl.text = [NSString stringWithFormat:@"$ %@",price];
    nameLbl.text = [NSString stringWithFormat:@"%@",name];
    dateLbl.text = [NSString stringWithFormat:@"%@",date];
}
@end
