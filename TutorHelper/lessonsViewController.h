//
//  lessonsViewController.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lessonDetailsOC.h"
@interface lessonsViewController : UIViewController
{
    NSMutableData* webData;
    lessonDetailsOC *lessonDetailsObj;
    NSMutableArray *lessonsArray,*studentListArray;
    IBOutlet UITableView *lessonTableView;
    int webservice;
}


- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) NSString *lessonId,*date;
@property (strong, nonatomic) NSString *feesDue;
@end
