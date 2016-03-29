//
//  ParentListViewController.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ParentList.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GetDetailCommonView.h"

@interface ParentListViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    GetDetailCommonView*getDetailView;
    NSMutableData*webData;
    IBOutlet UILabel *headerLbl;

    IBOutlet UITableView *parentsListTableView;
    NSMutableArray*parentListArray;
    ParentList*parentListObj;
    IBOutlet UITextField *searchTxt;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *filterLbl;
    BOOL isActivSTudentFilter;
    BOOL isBalaceFilter;
    BOOL sortByName;
    BOOL sortByLessons;
    BOOL sortByBalance;

    IBOutlet UIImageView *cancelFilterCrossImg;
 
    IBOutlet UIImageView *cancelSortCrossImg;
    NSMutableArray *ParentIDTempArray,*savDataArray ,*savDataBalanceArray,*savDataStudentsArray;
    NSMutableArray *activestudentsArray,*outStandingBalancArray;

    IBOutlet UILabel *sortBylbl;
    IBOutlet UIView *filterBackView;
    IBOutlet UIView *sortBackView;
    
    IBOutlet UIButton *cancelSortBttn;
    
    IBOutlet UIButton *cancelFilterBttn;
}

@property(strong,nonatomic) NSString*trigger;

- (IBAction)sortByActionBtn:(id)sender;
- (IBAction)filterActionBtn:(id)sender;
- (IBAction)MenuBtn:(id)sender;
- (IBAction)sortByNameBttn:(id)sender;
- (IBAction)sortByUpcomingBttn:(id)sender;
- (IBAction)sortByBalanceBtn:(id)sender;
- (IBAction)filterActiveStudentsBttn:(id)sender;
- (IBAction)filterOfBalanceBttn:(id)sender;
- (IBAction)cancelSortBttn:(id)sender;
- (IBAction)cancelFilterBttn:(id)sender;

@end
