//
//  tutorCalenderViewController.h
//  TutorHelper
//
//  Created by Krishna-Mac on 06/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"
#import "GetDetailCommonView.h"
@interface tutorCalenderViewController : UIViewController
{
    NSMutableData*webData;
    DDCalendarView *calendarView;
    GetDetailCommonView*getDetailView;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray *timeSlotsArray;
    IBOutlet UIView *timeSlotsView;
    IBOutlet UITableView *timeSlotsTableView;
    IBOutlet UILabel *timeSlotsViewBgLbl;
    IBOutlet UIButton *backBtn;
}
- (IBAction)timeSlotsViewCloseBtnAction:(id)sender;
- (IBAction)okBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) NSString *tutorId;
@end
