//
//  paymentListDetailViewController.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "paymentListDetailViewController.h"

@interface paymentListDetailViewController ()

@end

@implementation paymentListDetailViewController
@synthesize paymentObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.paymentType isEqualToString:@"AddCredit"]) {
        titleLbl.text = @"Credit Details";
        
    }else{
        titleLbl.text = @"Payment Details";
        
    }
    bgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    bgLbl.layer.borderWidth=2.0f;
    bgLbl.layer.cornerRadius=5.0;
    bgLbl.clipsToBounds = YES;
    bgLbl.layer.masksToBounds = YES;
    parentIdLbl.text = [NSString stringWithFormat:@": %@",paymentObj.parent_id];
    parentNameLbl.text = [NSString stringWithFormat:@": %@",paymentObj.parent_name];
    paymentMode.text = [NSString stringWithFormat:@": %@",paymentObj.payment_mode];
    tutorNameLbl.text = [NSString stringWithFormat:@": %@",paymentObj.tutor_name];
    dateLbl.text = [NSString stringWithFormat:@": %@",paymentObj.last_updated];
    remarksLbl.text = [NSString stringWithFormat:@": %@",paymentObj.remarks];
    feesPaidLbl.text = [NSString stringWithFormat:@":$ %@",paymentObj.fee_paid];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
