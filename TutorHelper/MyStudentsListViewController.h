//
//  MyStudentsListViewController.h
//  TutorHelper
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "StudentList.h"


@interface MyStudentsListViewController : UIViewController
{
    IBOutlet UITableView *studentsTableView;
    NSMutableData*webData;
    int webservice;
    NSString *_postData;
    NSMutableURLRequest *request;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*parentId;
    NSMutableArray*studentListArray;
    StudentList*studentListObj;

    
}
- (IBAction)backBtn:(id)sender;
@end
