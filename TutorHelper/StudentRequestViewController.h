//
//  StudentRequestViewController.h
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectRequset.h"

@interface StudentRequestViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;
    NSMutableArray *connectionRequestListArray;
    ConnectRequset*connctListObj;
    IBOutlet UITableView *studentRequstableView;
    NSString*_postData;
}
- (IBAction)backBtn:(id)sender;

@end
