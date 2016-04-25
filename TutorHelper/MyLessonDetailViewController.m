//
//  MyLessonDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MyLessonDetailViewController.h"
#import "StudentList.h"
#import "StudentLessonDetailTableViewCell.h"
#import "StudentDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MyLessonDetailViewController ()

@end

@implementation MyLessonDetailViewController
@synthesize lessonObj,lessonDetailView;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    
    
    detailBgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    detailBgLbl.layer.borderWidth=2.0f;
    detailBgLbl.layer.cornerRadius=5.0;
    
    detailBgLbl.clipsToBounds = YES;
    detailBgLbl.layer.masksToBounds = YES;
    
    descriptionLbl.text=lessonObj.lessonDescription;
    recuringLbl.text=lessonObj.lesson_is_recurring;
    endDateLbl.text=lessonObj.lesson_end_Date;
    startDateLbl.text=lessonObj.LessonDate;
    durationLbl.text=lessonObj.lesson_duration;
    studentListArray=lessonObj.studentListArray;
    if ([lessonDetailView isEqualToString:@"History"])
    {
        studentsBackView.hidden=YES;
    }
    else{
        studentsBackView.hidden=NO;
    }

    
    NSString*startTimeStr=lessonObj.lesson_start_time;
    NSString*endTimeStr=lessonObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    
    timeLbl.text=lessonTime;
    
    NSArray *daysArray = [lessonObj.lesson_days componentsSeparatedByString:@","];
    
    for (int k=0; k<daysArray.count; k++)
    {
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Monday"])
        {
            monday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Tuesday"])
        {
            tuesday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Wednesday"])
        {
            wednesday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Thursday"])
        {
            thursday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Friday"])
        {
            friday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Saturday"])
        {
            saturday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Sunday"])
        {
            sunday.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
    }
    
    tutornameLbl.text=lessonObj.tutorName;
    
    [studentTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateNotesBtn:(id)sender {
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [studentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    StudentLessonDetailTableViewCell *cell = (StudentLessonDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentLessonDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary*dict=[studentListArray objectAtIndex:indexPath.row ];
    NSString *abc;
    if([[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_fee"]] isEqualToString:@"<null>"])
    {
        abc =@"0";
    }else{
        abc =[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_fee"]];
    }
    cell.backgroundColor=[UIColor clearColor];
    if ([self.trigger isEqualToString:@"Parent"]) {
    
    [cell setLabelTextForParent:[dict valueForKey:@"student_name"] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_email"]] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_contact_info"]]:[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_address"]]:abc];
    }else{
        [cell setLabelTextForTutor:[dict valueForKey:@"student_name"] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_email"]] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_contact_info"]]:[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_address"]]:abc];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
     NSDictionary*dict = [studentListArray objectAtIndex:indexPath.row];
    StudentList*studentObj=[[StudentList alloc]init];
    
    studentObj.studentId=[dict valueForKey:@"student_id"];
    studentObj.studentName=[dict valueForKey:@"student_name"];
    studentObj.address=[dict valueForKey:@"student_address"];
    studentObj.studentContact=[dict valueForKey:@"student_contact_info"];
    studentObj.studentEmail=[dict valueForKey:@"student_email"];
    studentObj.isActive=[NSString stringWithFormat:@"%@",[dict valueForKey:@"isactive"]];

    
    StudentDetailViewController*studentDetailVc=[[StudentDetailViewController alloc]initWithNibName:@"StudentDetailViewController" bundle:[NSBundle mainBundle]];
    studentDetailVc.editBtnHiddn=YES;

    
    studentDetailVc.StudentObj=studentObj;
    [self.navigationController pushViewController:studentDetailVc  animated:YES];
}



@end
