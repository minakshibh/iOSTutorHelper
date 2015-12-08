//
//  MyLessonsViewController.h
//  TutorHelper
//
//  Created by Br@R on 14/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lessons.h"

@interface MyLessonsViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;
    NSString*_postData;
    
    IBOutlet UITextView *reasonTxtView;
    IBOutlet UILabel *histryUpprLbl;
     Lessons *lessObj;
    IBOutlet UIView *reasonBackView;
    IBOutlet UITableView *lessonsTableView;
    IBOutlet UILabel *headrLbl;
}
- (IBAction)backBttn:(id)sender;
@property (strong, nonatomic) Lessons*lessonObj;
@property (strong, nonatomic)  NSMutableArray*lessonsListArray;
- (IBAction)cancelBttn:(id)sender;
- (IBAction)doneBttn:(id)sender;

@property (strong ,nonatomic) NSString*trigger,*dateDetail,*studentIdStr;

@end
