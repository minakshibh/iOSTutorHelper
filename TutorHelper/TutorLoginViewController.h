//
//  TutorLoginViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDetailCommonView.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
@interface TutorLoginViewController : UIViewController
{
    NSString*emailStr;
    NSString*passordStr;
    NSMutableData*webData;
    GetDetailCommonView*getDetailView;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    int webservice;
}
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
- (IBAction)loginActionBtn:(id)sender;
- (IBAction)signupActionBtn:(id)sender;
- (IBAction)forgotPasswordActionBtn:(id)sender;
- (IBAction)MenuBtn:(id)sender;

@end
