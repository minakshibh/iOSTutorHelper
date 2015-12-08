//
//  ForgotPasswordViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
{
    
    NSMutableData*webData;
    IBOutlet UITextField *emailAddressTxt;
}
@property (strong,nonatomic)NSString*trigger;
- (IBAction)DoneActionBtn:(id)sender;
- (IBAction)MenuBtn:(id)sender;

@end
