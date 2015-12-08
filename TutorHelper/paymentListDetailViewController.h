//
//  paymentListDetailViewController.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "paymentListOC.h"
@interface paymentListDetailViewController : UIViewController
{
    IBOutlet UILabel *parentIdLbl;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UILabel *paymentMode;
    IBOutlet UILabel *tutorNameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *remarksLbl;
    IBOutlet UILabel *feesPaidLbl;
    IBOutlet UILabel *bgLbl;
    
    IBOutlet UILabel *titleLbl;
}
@property (strong, nonatomic) paymentListOC *paymentObj;
@property (strong, nonatomic) NSString *paymentType;
- (IBAction)backBtnAction:(id)sender;
@end
