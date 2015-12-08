//
//  TutorRegistrationViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDetailCommonView.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
@interface TutorRegistrationViewController : UIViewController<UIScrollViewDelegate>
{
    GetDetailCommonView*getDetailView;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*passwordStr;
    
    IBOutlet UIButton *editBttn;
    IBOutlet UITextField *emailAddressTxt;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UITextField *confirmPasswordTxt;
    IBOutlet UITextField *phoneNumberTxt;
    IBOutlet UITextField *alternatePhoneNumTxt;
    IBOutlet UITextField *addressTxt;
    IBOutlet UIButton *registerBtn;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *femateBtn;
    IBOutlet UIButton *maleBtn;
    NSMutableData*webData;
    NSString*gender,*tutorIdStr;
    NSString*parentIdStr;

    IBOutlet UILabel *phoneCountryCodeTxt;
    IBOutlet UILabel *alternateCountryCodeTxt;
    IBOutlet UIImageView *maleImageView;
    IBOutlet UIImageView *femaleImageView;
    IBOutlet UIImageView *confirmPassIcon;
    IBOutlet UIImageView *confirmPassBackImg;
    
}
@property (strong,nonatomic)NSString*trigger,*editView;
- (IBAction)editBttn:(id)sender;

- (IBAction)MenuBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;
- (IBAction)MaleBtn:(id)sender;
- (IBAction)FemaleBtn:(id)sender;

@end
