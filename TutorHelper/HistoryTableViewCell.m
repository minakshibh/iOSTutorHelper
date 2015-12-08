//
//  HistoryTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)monthStr :(NSString*)lessons :(NSString*)balance :(NSString*)feesCollected :(NSString*)feesDue :(NSString*)year  :(NSString*)feesOutstanding

{
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@",year];
    if ([yearNameStr isEqualToString:str]) {
        yearLbl.hidden = YES;
        
    }else{
        yearLbl.hidden = NO;
    }
    yearNameStr = [NSString stringWithFormat:@"%@",year];
    
    
    monthLbl.text=monthStr;
    lessonsLbl.text=[NSString stringWithFormat:@": %@",lessons];
    balanceLbl.text=[NSString stringWithFormat:@": %@",balance];
    feesCollectedlbl.text=[NSString stringWithFormat:@": $%@",feesCollected];
    feesDueLbl.text=[NSString stringWithFormat:@": $%@",feesDue];
    yearLbl.text = [NSString stringWithFormat:@"%@",year];
}

-(void) sethistoryObj: (HistoryList*)historyObj :(BOOL)isByParent{
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    if (isByParent || ![historyObj.lesson_ids isEqualToString:@"-1"]) {
        yearLbl.hidden = YES;
        numberoflessonsTitle.hidden= NO;
        outstandingBalanceTitle.hidden=NO;
        feescollectedtitle.hidden=NO;
        feesdueTitle.hidden=NO;
        monthLbl.hidden = NO;
        lessonsLbl.hidden = NO;
        balanceLbl.hidden = NO;
        feesCollectedlbl.hidden = NO;
        feesDueLbl.hidden = NO;
        backImgView.hidden = NO;
        
        outStandBlncTittle.hidden = NO;
        outstandingFeesLbl.hidden = NO;
    }else{
        yearLbl.hidden = NO;
        numberoflessonsTitle.hidden= YES;
        outstandingBalanceTitle.hidden=YES;
        feescollectedtitle.hidden=YES;
        feesdueTitle.hidden=YES;
        monthLbl.hidden = YES;
        lessonsLbl.hidden = YES;
        balanceLbl.hidden = YES;
        feesCollectedlbl.hidden = YES;
        feesDueLbl.hidden = YES;
        backImgView.hidden = YES;
        outStandBlncTittle.hidden = YES;
        outstandingFeesLbl.hidden = YES;
    }
    
    monthLbl.text=[NSString stringWithFormat:@"%@",historyObj.monthName];
    lessonsLbl.text=[NSString stringWithFormat:@": %@",historyObj.numbrOfLessons];
    balanceLbl.text=[NSString stringWithFormat:@": $%@",historyObj.outstanding_balance];
    feesCollectedlbl.text=[NSString stringWithFormat:@": $%@",historyObj.feesColllected];
    feesDueLbl.text=[NSString stringWithFormat:@": $%@",historyObj.feesDue];
    yearLbl.text = [NSString stringWithFormat:@"%@",historyObj.yearName];
    outstandingFeesLbl.text = [NSString stringWithFormat:@": $%@",historyObj.outstandingFees];

}
@end
