//
//  AddStudentViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "ParentList.h"
#import "StudentList.h"

@interface AddStudentViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableData*webData;
    int webservice;
    NSString *_postData;
    NSMutableURLRequest *request;
    IBOutlet UIView *parentInfoBackView;
    UITapGestureRecognizer *tap;
    IBOutlet UILabel *parentIdLbl;
    IBOutlet UILabel *genderLbl;
    IBOutlet UILabel *notesLbl;
    IBOutlet UIScrollView *backScrollView;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UILabel *contactNubrLbl;
    IBOutlet UILabel *selectParentLbl;
    IBOutlet UILabel *emailAddresslbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *contactTxt;
    IBOutlet UITextField *feesTxt;
    IBOutlet UITableView *parntListTableView;
    NSMutableArray*parentListArray;
    IBOutlet UITextField *enterParentIdTxt;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*parentIdStr;
    IBOutlet UIView *BackView;
    NSString*tutor_id;
    NSString*gender;
    IBOutlet UIButton *maleBtn;
    IBOutlet UIButton *femaleBtn;
    
    IBOutlet UIButton *addStudentBttn;
    IBOutlet UIImageView *maleImageView;
    IBOutlet UIImageView *femaleImageView;
    IBOutlet UIView*addStudentBackView;
    IBOutlet UITextView *noteTxtView;
    IBOutlet UITextField *addressTxt;
    
    IBOutlet UIImageView *addressIconImg;
    IBOutlet UIImageView *feesIconImg;
}

@property(strong,nonatomic)NSDictionary *parentDetailDict;
@property(strong,nonatomic) NSString* trigger,*fromView;
@property(strong,nonatomic) NSString*triggervalue;
@property(strong,nonatomic) ParentList*parentListObj;
@property(strong,nonatomic) StudentList*studentListObj;


- (IBAction)sameAsParentBttn:(id)sender;
- (IBAction)MenuBtn:(id)sender;
- (IBAction)addStudentBtn:(id)sender;
- (IBAction)addNewParentBtn:(id)sender;
- (IBAction)showParentListBtn:(id)sender;
- (IBAction)femaleBtn:(id)sender;
- (IBAction)maleBtn:(id)sender;

@end
