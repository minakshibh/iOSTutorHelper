//
//  lessonsViewController.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "lessonsViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "lessonDetailTableViewCell.h"
#import "lessonDetailsViewController.h"
@interface lessonsViewController ()

@end

@implementation lessonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.lessonId);
    studentListArray = [[NSMutableArray alloc] init];
    [self fetchlessonDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchlessonDetails{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    NSString *tutorid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tutor_id"]];
    _postData = [NSString stringWithFormat:@"lesson_ids=%@&tutor_id=%@",self.lessonId,tutorid];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get-lesson-detail-month.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
            
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    
}


#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"responseString:%@",userDetailDict);
    
    
    NSMutableArray *lessonArrayList = [userDetailDict valueForKey:@"lesson_list"];
    lessonsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [lessonArrayList count]; i++) {
        lessonDetailsObj = [[lessonDetailsOC alloc] init];
        lessonDetailsObj.end_date = [[lessonArrayList valueForKey:@"end_date"] objectAtIndex:i];
        lessonDetailsObj.lesson_date = [[lessonArrayList valueForKey:@"lesson_date"] objectAtIndex:i];
        lessonDetailsObj.lesson_days = [[lessonArrayList valueForKey:@"lesson_days"] objectAtIndex:i];
        lessonDetailsObj.end_date = [[lessonArrayList valueForKey:@"end_date"] objectAtIndex:i];
        lessonDetailsObj.lesson_description = [[lessonArrayList valueForKey:@"lesson_description"] objectAtIndex:i];
        lessonDetailsObj.lesson_duration = [[lessonArrayList valueForKey:@"lesson_duration"] objectAtIndex:i];
        lessonDetailsObj.lesson_end_time = [[lessonArrayList valueForKey:@"lesson_end_time"] objectAtIndex:i];
        lessonDetailsObj.lesson_id = [[lessonArrayList valueForKey:@"lesson_id"] objectAtIndex:i];
        lessonDetailsObj.lesson_is_active = [[lessonArrayList valueForKey:@"lesson_is_active"] objectAtIndex:i];
        lessonDetailsObj.lesson_is_recurring = [[lessonArrayList valueForKey:@"lesson_is_recurring"] objectAtIndex:i];
        lessonDetailsObj.lesson_schedule_status = [[lessonArrayList valueForKey:@"lesson_schedule_status"] objectAtIndex:i];
        lessonDetailsObj.lesson_start_time = [[lessonArrayList valueForKey:@"lesson_start_time"] objectAtIndex:i];
        lessonDetailsObj.lesson_topic = [[lessonArrayList valueForKey:@"lesson_topic"] objectAtIndex:i];
        lessonDetailsObj.lesson_tutor_id = [[lessonArrayList valueForKey:@"lesson_tutor_id"] objectAtIndex:i];
        lessonDetailsObj.tutor_name = [[lessonArrayList valueForKey:@"tutor_name"] objectAtIndex:i];
        lessonDetailsObj.studentArrayList = [[lessonArrayList valueForKey:@"student_info"] objectAtIndex:i];
        lessonDetailsObj.noOfStudents = [[lessonArrayList valueForKey:@"no of students"] objectAtIndex:i];
        [lessonsArray addObject:lessonDetailsObj];
    }
    [lessonTableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [lessonsArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    lessonDetailTableViewCell *cell = (lessonDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"lessonDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    lessonDetailsObj=[[lessonDetailsOC alloc]init];
    
    lessonDetailsObj = [lessonsArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    NSString*startTimeStr=lessonDetailsObj.lesson_start_time;
    NSString*endTimeStr=lessonDetailsObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    NSString*lessonDate=[NSString stringWithFormat:@"%@ - %@",lessonDetailsObj.lesson_date,lessonDetailsObj.lesson_end_time];
    
        NSString *dateStart =lessonDetailsObj.lesson_date;
        
        NSDateFormatter*dateFormtr=[[NSDateFormatter alloc]init];
        
        NSDate *currntDate = [NSDate date] ;
        [dateFormtr setDateFormat:@"yyyy-MM-dd"];
        NSString*todayDateStr=[dateFormtr stringFromDate:currntDate];
        currntDate=[dateFormtr dateFromString:todayDateStr];
        
        NSDate *date1= [dateFormtr dateFromString:dateStart];
        NSComparisonResult result3 = [currntDate compare:date1];
        
        
        
        NSDate *currntDateTime = [NSDate date] ;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        NSString*todayDate=[df stringFromDate:currntDateTime];
        currntDateTime=[df dateFromString:todayDate];
        NSString *time1 =lessonDetailsObj.lesson_start_time;
        NSDate *dateS1= [df dateFromString:time1];
        
        NSComparisonResult result2 = [currntDateTime compare:dateS1];
        
        if(result3 == NSOrderedDescending)
        {
            
        }
        else if(result3 == NSOrderedAscending)
        {
            /////// Connect  BUTTON //////////
            UIButton *cancelLessonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            if (IS_IPHONE_6P)
            {
                cancelLessonBtn.frame = CGRectMake(330.0f, 68.0f,70.0f,26.0f);
            }
            else  if (IS_IPHONE_6)
            {
                cancelLessonBtn.frame = CGRectMake(290.0f, 68.0f,70.0f,26.0f);
            }
            else{
                cancelLessonBtn.frame = CGRectMake(240.0f, 68.0f,70.0f,26.0f);
            }
            
            
            cancelLessonBtn.tag = indexPath.row;
            [cancelLessonBtn setTintColor:[UIColor whiteColor]] ;
            [cancelLessonBtn addTarget:self action:@selector(cancelLessonActionBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *buttonBackgroundShowDetail1= [UIImage imageNamed:@"reject.png"];
            [cancelLessonBtn setBackgroundImage:buttonBackgroundShowDetail1 forState:UIControlStateNormal];
            cancelLessonBtn.titleLabel.textColor=[UIColor whiteColor];
            
            [cancelLessonBtn setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:cancelLessonBtn];
            [cancelLessonBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        studentListArray=lessonDetailsObj.studentArrayList;
//        NSDictionary*dict=[studentListArray objectAtIndex:indexPath.row ];
    
    
    [cell setLabelText:lessonDetailsObj.lesson_description :lessonTime :lessonDetailsObj.lesson_date :lessonDetailsObj.lesson_duration:lessonDetailsObj.noOfStudents];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return  cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
    lessonDetailsObj = [lessonsArray objectAtIndex:indexPath.row];
    
    lessonDetailsViewController*lessonRequstVC=[[lessonDetailsViewController alloc]initWithNibName:@"lessonDetailsViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.lessondetailObj=lessonDetailsObj;
    
 
    lessonRequstVC.selected_id =[NSString stringWithFormat:@"%@",lessonDetailsObj.lesson_id];
    lessonRequstVC.date_selected = self.date;
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}



- (IBAction)backBtnAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
