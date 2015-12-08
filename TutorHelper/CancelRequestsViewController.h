//
//  CancelRequestsViewController.h
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lessons.h"

@interface CancelRequestsViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;
    NSMutableArray *cancelRequestListArray;
    IBOutlet UITableView *RequestsTableView;
}
- (IBAction)backBttn:(id)sender;
@end
