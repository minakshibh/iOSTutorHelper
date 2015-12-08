//
//  HistoryViewController.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryList.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
@interface HistoryViewController : UIViewController
{
    
    IBOutlet UITextField *searchTxt;
    HistoryList*historyListObj;
    NSMutableData*webData;
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray*historyListArray;
}
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSString* studentIdStr;

@end
