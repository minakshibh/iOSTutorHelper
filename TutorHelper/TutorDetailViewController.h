//
//  TutorDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tutorList.h"
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "StudentList.h"

@interface TutorDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    
    NSArray *docPaths;
    IBOutlet UIView *detailBackView;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    
    NSMutableArray*studentListArray;
    StudentList*studentListObj;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *tutorIdLbl;
    IBOutlet UILabel *contactNumberLbl;
    IBOutlet UILabel *emailAddressLbl;
    IBOutlet UILabel *studentsLbl;
    IBOutlet UITextView *addressLbl;
    
    IBOutlet UITableView *studentsTableView;
}
@property (strong ,nonatomic) tutorList*tutorListObj;
- (IBAction)addLessonBttn:(id)sender;
- (IBAction)viewTutorCalenderBtnAction:(id)sender;

- (IBAction)backBttn:(id)sender;
- (IBAction)callBtn:(id)sender;
- (IBAction)emailBttn:(id)sender;
@end
