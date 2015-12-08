//
//  MyLessonsViewController.m
//  TutorHelper
//
//  Created by Br@R on 14/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//
#import "MyLessonsViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "MyLessonsTableViewCell.h"
#import "MyLessonDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MyLessonsViewController ()

@end

@implementation MyLessonsViewController
@synthesize trigger,lessonObj,dateDetail,lessonsListArray,studentIdStr;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if ([dateDetail isEqualToString:@"YES"])
    {
        histryUpprLbl.hidden=YES;

        [lessonsTableView reloadData];
    }
    else if ([dateDetail isEqualToString:@"History"])
    {
        histryUpprLbl.hidden=NO;
        
        headrLbl.text=@"History";
        lessonsTableView.frame=CGRectMake(lessonsTableView.frame.origin.x, lessonsTableView.frame.origin.y+20, lessonsTableView.frame.size.width, lessonsTableView.frame.size.height);
        
        [self fetchHistoryWebservice];
    }
    else
    {
        histryUpprLbl.hidden=YES;

        [self FetchMyLessonList];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) fetchHistoryWebservice{
    
    _postData = [NSString stringWithFormat:@"student_id=%@",studentIdStr];
    
    webservice=4;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-student-history.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchMyLessonList
{
    
    NSString*tutor_id;
    NSString*parentId;
    if ([trigger isEqualToString:@"Tutor"])
    {
        tutor_id=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        parentId=@"";
    }
    else
    {
        parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        tutor_id=@"";
    }
    NSString*last_updated_date= @"";
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&trigger=%@&last_updated_date=%@", parentId,tutor_id,trigger,last_updated_date];
    
    webservice=1;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-my-lessons.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    self.view.userInteractionEnabled=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    
    if ([webData length]==0)
        return;
    
    
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"userDetailDict:%@",userDetailDict);
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            if (webservice==1)
            {
                
                lessonsListArray =[[NSMutableArray alloc]init];
                //  NSArray*requestArray1=[userDetailDict valueForKey:@"lesson_data"];
                
                
                NSArray*requestArray=[userDetailDict valueForKey:@"lesson_data"];
                if (requestArray.count>0)
                {
                    
                    for (int k=0; k<requestArray.count; k++)
                    {
                        self.lessonObj=[[Lessons alloc]init];
                        
                        
                        Lessons*LessonListObj=[[Lessons alloc]init];
                        LessonListObj.LessonId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_id" ]];
                        LessonListObj.LessonDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"lesson_date"]];
                        LessonListObj.ParentName=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"parent_name"]];
                        LessonListObj.ParentEmail=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"parent_email"]];
                        LessonListObj.ParentId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"parent_id"]];
                        LessonListObj.maximumValueOfLastUpdated=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"greatest_last_updated"]];
                        LessonListObj.lesson_days=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_days"]];
                        LessonListObj.lessonDescription=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_description"]];
                        LessonListObj.lesson_duration=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_duration"]];
                        LessonListObj.lesson_end_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_end_time"]];
                        LessonListObj.isActive=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_is_active"]];
                        LessonListObj.lesson_is_recurring=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_is_recurring"]];
                        LessonListObj.lesson_start_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_start_time"]];
                        LessonListObj.lessonTopic=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_topic"]];
                        LessonListObj.TutorId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_tutor_id"]];
                        LessonListObj.studentListArray=[[requestArray  objectAtIndex:k ] valueForKey:@"student_info"];
                        LessonListObj.no_of_students=[NSString stringWithFormat:@"%lu",(unsigned long)LessonListObj.studentListArray.count];
                        LessonListObj.tutorName=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"tutor_name"]];
                        LessonListObj.lesson_end_Date=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"end_date"]];
                        LessonListObj.lesson_is_active = [NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k] valueForKey:@"lesson_is_active"]];
                     
                        [lessonsListArray addObject:LessonListObj];
                    }
                    
                }
                [lessonsTableView reloadData];
                webservice=0;
                
            }
            else if (webservice==3){
                
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your request to cancel lesson has been submit suceesfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                reasonBackView.hidden=YES;
                reasonTxtView.text=@"";
            }
            else if (webservice==4)
            {
                
                lessonsListArray =[[NSMutableArray alloc]init];
                NSArray*requestArray=[userDetailDict valueForKey:@"lesson_data"];
                if (requestArray.count>0)
                {
                   for (int k=0; k<requestArray.count; k++)
                    {
                        self.lessonObj=[[Lessons alloc]init];
                        Lessons*LessonListObj=[[Lessons alloc]init];
                        LessonListObj.LessonId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_id" ]];
                        LessonListObj.LessonDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"lesson_date"]];
                        LessonListObj.lesson_days=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_days"]];
                        LessonListObj.lessonDescription=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_description"]];
                        LessonListObj.lesson_duration=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_duration"]];
                        LessonListObj.lesson_end_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_end_time"]];
                        LessonListObj.isActive=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_is_active"]];
                        LessonListObj.lesson_is_recurring=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_is_recurring"]];
                        LessonListObj.lesson_start_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_start_time"]];
                        LessonListObj.lessonTopic=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_topic"]];
                        LessonListObj.TutorId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_tutor_id"]];
                        LessonListObj.tutorName=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"tutor_name"]];
                        LessonListObj.lesson_end_Date=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"end_date"]];
                        LessonListObj.lesson_is_active = [NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k] valueForKey:@"lesson_is_active"]];
                        [lessonsListArray addObject:LessonListObj];
                    }
                    
                }
                [lessonsTableView reloadData];
                webservice=0;
                
            }
            else {
                
            }
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lessonsListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height;
    if ([dateDetail isEqualToString:@"History"])
    {
        height=125;
    }
    else{
        height=125;
    }


    return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    MyLessonsTableViewCell *cell = (MyLessonsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyLessonsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    lessonObj=[[Lessons alloc]init];
    
    lessonObj = [lessonsListArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    NSString*startTimeStr=lessonObj.lesson_start_time;
    NSString*endTimeStr=lessonObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];

    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    NSString*lessonDate=[NSString stringWithFormat:@"%@ - %@",lessonObj.LessonDate,lessonObj.lesson_end_Date];

    
    
    if (![trigger isEqualToString:@"Tutor"])
    {
        
        
        NSString *dateStart =lessonObj.LessonDate;
        
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
        NSString *time1 =lessonObj.lesson_start_time;
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
    
        else if (result3 ==NSOrderedSame)
        {
            if(result2 == NSOrderedAscending)
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
        }
    }
        
    if ([dateDetail isEqualToString:@"History"])
    {
        [cell setLabelText:self.lessonObj.lessonDescription :lessonTime :self.lessonObj.lesson_days :lessonDate :self.lessonObj.lesson_duration :@"History" :lessonObj.lesson_is_active];
    }
    else{
        [cell setLabelText:self.lessonObj.lessonDescription :lessonTime :self.lessonObj.lesson_days :self.lessonObj.no_of_students :self.lessonObj.lesson_duration :@"":lessonObj.lesson_is_active];
    }
    
    return  cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
    Lessons *lessonObj1 = (Lessons *)[lessonsListArray objectAtIndex:indexPath.row];
    
    MyLessonDetailViewController*lessonRequstVC=[[MyLessonDetailViewController alloc]initWithNibName:@"MyLessonDetailViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.lessonObj=lessonObj1;
    lessonRequstVC.lessonDetailView=dateDetail;
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}



- (IBAction)cancelLessonActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"connect");
    
    lessObj = (Lessons *)[lessonsListArray objectAtIndex:indexPath.row];

    reasonBackView.hidden=NO;
    reasonTxtView.text=@"";
}





- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBttn:(id)sender
{
    reasonBackView.hidden=YES;
    reasonTxtView.text=@"";
 
}

- (IBAction)doneBttn:(id)sender
{
    NSString* reason = [reasonTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (reason.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter reason to cancel lesson." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
      _postData = [NSString stringWithFormat:@"lesson_id=%@&parent_id=%@&reason=%@", lessObj.LessonId,lessObj.ParentId,reason ];
    
    webservice=3;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/request-lesson-cancellation.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
@end
