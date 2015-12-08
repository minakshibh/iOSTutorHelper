//
//  HistoryDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryList.h"

@interface HistoryDetailViewController : UIViewController
{
    int webserviceCode;
    HistoryList*historyListObj;
    NSMutableData* webData;
    NSMutableArray*historyListByMonthArray,*historyListByParentArray,*tempHistoryListByParentArray;
    IBOutlet UIButton *byMonthSortBtn;

    IBOutlet UIButton *byParentSortBtn;
    IBOutlet UILabel *feesCollectedLbl;
    IBOutlet UILabel *feesDueLbl;
    IBOutlet UILabel *totalOutstndngBalancLbl;
    IBOutlet UITableView *historyTableView;
    NSString*sortByStr;
    IBOutlet UIView *detailView;
    bool isByParent,isSortFiler;
    NSString *yearStr,*yearNameStr;
    IBOutlet UIButton *menuBtn;
    IBOutlet UIImageView *menuBtnImg;
    IBOutlet UIView *filterView;
    IBOutlet UIView *selectSortView;
    IBOutlet UIImageView *byNameRadioImg;
    IBOutlet UIImageView *feesCollectedRadioImg;
    IBOutlet UIImageView *outStandingRadioImg;
    IBOutlet UILabel *sortViewTitleLbl;
    IBOutlet UIButton *sortByNameBtn;
    IBOutlet UIButton *sortFeesCollectedBtn;
    IBOutlet UIButton *sortOutstandingBalanceBtn;
    IBOutlet UIButton *backBtn;
}
@property (strong,nonatomic) NSString *parentIdStr;
- (IBAction)backBtn:(id)sender;
- (IBAction)byMonthSortBtn:(id)sender;
- (IBAction)byParentSortBtn:(id)sender;
- (IBAction)menuBtnAction:(id)sender;
- (IBAction)viewByNameBtnAction:(id)sender;
- (IBAction)viewFeesCollectedBtnAction:(id)sender;
- (IBAction)viewOutStandingBtnAction:(id)sender;
- (IBAction)sortBtnAction:(id)sender;
- (IBAction)filterBtnAction:(id)sender;

- (IBAction)addCreditBtn:(id)sender;
- (IBAction)statementBtn:(id)sender;
- (IBAction)invoiceBtn:(id)sender;
- (IBAction)paymentBtn:(id)sender;
@end
