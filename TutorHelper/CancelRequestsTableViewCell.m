//
//  CancelRequestsTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "CancelRequestsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CancelRequestsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)messageStr :(NSString*)detailStr :(NSString*) feesStr :(NSString*)timeStr :(NSString*)DaysStr :(NSString*)reasonStr
{
    nameLbl.text=messageStr;
    descripTionLbl.text=detailStr;
    feesbl.text=@"";
    timeLbl.text=timeStr;
    reasonLbl.text=reasonStr;
    
    backImgView.layer.borderColor=[UIColor clearColor].CGColor;
    backImgView.layer.borderWidth=2.0f;
    backImgView.layer.cornerRadius=5.0;
    
    backImgView.clipsToBounds = YES;
    backImgView.layer.masksToBounds = YES;
    
    
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
    
}

@end
