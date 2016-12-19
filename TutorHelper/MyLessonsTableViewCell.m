//
//  MyLessonsTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 17/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MyLessonsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyLessonsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)detailStr :(NSString*)timeStr :(NSString*)DaysStr :(NSString*)students :(NSString*)duration :(NSString*)trigger:(NSString*)isApproved :(NSString*)rejected_bytext
{
    
    descripTionLbl.text=detailStr;
    timeLbl.text=timeStr;
    durationLbl.text=duration;
    
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    [contentView bringSubviewToFront:backgroundView];
    
    
    
    if ([rejected_bytext rangeOfString:@"Rejected"].location != NSNotFound){
        rejected_by.hidden = false;
        rejected_by.text = rejected_bytext;
        backgroundView.frame = CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, backgroundView.frame.size.height);
//        [self.backgroundView sendSubviewToBack:backImgView];
    }
        
    if ([trigger isEqualToString:@"History"]) {
        studentsTxt.text=[NSString stringWithFormat:@"%@",students];
        numbrStudLbl.text=@"Date:";
        studentsTxt.frame=CGRectMake(studentsTxt.frame.origin.x-50, studentsTxt.frame.origin.y, studentsTxt.frame.size.width,  studentsTxt.frame.size.height);
    }
    else
    {
        if ( [students isEqualToString:@"0"] || [students isEqualToString:@"1"]) {
            studentsTxt.text=[NSString stringWithFormat:@"%@ Student",students];
        }
        else{
            studentsTxt.text=[NSString stringWithFormat:@"%@ Students",students];
        }
    }
    
    NSArray *daysArray = [DaysStr componentsSeparatedByString:@","];
    for (int k=0; k<daysArray.count; k++)
    {
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Monday"])
        {
            monLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Tuesday"])
        {
            TuesLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Wednesday"])
        {
            WEDLBL.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Thursday"])
        {
            thurLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Friday"])
        {
            friLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Saturday"])
        {
            satLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Sunday"])
        {
            sundayLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
    }
    if ([isApproved isEqualToString:@"false"]) {
        approvedStatusLbl.hidden = NO;
    }else{
        approvedStatusLbl.hidden = YES;
    }
}
@end
