//
//  lessonDetailsViewController.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lessonDetailsOC.h"
#import "StudentList.h"
@interface lessonDetailsViewController : UIViewController
{
    
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UILabel *recuringLbl;
    IBOutlet UILabel *endDateLbl;
    IBOutlet UILabel *startDateLbl;
    IBOutlet UILabel *durationLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *tutornameLbl;
    NSArray*studentListArray;
    IBOutlet UILabel *numberOfStudentsLbl;
    
    IBOutlet UILabel *detailBgLbl;
    IBOutlet UITableView *studentTableView;
    NSMutableData *webData;
    NSString *Session_Dates;
    int webservice;
}
- (IBAction)btnGenerateReport:(id)sender;
- (IBAction)backBttn:(id)sender;
- (IBAction)updateNotesBtn:(id)sender;
@property(strong,nonatomic)lessonDetailsOC*lessondetailObj;
@property(strong,nonatomic)NSString*lessonDetailView,*date_selected,*selected_id;
@end
