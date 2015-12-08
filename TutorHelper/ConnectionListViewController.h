//
//  ConnectionListViewController.h
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "ConnectRequset.h"

@interface ConnectionListViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;
    NSMutableArray *connectionRequestListArray;
    ConnectRequset*connctListObj;
    IBOutlet UITableView *requestTableView;
  //  NSString *_postData;

}
- (IBAction)BackBtn:(id)sender;
@property(strong, nonatomic)  NSString*trigger;

@end
