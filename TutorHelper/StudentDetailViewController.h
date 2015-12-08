//
//  StudentDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentList.h"
#import "ParentList.h"
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface StudentDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    IBOutlet UILabel *feeStaticLbl;
    IBOutlet UIImageView *histryImg;
    IBOutlet UIButton *editBttn;
    IBOutlet UILabel *histryLbl;
    IBOutlet UIButton *historyBtn;
    IBOutlet UIView *backView;
    IBOutlet UILabel *headrLbl;
    IBOutlet UILabel *studentNameLbl;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UILabel *emailAddressLbl;
    IBOutlet UILabel *feeDotsLbl;
    
    IBOutlet UILabel *notes;
    IBOutlet UILabel *studentIdLbl;
    IBOutlet UILabel *feesLbl;
    IBOutlet UILabel *contactNumbrLbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UITextView *notesLbl;
}
- (IBAction)editBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
- (IBAction)emailBttn:(id)sender;
- (IBAction)callBttn:(id)sender;
- (IBAction)historyBttn:(id)sender;

@property (strong, nonatomic) StudentList*StudentObj;
@property (strong, nonatomic) ParentList*parentObj;
@property (assign, nonatomic) BOOL editBtnHiddn;

@end
