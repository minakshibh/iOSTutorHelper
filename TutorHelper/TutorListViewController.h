//
//  TutorListViewController.h
//  TutorHelper
//
//  Created by Br@R on 23/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorListViewController : UIViewController
{
    
    IBOutlet UITableView *tutorListTableView;
    NSMutableArray*tutorListArray;
    NSMutableData*webData;

}
- (IBAction)backBttn:(id)sender;

@end
