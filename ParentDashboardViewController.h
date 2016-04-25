
//
//  ParentDashboardViewController.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"

@interface ParentDashboardViewController : UIViewController<DDCalendarViewDelegate>
{
    DDCalendarView *calendarView;
    IBOutlet UIView *buttonsView;
    IBOutlet UILabel *userIdLbl;
    IBOutlet UILabel *userNameLbl;
     NSMutableData*webdata;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *connectionRequestCount;
    IBOutlet UILabel *studentRequestCount;
    IBOutlet UILabel *lessonRequestCount;
}
- (IBAction)btnInvoice:(id)sender;

- (IBAction)connectionBttn:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)studentRequestBttn:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)lessonRequestBttn:(id)sender;
- (IBAction)myLessons:(id)sender;
- (IBAction)addLessonBttn:(id)sender;
- (IBAction)addNewStudentBttn:(id)sender;
- (IBAction)myProfileBttn:(id)sender ;
- (IBAction)tutorListBttn:(id)sender;
- (IBAction)myStudentsList:(id)sender;
- (IBAction)ParentMerge:(id)sender;
- (IBAction)studentMerge:(id)sender;
- (IBAction)creditsBtnAction:(id)sender;
- (IBAction)payentBtnAction:(id)sender;
- (IBAction)newsFeedBtnAction:(id)sender;
@end
