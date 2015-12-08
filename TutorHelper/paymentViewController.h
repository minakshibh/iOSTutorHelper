//
//  paymentViewController.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/9/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "ParentList.h"
#import "updateRequest.h"
@interface paymentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray*parentListArray;
    IBOutlet UITableView *parntListTableView;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UIButton *addCreditBtn;
    IBOutlet UITextField *feesTxt;
    IBOutlet UITextView *remarkTextView;
    updateRequest *updateRequestObj;
    NSString *parentId;
    IBOutlet UIScrollView *scroller;
    IBOutlet UILabel *viewTitle;
}
@property(strong,nonatomic) ParentList*parentListObj;
@property(strong,nonatomic) NSString *paymentType;
- (IBAction)selectParentBtnAction:(id)sender;
- (IBAction)addcreditBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
-(void)recivedResponce;
@end
