//
//  newsFeedTableViewCell.m
//  TutorHelper
//
//  Created by Sahil Dhiman on 6/25/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "newsFeedTableViewCell.h"

@implementation newsFeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) fetchData:(newsFeedObj*) newsFeedOC{
    bgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    bgLbl.layer.borderWidth=2.0f;
    bgLbl.layer.cornerRadius=5.0;
    bgLbl.clipsToBounds = YES;
    bgLbl.layer.masksToBounds = YES;
    newsLbl.text = [NSString stringWithFormat:@"%@",newsFeedOC.message];
   
    NSDate *todaysDate;
    todaysDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDate = [ dateFormat stringFromDate:todaysDate];
    todaysDate = [dateFormat dateFromString:currentDate];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSString *timeFrom = [NSString stringWithFormat:@"%@",newsFeedOC.last_updated];
    NSArray* dateFromArray = [timeFrom componentsSeparatedByString: @" "];
    NSString *dateToSelect =[NSString stringWithFormat:@"%@",[dateFromArray objectAtIndex:0]];
    NSArray *dateComponentsArray = [dateToSelect componentsSeparatedByString:@"-"];
    int yearValue = [[dateComponentsArray objectAtIndex:0]intValue];
    
    int monthValue = [[dateComponentsArray objectAtIndex:1]intValue];
    
    int dateValue = [[dateComponentsArray objectAtIndex:2]intValue];
    
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:monthValue];
    [dateParts setYear:yearValue];
    [dateParts setDay:dateValue];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    NSString *serviceDateTime;
    
    if ([todaysDate compare:dateOnFirst] == NSOrderedSame) {
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *serviceTime = [dateFormat1 dateFromString:newsFeedOC.last_updated];
        [dateFormat1 setDateFormat:@"HH:mm:ss"];
        serviceDateTime = [dateFormat1 stringFromDate:serviceTime];
    }else{
        //        NSDate *serviceTime = [dateFormat1 dateFromString:dateOnFirst];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"dd MMM"];
        serviceDateTime = [dateFormat1 stringFromDate:dateOnFirst];
        NSLog(@"Service time ..... %@",serviceDateTime);
    }
    dateLbl.text = [NSString stringWithFormat:@"%@",serviceDateTime];
    [newsLbl scrollRangeToVisible:NSMakeRange(0, 1)];
}

@end
