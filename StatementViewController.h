//
//  StatementViewController.h
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 17/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "ParentList.h"
#import "ASIHTTPRequest.h"

@interface StatementViewController : UIViewController
{
    IBOutlet UIButton *btnSelectEndTime;
    IBOutlet UIButton *btnSelectStartTime;
    IBOutlet UIDatePicker *dateTimePicker;
    IBOutlet UILabel *lblEndTime;
    IBOutlet UILabel *lblStartTime;
    NSString *getDate,*dateSelected;
    IBOutlet UIView *pickerbackView;
    IBOutlet UILabel *lblSelectparent;
    IBOutlet UITableView *tableview;
     NSString *documentsDir, *dbPath,*selected_parent_id,*tutor_id,*ifaccepted,*parent_name;
     NSArray *docPaths;
     FMDatabase *database;
    NSMutableArray*parentListArray;
    NSMutableData *webData;
    NSMutableArray *statement_data;
    IBOutlet UIButton *btnGenerateStatement;
}
- (IBAction)btnBack:(id)sender;
- (IBAction)btnGenerateStatement:(id)sender;
- (IBAction)btnSelectParent:(id)sender;
- (IBAction)btnSelectEndTime:(id)sender;
- (IBAction)btnSelectStartTime:(id)sender;
- (IBAction)cancelDateView:(id)sender;
- (IBAction)doneDateView:(id)sender;
@property(strong,nonatomic) ParentList*parentListObj;
@end
