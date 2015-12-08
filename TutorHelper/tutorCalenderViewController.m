//
//  tutorCalenderViewController.m
//  TutorHelper
//
//  Created by Krishna-Mac on 06/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "tutorCalenderViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
@interface tutorCalenderViewController ()

@end

@implementation tutorCalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.tutorId);
    [[NSUserDefaults standardUserDefaults] setValue:self.tutorId forKey:@"tutor_id"];
    [self addCalenderDates];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) addCalenderDates{
    NSString*_postData ;    
    
    
    if (self.tutorId.length>0)
    {
        _postData = [NSString stringWithFormat:@"tutor_id=%@",self.tutorId ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    else{
       
    }
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    
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
    NSLog(@"data>>%@",data);
    webData=[[NSMutableData alloc]initWithData:data];
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
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            {
                
                NSString*activalessons=[userDetailDict valueForKey:@"no of active students"];
                NSString*fee_collected=[userDetailDict valueForKey:@"fee_collected"];
                NSString*fee_due=[userDetailDict valueForKey:@"fee_due"];
                NSArray*lessonList=[userDetailDict valueForKey:@"lesson_list"];
                
                if ([fee_collected isKindOfClass:[NSNull class]])
                {
                    fee_collected=@"0";
                }
                if ([fee_due isKindOfClass:[NSNull class]])
                {
                    fee_due=@"0";
                }
                
                
                
                [self saveLessonsDataTodtaaBase:activalessons :fee_collected :fee_due :lessonList ];
            }
        }
    }
}

-(void) saveLessonsDataTodtaaBase :(NSString*)activLesson :(NSString*)feesCollectd :(NSString*)feesDue :(NSArray*)lessonList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TutorProfile"];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *tutorIdarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [tutorIdarray addObject:[results stringForColumn:@"tutorID"]];
    }
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from LessonList "];
    [database executeUpdate:deleteQuery];
    NSString *deleteQuery1 = [NSString stringWithFormat:@"DELETE from LessonSlots "];
    [database executeUpdate:deleteQuery1];
    for (int i=0; i<lessonList.count; i++)
    {
        NSDictionary*tempDict=[lessonList objectAtIndex:i];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonList (userId, NumberOfLessons, fulldayBlockOut, halfdayBlockOut, lessonDate) VALUES(\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",self.tutorId,[tempDict valueForKey:@"no._of_lessons"],[tempDict valueForKey:@"block_out_time_for_fullday"],[tempDict valueForKey:@"block_out_time_for_halfday"],[tempDict valueForKey:@"lesson_date"]];
        [database executeUpdate:insert];
        NSArray *lessonSlots = [tempDict valueForKey:@"timing"];
        for (int k = 0; k < lessonSlots.count; k++) {
            NSDictionary*tempLessonSlotsDict=[lessonSlots objectAtIndex:k];
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonSlots (userId,lesson_id, lesson_date, lesson_description, lesson_end_timing, lesson_start_timing) VALUES(\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",self.tutorId,[tempLessonSlotsDict valueForKey:@"ID"],[tempDict valueForKey:@"lesson_date"],[tempLessonSlotsDict valueForKey:@"description"],[tempLessonSlotsDict valueForKey:@"end_timing"],[tempLessonSlotsDict valueForKey:@"start_timing"]];
            [database executeUpdate:insert];
        }
    }
    
    [database close];
    [self showCalender];
}
-(void) showCalender{
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 225) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    
    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,130, 354, 270) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,130, 394, 270) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 210) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    
    [self.view addSubview: calendarView];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tutor_id"];
}

- (void)dayButtonPressed:(DayButton *)button {
    //    if(lessonDetailArray.count!=0)
    //    {
    //        lessondetailBcakView.hidden=NO;
    //        [lessonDetailTableView reloadData];
    //    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];;
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    NSLog(@"%@",theDate);
    timeSlotsArray = [[NSMutableArray alloc] init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM LessonSlots where lesson_date =\"%@\" and userId =\"%@\"   ",theDate,self.tutorId];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        NSString *startTimeStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_start_timing"]];
        NSArray* startTimeArray = [startTimeStr componentsSeparatedByString: @":"];
        startTimeStr =[NSString stringWithFormat:@"%@:%@",[startTimeArray objectAtIndex:0],[startTimeArray objectAtIndex:1]];
        NSString *endTimeStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_end_timing"]];
        NSArray* endTimeArray = [endTimeStr componentsSeparatedByString: @":"];
        endTimeStr =[NSString stringWithFormat:@"%@:%@",[endTimeArray objectAtIndex:0],[endTimeArray objectAtIndex:1]];
        NSString *lessonIdStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_id"]];
        NSLog(@"%@ , %@", startTimeStr,endTimeStr);
        NSString *timeSlotStr = [NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr];
        [timeSlotsArray addObject:timeSlotStr];
    }
    if (timeSlotsArray.count > 0) {
        timeSlotsView.hidden = NO;
        timeSlotsViewBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
        timeSlotsViewBgLbl.layer.borderWidth = 1.5;
        timeSlotsViewBgLbl.layer.cornerRadius = 5.0;
        [timeSlotsViewBgLbl setClipsToBounds:YES];
        calendarView.userInteractionEnabled = NO;
        backBtn.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:timeSlotsView];
        [timeSlotsTableView reloadData];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutor Helper" message:@"No lesson for this date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [timeSlotsArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[timeSlotsArray objectAtIndex:indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (IBAction)timeSlotsViewCloseBtnAction:(id)sender {
    timeSlotsView.hidden = YES;
    calendarView.userInteractionEnabled = YES;
    backBtn.userInteractionEnabled = YES;
    
}

- (IBAction)okBtnAction:(id)sender {
    timeSlotsView.hidden = YES;
    calendarView.userInteractionEnabled = YES;
    backBtn.userInteractionEnabled = YES;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
