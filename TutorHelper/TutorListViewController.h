//
//  TutorListViewController.h
//  TutorHelper
//
//  Created by Br@R on 23/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorListViewController : UIViewController
{
    
    IBOutlet UITableView *tutorListTableView;
    NSMutableArray*tutorListArray;
    NSMutableData*webData;
    IBOutlet UILabel *feesDueLbl;
    IBOutlet UILabel *feesCollectedLbl;
    IBOutlet UILabel *feesOutstandingLbl;
    IBOutlet UILabel *outstandingBalanceLbl;
    IBOutlet UIView *feesDuePopUp;
    IBOutlet UIView *feesDueBackGroudView;
}
- (IBAction)backBttn:(id)sender;
- (IBAction)DoneBtnAction:(id)sender;

@end
