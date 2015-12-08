//
//  ParentLoginViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "GetDetailCommonView.h"

@interface ParentLoginViewController : UIViewController
{
    NSMutableData*webData;
    NSString*emailStr;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    GetDetailCommonView*getDetailView;
    NSString*passordStr;
}
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;

- (IBAction)loginActionBtn:(id)sender;
- (IBAction)forgotPasswordActionBtn:(id)sender;
- (IBAction)MenuBtn:(id)sender;

@end
