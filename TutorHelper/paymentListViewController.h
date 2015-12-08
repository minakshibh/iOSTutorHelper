//
//  paymentListViewController.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "paymentListOC.h"

@interface paymentListViewController : UIViewController
{
    NSMutableData* webData;
    paymentListOC* paymentObj;
    NSMutableArray * paymentArray,*savDataArray,*orderIdtempArray;
    IBOutlet UITableView *paymentTableView;
    IBOutlet UILabel *titleLbl;
    IBOutlet UIImageView *addbtnImg;
    IBOutlet UIButton *addbtn;
    IBOutlet UITextField *searchTutorTxt;
    IBOutlet UIImageView *searchImg;
    NSString *parentIdStr;
    IBOutlet UILabel *totalCreditLbl;
    __weak IBOutlet UILabel *creditLbl;
}
@property (strong, nonatomic) NSString *parentId;
@property(strong,nonatomic) NSString *paymentType;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)paymentBtnAction:(id)sender;
@end
