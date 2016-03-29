//
//  ParentMergeViewController.h
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentMergeViewController : UIViewController
{
    IBOutlet UIView *backView;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UIView *passwordBackView;
    IBOutlet UITextField *parentIdTxt;
    int webservice;
    NSMutableData*webData;

}
- (IBAction)mergeBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
- (IBAction)doneBttn:(id)sender;

@end
