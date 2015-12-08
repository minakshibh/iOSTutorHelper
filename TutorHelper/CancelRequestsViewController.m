//
//  CancelRequestsViewController.m
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "CancelRequestsViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "CancelRequestsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface CancelRequestsViewController ()

@end

@implementation CancelRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self FetchCancelLessonRequestsList];
    
}

-(void)FetchCancelLessonRequestsList
{
    
    NSString*tutor_id=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    NSString*_postData = [NSString stringWithFormat:@"tutor_id=%@", tutor_id ];
    webservice=1;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-lesson-cancellation.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    self.view.userInteractionEnabled=YES;
    [kappDelegate HideIndicator];
    
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
                cancelRequestListArray=[[NSMutableArray alloc]init];
                NSArray*requestArray=[userDetailDict valueForKey:@"request_info"];
                
                
                for(int k=0;k<[requestArray count];k++)
                {
                    Lessons*lessonListObj=[[Lessons alloc]init];
                    
                    lessonListObj.request_status=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"status"]];
                    lessonListObj.request_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"ID"]];
                    lessonListObj.LessonId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_id"]];
                    lessonListObj.ParentId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"parent_id"]];
                    lessonListObj.ParentName=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"parent_name"]];
                    lessonListObj.lesson_cancl_reason=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"reason"]];
                    lessonListObj.lesson_cancl_reqDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"request_date"]];
                    lessonListObj.LessonDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_date"]];
                    lessonListObj.tutorName=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"tutor_name"]];
                    lessonListObj.lesson_days=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_days"]];
                    lessonListObj.lessonDescription=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_description"]];
                    lessonListObj.TutorId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_tutor_id"]];
                     lessonListObj.lesson_start_time=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_start_time"]];
                    lessonListObj.lesson_end_time=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_end_time"]];
                    lessonListObj.lesson_duration=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_duration"]];
                    lessonListObj.lesson_is_recurring=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k]valueForKey:@"lesson_is_recurring" ]];
                    
                    
                    if (![[[requestArray objectAtIndex:k ] valueForKey:@"lesson_fee"] isKindOfClass:[NSNull class]])
                    {
                        lessonListObj.lesson_fee=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_fee"]];
                    }
                    else{
                        lessonListObj.lesson_fee=[NSString stringWithFormat:@"0"];
                        
                    }
                    
                    lessonListObj.lesson_end_Date=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"end_date"]];
                  
                    [cancelRequestListArray addObject:lessonListObj];
                }
                [RequestsTableView reloadData];
                webservice=0;
            }
            else if (webservice==2)
            {
                [self FetchCancelLessonRequestsList];
                [RequestsTableView reloadData];
            }
            else
            {
            }
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [cancelRequestListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    CancelRequestsTableViewCell *cell = (CancelRequestsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CancelRequestsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Lessons* lessonsObj=[[Lessons alloc]init];
    
    lessonsObj = [cancelRequestListArray objectAtIndex:indexPath.row];
    
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSString*messgeStr;
   
    messgeStr=[NSString stringWithFormat:@"%@ has send you a lesson Cancellation request.",lessonsObj.ParentName ];
    
    
    
    
    NSString*startTimeStr=lessonsObj.lesson_start_time;
    NSString*endTimeStr=lessonsObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];

    
    
    [cell setLabelText:messgeStr :lessonsObj.lessonDescription :[NSString stringWithFormat:@"$%@",lessonsObj.lesson_fee ]:lessonTime :lessonsObj.lesson_days :lessonsObj.lesson_cancl_reason];
    
    
    ////////////Reject  BUTTON //////////
    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        rejectBtn.frame = CGRectMake(210.0f, 160.0f,130.0f,26.0f);
    }  else  if (IS_IPHONE_6)
    {
        rejectBtn.frame = CGRectMake(190.0f, 160.0f,130.0f,26.0f);
    }
    else{
        rejectBtn.frame = CGRectMake(160.0f, 160.0f,100.0f,26.0f);
        
    }
    rejectBtn.tag = indexPath.row;
    [rejectBtn setTintColor:[UIColor whiteColor]] ;
    [rejectBtn addTarget:self action:@selector(RejectActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"reject.png"];
    [rejectBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    rejectBtn.titleLabel.textColor=[UIColor whiteColor];
    
    
    [rejectBtn setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:rejectBtn];
    [rejectBtn setTitle:@"REJECT" forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    /////// Connect  BUTTON //////////
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (IS_IPHONE_6P)
    {
        connectBtn.frame = CGRectMake(60.0f, 160.0f,130.0f,26.0f);
    }
    else  if (IS_IPHONE_6)
    {
        connectBtn.frame = CGRectMake(40.0f, 160.0f,130.0f,26.0f);
    }
    else{
        connectBtn.frame = CGRectMake(40.0f, 160.0f,100.0f,26.0f);
        
    }
    
    
    connectBtn.tag = indexPath.row;
    [connectBtn setTintColor:[UIColor whiteColor]] ;
    [connectBtn addTarget:self action:@selector(ConnectActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundShowDetail1= [UIImage imageNamed:@"accept.png"];
    [connectBtn setBackgroundImage:buttonBackgroundShowDetail1 forState:UIControlStateNormal];
    connectBtn.titleLabel.textColor=[UIColor whiteColor];
    
    [connectBtn setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:connectBtn];
    [connectBtn setTitle:@"ACCEPT" forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (IBAction)ConnectActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"connect");
    
    Lessons *lessObj;
    
    lessObj = (Lessons *)[cancelRequestListArray objectAtIndex:indexPath.row];
    
    NSMutableURLRequest *request;

    NSString*_postData = [NSString stringWithFormat:@"request_id=%@&status=Accepted", lessObj.request_id ];
        
    webservice=2;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
        
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/approve-cancellation-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        
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


- (IBAction)RejectActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"Reject");
    
    Lessons *lessObj;
    
    lessObj = (Lessons *)[cancelRequestListArray objectAtIndex:indexPath.row];
     NSMutableURLRequest *request;
    
    NSString*_postData = [NSString stringWithFormat:@"request_id=%@&status=Rejected", lessObj.request_id ];
        webservice=2;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
        
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/approve-cancellation-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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
- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
