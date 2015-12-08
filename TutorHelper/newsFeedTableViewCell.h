//
//  newsFeedTableViewCell.h
//  TutorHelper
//
//  Created by Sahil Dhiman on 6/25/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsFeedObj.h"
@interface newsFeedTableViewCell : UITableViewCell
{
    IBOutlet UILabel *bgLbl;
    NSCalendar *calendar;
    IBOutlet UILabel *dateLbl;
    IBOutlet UITextView *newsLbl;

}
-(void) fetchData:(newsFeedObj*) newsFeedOC;
@end
