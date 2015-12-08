//
//  AddNewParentViewController.h
//  TutorHelper
//
//  Created by Br@R on 24/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewParentViewController : UIViewController
{
    
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *contactTxt;
    IBOutlet UITextField *addressTxt;
    IBOutlet UIButton *maleBtn;
    IBOutlet UIButton *femaleBtn;
    NSString*gender;
    IBOutlet UILabel *countryCodetxt;
    IBOutlet UIImageView *maleImageView;
    IBOutlet UIImageView *femaleImageView;
}
- (IBAction)doneBtn:(id)sender;
- (IBAction)maleBtn:(id)sender;
- (IBAction)femaleBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@end
