//
//  AddLessonViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

@interface AddLessonViewController : UIViewController<UIScrollViewDelegate>
{
    
    
    IBOutlet UIButton *mondayBtn;
    IBOutlet UIButton *tuesDayBtn;
    IBOutlet UIButton *wednesdayBtn;
    IBOutlet UIButton *thursdayBtn;
    IBOutlet UIButton *fridayBtn;
    IBOutlet UIButton *sundayBtn;
    IBOutlet UIButton *saturdayBtn;
    
    int count;
    IBOutlet UILabel *daysLBL;
    NSString*_postData;
    NSString*getDate;
    NSString*dateSelected;
    NSMutableData*webData;
    
    IBOutlet UILabel *lessonNameBackView;
    IBOutlet UILabel *studentsBackView;
    
    
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    IBOutlet UIButton *cancelStudentAdBtt;
    IBOutlet UIButton *DoneSelectStudntBtn;
    IBOutlet UIImageView *backIconImg;
    NSString*is_recur;
    NSMutableArray*indexes;
    IBOutlet UILabel *startTimeLbl;
    IBOutlet UILabel *endTimeLbl;
    
    IBOutlet UILabel *startDateLbl;
    IBOutlet UILabel *endDateLbl;
    IBOutlet UIButton *backBttn;
    
    IBOutlet UILabel *numbrofStudntsSelctdLbl;
    IBOutlet UIView *pickerBackView;
    IBOutlet UITextField *topicTxt;
    IBOutlet UIButton *lessonDateBtn;
    IBOutlet UIButton *daysBtn;
    IBOutlet UIButton *endBtn;
    IBOutlet UIButton *startBtn;
    IBOutlet UITextField *descriptionTxt;
    IBOutlet UIDatePicker *dateTimePickr;
    IBOutlet UIView *daysView;
    NSMutableArray *daysArray;
    IBOutlet UIImageView *alldaysImg;
    
    IBOutlet UIImageView *mondayImg;
    IBOutlet UIButton *selectSudentBtn;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *tuesdayImg;
    IBOutlet UIImageView *wednesdayImg;
    IBOutlet UIImageView *thursdayImg;
    IBOutlet UIImageView *fridayImg;
    IBOutlet UIImageView *saturdayImg;
    IBOutlet UIImageView *sundayImg;
    IBOutlet UITableView *studentTableView;
    IBOutlet UIView *studentListBackView;
    
    IBOutlet UIButton *lessonEndDate;
    
    IBOutlet UIButton *recurngYesBtn;
    IBOutlet UIButton *recurngNobtn;
    
    NSMutableArray *tempStudentArray, *endSelectedDateArray;
    BOOL isSlotAvailable;
}
- (IBAction)addStudentBtn:(id)sender;
- (IBAction)DoneAddingStudents:(id)sender;

- (IBAction)MenuBtn:(id)sender;
- (IBAction)startTimeBttn:(id)sender;
- (IBAction)endTimeBttn:(id)sender;
- (IBAction)daysBttn:(id)sender;
- (IBAction)lessonDate:(id)sender;
- (IBAction)addLessonBttn:(id)sender;
- (IBAction)doneDateSelectionBttn:(id)sender;
- (IBAction)cancelDateSelectionBttn:(id)sender;
@property (strong ,nonatomic) NSString*trigger ,*tutorIDstr;
@property (strong ,nonatomic) NSMutableArray*studentListArray,*addStudentList;

- (IBAction)mondayBttn:(id)sender;
- (IBAction)tuesdayBttn:(id)sender;
- (IBAction)wednesdaybttn:(id)sender;
- (IBAction)thursdatBttn:(id)sender;
- (IBAction)fridayBttn:(id)sender;
- (IBAction)saturdayBttn:(id)sender;
- (IBAction)sundayBttn:(id)sender;
- (IBAction)lessonEndDate:(id)sender;
- (IBAction)recuringYesBttn:(id)sender;
- (IBAction)recuringNoBttn:(id)sender;
- (IBAction)cancelStudentAddBttn:(id)sender;

@end
