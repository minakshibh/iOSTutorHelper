//
//  MyLessonDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lessons.h"


@interface MyLessonDetailViewController : UIViewController
{
    
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UILabel *recuringLbl;
    IBOutlet UILabel *endDateLbl;
    IBOutlet UILabel *startDateLbl;
    IBOutlet UILabel *durationLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *tutornameLbl;
    IBOutlet UILabel *monday;
    IBOutlet UILabel *tuesday;
    IBOutlet UILabel *wednesday;
    IBOutlet UILabel *thursday;
    IBOutlet UILabel *friday;
    IBOutlet UILabel *saturday;
    IBOutlet UILabel *sunday;
    IBOutlet UITextView *noteslbl;
    IBOutlet UIView *studentsBackView;
    NSArray*studentListArray;
    
    IBOutlet UILabel *detailBgLbl;
    IBOutlet UITableView *studentTableView;
}
- (IBAction)backBttn:(id)sender;
- (IBAction)updateNotesBtn:(id)sender;
@property(strong,nonatomic)Lessons*lessonObj;
@property(strong,nonatomic)NSString*lessonDetailView;
@property(strong,nonatomic)NSString*trigger;
@end
