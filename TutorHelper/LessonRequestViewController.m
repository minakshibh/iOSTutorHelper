//
//  LessonRequestViewController.m
//  TutorHelper
//
//  Created by Br@R on 13/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "LessonRequestViewController.h"
#import "LessonRequestsTableViewCell.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "ParentDashboardViewController.h"
@interface LessonRequestViewController ()

@end

@implementation LessonRequestViewController
@synthesize trigger,requests;

- (void)viewDidLoad {
    FirstTime=YES;
    type=@"ForMe";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    lessonsObj=[[Lessons alloc]init];
    
    [self FetchLessonRequestsList];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchLessonRequestsList
{
    
    NSString*tutor_id;
    NSString*parentId;
    if ([trigger isEqualToString:@"Tutor"])
    {
        tutor_id=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    }
    else
    {
        parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    }
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&trigger=%@&type=%@", parentId,tutor_id,trigger,type ];
    webservice=1;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-lessons-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
                NSArray*requestArray;
                
            
                if ([type isEqualToString:@"ByMe"])
                {
                    byMeRequestListArray =[[NSMutableArray alloc]init];
                }
                else{
                    forMeRequestListArray =[[NSMutableArray alloc]init];
                }
                requestArray=[userDetailDict valueForKey:@"lesson_request"];

                lessonsObj=[[Lessons alloc]init];
                
                
                for(int k=0;k<[requestArray count];k++)
                {
                    Lessons*lessonListObj=[[Lessons alloc]init];
                    lessonListObj.student_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k]valueForKey:@"student_id" ]];
                    lessonListObj.TutorId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"tutor_id"]];
                    lessonListObj.request_status=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"request_status"]];
                    lessonListObj.request_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"request_id"]];
                  
                    if (![[[requestArray objectAtIndex:k ] valueForKey:@"lesson_fee"] isKindOfClass:[NSNull class]])
                    {
                        lessonListObj.lesson_fee=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_fee"]];
                    }
                    else{
                        lessonListObj.lesson_fee=[NSString stringWithFormat:@"0"];

                    }
                    
                    lessonListObj.ParentId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"parent_id"]];
                    lessonListObj.lessonTopic=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_topic"]];
                    lessonListObj.lesson_is_recurring=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k]valueForKey:@"lesson_is_recurring" ]];
                    lessonListObj.lesson_start_time=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_start_time"]];
                    lessonListObj.LessonId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_id"]];
                    lessonListObj.lesson_end_time=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_end_time"]];
                    lessonListObj.lesson_duration=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_duration"]];
                    lessonListObj.lesson_days=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_days"]];
                    lessonListObj.LessonDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_date"]];
                    
                    lessonListObj.lesson_end_Date=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_end_date"]];
                    lessonListObj.lesson_created_date=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_created_date"]];
                    lessonListObj.lessonDescription=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_description"]];
                    lessonListObj.tutorName=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"tutor_name"]];
                    lessonListObj.studentName=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"student_name"]];
                    lessonListObj.ParentName=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"parent_name"]];
                  
                    if ([type isEqualToString:@"ByMe"])
                    {
                        [byMeRequestListArray addObject:lessonListObj];
                    }
                    else{
                        [forMeRequestListArray addObject:lessonListObj];
                    }

                
                }
                
                [RequestsTableView reloadData];
                
                webservice=0;
            }
            else if (webservice==2)
            {
                [self FetchLessonRequestsList];
                [RequestsTableView reloadData];
               [self.navigationController popViewControllerAnimated:YES];
                
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
    
    if ([type isEqualToString:@"ByMe"])
    {
        return [byMeRequestListArray count];
    }
    else{
        return [forMeRequestListArray count];
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    LessonRequestsTableViewCell *cell = (LessonRequestsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LessonRequestsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    lessonsObj=[[Lessons alloc]init];
    
    if ([type isEqualToString:@"ByMe"])
    {
        lessonsObj = [byMeRequestListArray objectAtIndex:indexPath.row];
    }
    else{
        lessonsObj = [forMeRequestListArray objectAtIndex:indexPath.row];
    }

    
    cell.backgroundColor=[UIColor clearColor];
    
    NSString*messgeStr;
    if ([trigger isEqualToString:@"Tutor"]) {
        messgeStr=[NSString stringWithFormat:@"%@ has sent you a lesson request for %@",lessonsObj.ParentName ,lessonsObj.studentName];
    }
    else{
         messgeStr=[NSString stringWithFormat:@"%@ has sent you a lesson request for %@",lessonsObj.tutorName ,lessonsObj.studentName];
    }
  
    NSString*startTimeStr=lessonsObj.lesson_start_time;
    NSString*endTimeStr=lessonsObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    NSString*lessonDate=[NSString stringWithFormat:@"%@ - %@",lessonsObj.LessonDate,lessonsObj.lesson_end_Date];

    
    [cell setLabelText:messgeStr :lessonsObj.lessonDescription :[NSString stringWithFormat:@"$%@",lessonsObj.lesson_fee ]:lessonTime :lessonsObj.lesson_days  :lessonDate :lessonsObj.lesson_duration];
    
   
    ////////////Reject  BUTTON //////////
    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        rejectBtn.frame = CGRectMake(210.0f, 145.0f,130.0f,26.0f);
    }  else  if (IS_IPHONE_6)
    {
        rejectBtn.frame = CGRectMake(190.0f, 145.0f,130.0f,26.0f);
    }
    else{
        rejectBtn.frame = CGRectMake(160.0f, 145.0f,100.0f,26.0f);

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
        connectBtn.frame = CGRectMake(60.0f, 145.0f,130.0f,26.0f);
    }
  else  if (IS_IPHONE_6)
    {
        connectBtn.frame = CGRectMake(40.0f, 145.0f,130.0f,26.0f);
    }
    else{
        connectBtn.frame = CGRectMake(40.0f, 145.0f,100.0f,26.0f);
        
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
    
    if ([type isEqualToString:@"ByMe"])
    {
        lessObj = (Lessons *)[byMeRequestListArray objectAtIndex:indexPath.row];
    }
    else{
        lessObj = (Lessons *)[forMeRequestListArray objectAtIndex:indexPath.row];
    }
    [self calcuateAlarmTime:lessObj.LessonDate:lessObj.lesson_start_time :lessObj.ParentId :lessObj.lessonDescription: lessObj.lesson_days];
    NSMutableURLRequest *request;
    
    _postData = [NSString stringWithFormat:@"request_id=%@&response=Accepted&trigger=%@", lessObj.request_id,trigger ];
        
    webservice=2;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
        
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/accept-lesson-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];

    
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
    
    if ([type isEqualToString:@"ByMe"])
    {
        lessObj = (Lessons *)[byMeRequestListArray objectAtIndex:indexPath.row];
    }
    else{
        lessObj = (Lessons *)[forMeRequestListArray objectAtIndex:indexPath.row];
    }
    NSMutableURLRequest *request;
    
    _postData = [NSString stringWithFormat:@"request_id=%@&response=Rejected&trigger=%@", lessObj.request_id,trigger ];
    webservice=2;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
        
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/accept-lesson-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    
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

- (IBAction)byMeBttn:(id)sender {
    type= @"ByMe";
    [RequestsTableView reloadData];
}

- (IBAction)forMebttn:(id)sender {
    type=@"ForMe";
    if (FirstTime)
    {
        [self FetchLessonRequestsList];
    }
    FirstTime =NO;
    [RequestsTableView reloadData];
}

- (IBAction)BackBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)calcuateAlarmTime: (NSString*)lessonDate : (NSString *)lessonStartTime :(NSString *)userId : (NSString *)detail :(NSString*)days{
    NSDate *todaysDate;
    todaysDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDate = [ dateFormat stringFromDate:todaysDate];
    todaysDate = [dateFormat dateFromString:currentDate];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSString *timeFrom = [NSString stringWithFormat:@"%@",lessonDate];
    NSArray* dateFromArray = [timeFrom componentsSeparatedByString: @" "];
    NSString *dateToSelect =[NSString stringWithFormat:@"%@",[dateFromArray objectAtIndex:0]];
    NSArray *dateComponentsArray = [dateToSelect componentsSeparatedByString:@"-"];
    int yearValue = [[dateComponentsArray objectAtIndex:0]intValue];
    
    int monthValue = [[dateComponentsArray objectAtIndex:1]intValue];
    
    int dateValue = [[dateComponentsArray objectAtIndex:2]intValue];
    
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:monthValue];
    [dateParts setYear:yearValue];
    [dateParts setDay:dateValue];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    if ([todaysDate compare:dateOnFirst] == NSOrderedAscending || [todaysDate compare:dateOnFirst] == NSOrderedSame) {
        NSString *alarmTime = [NSString stringWithFormat:@"%@ %@",lessonDate,lessonStartTime];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *serviceTime = [dateFormat1 dateFromString:alarmTime];
        NSString *serviceDateTime = [dateFormat1 stringFromDate:serviceTime];
        [self scheduleNotificationForDate:serviceDateTime : userId :detail : days];
    }
}
-(void) scheduleNotificationForDate: (NSString*)lessondate : (NSString *)userId : (NSString *)detail:(NSString*)days{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    NSDate *curdate = [NSDate date];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:curdate];
    NSArray *tempArray1 = [lessondate componentsSeparatedByString:@" "];
    NSString *timeStr = [tempArray1 objectAtIndex:1];
    NSArray *tempArray = [timeStr componentsSeparatedByString:@":"];
    NSLog(@"month %ld", (long)[components month]);
    NSLog(@"year %ld", (long)[components year]);
    NSLog(@"day %ld", (long)[components day]);
    NSLog(@"hour %d", [[tempArray objectAtIndex:0] intValue]);
    NSLog(@"minute %d", [[tempArray objectAtIndex:1] intValue]);
    NSDateComponents *tempComp = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *daysstr = [days componentsSeparatedByString:@","];
    NSLog(@"Selected Days Name: %@", daysstr);
    int i;
    int weekDay = [components weekday];
    
    for (i = 0; i < [daysstr count]; i++) {
        NSDateComponents *dateParts = [[NSDateComponents alloc] init];
        
        [dateParts setHour:[[tempArray objectAtIndex:0] intValue]];
        [dateParts setMinute:[[tempArray objectAtIndex:1] intValue]];
        [dateParts setSecond:00];
        
        NSString *myArrayElement = [daysstr objectAtIndex:i];
        if ([myArrayElement isEqualToString:@"Sunday"]) {
            tempComp.day = 1-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Monday"]) {
            tempComp.day = 2-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Tuesday"]) {
            tempComp.day = 3-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Wednesday"]) {
            tempComp.day = 4-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Thursday"]) {
            tempComp.day = 5-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Friday"]){
            tempComp.day = 6-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Saturday"]) {
            tempComp.day = 7-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
    
    NSDate *sDate = [calendar dateFromComponents:dateParts];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"Parent_ID", nil];
    localNotif.userInfo = userDict;
    localNotif.fireDate = sDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSWeekCalendarUnit;
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertBody = detail;
    localNotif.soundName =UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSLog(@"notification started");
    }
}
@end
