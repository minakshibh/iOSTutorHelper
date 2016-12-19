//
//  TutorFirstViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "GetDetailCommonView.h"
#import "Lessons.h"

@interface TutorFirstViewController : UIViewController<DDCalendarViewDelegate>
{
    GetDetailCommonView*getDetailView;
    NSMutableData*webData;
    Lessons*LessonListObj;
    IBOutlet UILabel *feesDueLbl;
    IBOutlet UILabel *activeStudentsLbl;
    IBOutlet UILabel *feesCollectedLbl;
    IBOutlet UIView *buttonsView;
    IBOutlet UITableView *lessonDetailTableView;
    
    NSMutableArray*lessonDetailArray;
    
    
    IBOutlet UILabel *tutorIdLbl;
    IBOutlet UILabel *tutorNameLbl;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    DDCalendarView *calendarView;
    IBOutlet UILabel *dateLbl;

    int webservice;
    IBOutlet UIView *lessondetailBcakView;
    NSMutableData *webdata;
}
- (IBAction)button:(id)sender;
- (IBAction)myConnectionsBttn:(id)sender;
- (IBAction)addLessonActionBtn:(id)sender;
- (IBAction)addStudentACtionBtn:(id)sender;
- (IBAction)activeStudentsActionBtn:(id)sender;
- (IBAction)MenuBtn:(id)sender;
- (IBAction)requestBttn:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)lessonRequestBtn:(id)sender;
- (IBAction)myLessonsBttn:(id)sender;
- (IBAction)myProfileBttn:(id)sender;
- (IBAction)cancelLessonDetailBttn:(id)sender;
- (IBAction)cancelLessonRequestsBttn:(id)sender;
- (IBAction)feesDetailsBtnAction:(id)sender;
- (IBAction)newsFeedBtnAction:(id)sender;


@end
