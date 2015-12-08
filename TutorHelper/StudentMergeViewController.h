//
//  StudentMergeViewController.h
//  TutorHelper
//
//  Created by Br@R on 20/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "GetDetailCommonView.h"
@interface StudentMergeViewController : UIViewController
{
    
    IBOutlet UITextField *firstDtudentIdTxt;
    IBOutlet UITextField *secndStudentIdTxt;
    IBOutlet UIView *backView;
    int webservice;
    NSMutableData*webData;
    GetDetailCommonView*getDetailView;


    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;

}

- (IBAction)mergeActionBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
@end
