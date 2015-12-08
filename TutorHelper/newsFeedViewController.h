//
//  newsFeedViewController.h
//  TutorHelper
//
//  Created by Sahil Dhiman on 6/25/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsFeedObj.h"
@interface newsFeedViewController : UIViewController
{
    NSMutableData* webData;
    IBOutlet UITableView *newsFeedTableView;
    newsFeedObj *newsFeedOC;
    NSMutableArray *newsFeedArray;
}
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) NSString *userId;
@end
