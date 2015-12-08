//
//  ParentDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentList.h"
#import "StudentList.h"
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface ParentDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSMutableData*webData;
    int webservice;
    NSString *_postData;
    NSMutableURLRequest *request;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;

    IBOutlet UILabel *parenyIdLbl;
    IBOutlet UIView *parentInfoBackView;
    IBOutlet UILabel *emailAddressLbl;
    IBOutlet UILabel *contactNubrLbl;
    IBOutlet UILabel *numbrOfStudntsLbl;
    IBOutlet UILabel *outstandingBalanceLbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UILabel *headerLbl;
    IBOutlet UITableView *studentTableView;
    IBOutlet UITextView *notesTxtView;
    NSMutableArray *studentListArray;
    StudentList*studentListObj;
}

@property(strong,nonatomic) NSString*trigger;

@property(strong,nonatomic)ParentList*parentObj;
- (IBAction)updateBtn:(id)sender;
- (IBAction)addStudentBtn:(id)sender;
- (IBAction)historyBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)callActionBtn:(id)sender;
- (IBAction)emailActionBtn:(id)sender;

@end
