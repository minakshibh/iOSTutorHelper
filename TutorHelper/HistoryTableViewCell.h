//
//  HistoryTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryList.h"

@interface HistoryTableViewCell : UITableViewCell
{
    IBOutlet UILabel *monthLbl;
    IBOutlet UILabel *lessonsLbl;
    IBOutlet UILabel *balanceLbl;
    IBOutlet UILabel *feesCollectedlbl;
    IBOutlet UILabel *feesDueLbl;
    IBOutlet UILabel *yearLbl;
    IBOutlet UIImageView *backImgView;
    NSString *yearNameStr;
    IBOutlet UILabel *feesdueTitle;
    IBOutlet UILabel *feescollectedtitle;
    IBOutlet UILabel *outstandingBalanceTitle;
    IBOutlet UILabel *numberoflessonsTitle;
    IBOutlet UILabel *outstandingFeesLbl;
    
    IBOutlet UILabel *outStandBlncTittle;
}

-(void)setLabelText :(NSString*)monthStr :(NSString*)lessons :(NSString*)balance :(NSString*)feesCollected :(NSString*)feesDue :(NSString*)year :(NSString*)feesOutstanding;


-(void) sethistoryObj: (HistoryList*)historyObj :(BOOL)isByParent;
@end
