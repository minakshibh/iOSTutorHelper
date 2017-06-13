//
//  AddLessonViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AddLessonViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "StudentList.h"
#import <QuartzCore/QuartzCore.h>
#import "AddStudentViewController.h"

#define POSITIVE(n) ((n) < 0 ? 0 - (n) : (n))

@interface AddLessonViewController ()

@end

@implementation AddLessonViewController
@synthesize trigger,studentListArray,addStudentList,tutorIDstr;

- (void)viewDidLoad {
    tempStudentArray =[[NSMutableArray alloc]init];
    endSelectedDateArray = [[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    studentsBackView.layer.borderColor=[UIColor clearColor].CGColor;
    studentsBackView.layer.borderWidth=2.0f;
    studentsBackView.layer.cornerRadius=5.0;
    studentsBackView.clipsToBounds = YES;
    studentsBackView.layer.masksToBounds = YES;
    
    lessonNameBackView.layer.borderColor=[UIColor clearColor].CGColor;
    lessonNameBackView.layer.borderWidth=2.0f;
    lessonNameBackView.layer.cornerRadius=5.0;
    lessonNameBackView.clipsToBounds = YES;
    lessonNameBackView.layer.masksToBounds = YES;
    
    
    daysView.layer.borderColor=[UIColor clearColor].CGColor;
    daysView.layer.borderWidth=2.0f;
    daysView.layer.cornerRadius=5.0;
    daysView.clipsToBounds = YES;
    daysView.layer.masksToBounds = YES;
    
    [super viewDidLoad];
    [self fetchStudentList];
    addStudentList=[[NSMutableArray alloc]init];
    indexes=[[NSMutableArray alloc]init];
    is_recur=@"YES";
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Select Students :"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    [selectSudentBtn setAttributedTitle:commentString forState:UIControlStateNormal];
    selectSudentBtn.titleLabel.textColor=[UIColor blackColor];
    
    
    [recurngYesBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    recurngYesBtn.titleLabel.textColor =[UIColor whiteColor];
    
    [recurngNobtn setBackgroundColor:[UIColor whiteColor]];
    recurngNobtn.titleLabel.textColor =[UIColor blackColor];
    
    
    [dateTimePickr addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    // dateTimePickr.minuteInterval=10;
    
    daysArray=[[NSMutableArray alloc]init];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
    
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInOneHours = 1* 60 * 60;
    NSDate *dateOneHoursAhead = [mydate dateByAddingTimeInterval:secondsInOneHours];
    
    dateOneHoursAhead= [dateOneHoursAhead dateByAddingTimeInterval:180];
    NSDate *datePlusThreeMinute = [mydate dateByAddingTimeInterval:180];
    
    dateSelected=[DateFormatter stringFromDate:datePlusThreeMinute];
    
    NSString*endTime=[DateFormatter stringFromDate:dateOneHoursAhead];
    
    
    NSDateFormatter*df=[[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"HH:mm"];
    
    NSInteger minuteInterval = 10;
    
    
    
    
    NSDate*dateSet=[df dateFromString:dateSelected];
    NSDateComponents *dateComponents2 = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:dateSet];
    NSInteger minutes = [dateComponents2 minute];
    float minutesF = [[NSNumber numberWithInteger:minutes] floatValue];
    float minuteIntervalF = [[NSNumber numberWithInteger:minuteInterval] floatValue];
    NSInteger roundingAmount = (fmodf(minutesF, minuteIntervalF)) > minuteIntervalF/2.0 ? minuteInterval : 0;
    NSInteger minutesRounded = ( (NSInteger)(minutes / minuteInterval) ) * minuteInterval;
    NSDate *roundedDate = [[NSDate alloc] initWithTimeInterval:60.0 * (minutesRounded + roundingAmount - minutes) sinceDate:dateSet];
    dateSelected=[df stringFromDate:roundedDate];
    
    
    //    startTimeLbl.text=dateSelected;
    
    
    NSDate*endTimeSet=[df dateFromString:endTime];
    NSDateComponents *dateComponents1 = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:endTimeSet];
    minutes = [dateComponents1 minute];
    minutesF = [[NSNumber numberWithInteger:minutes] floatValue];
    minuteIntervalF = [[NSNumber numberWithInteger:minuteInterval] floatValue];
    roundingAmount = (fmodf(minutesF, minuteIntervalF)) > minuteIntervalF/2.0 ? minuteInterval : 0;
    minutesRounded = ( (NSInteger)(minutes / minuteInterval) ) * minuteInterval;
    roundedDate = [[NSDate alloc] initWithTimeInterval:60.0 * (minutesRounded + roundingAmount - minutes) sinceDate:endTimeSet];
    endTime=[df stringFromDate:roundedDate];
    
    //    endTimeLbl.text=endTime;
    
    
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateSelected=[DateFormatter stringFromDate:[NSDate date]];
    
    //    startDateLbl.text=dateSelected;
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    
    NSDate *currentDatePlus6Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSLog(@"Date = %@", currentDatePlus6Month);
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dateSelected=[DateFormatter stringFromDate:currentDatePlus6Month];
    //    endDateLbl.text=dateSelected;
    
    
    [ self GetDayDifference:startDateLbl.text :endDateLbl.text ];
    
    pickerBackView.hidden=YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if (IS_IPHONE_6 || IS_IPHONE_6P)
    {
        scrollView.contentSize = CGSizeMake(320,960);
        
    }else{
        scrollView.contentSize = CGSizeMake(320, 860);
        
    }
    scrollView.backgroundColor=[UIColor clearColor];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addStudentBtn:(id)sender {
    
    //    SelectStudentsViewController *studentsVc=[[SelectStudentsViewController alloc]initWithNibName:@"SelectStudentsViewController" bundle:[NSBundle mainBundle]];
    //    studentsVc.studentListArray=[studentListArray mutableCopy];
    //    [self.navigationController presentViewController:studentsVc animated:YES completion:nil];
    //
    [tempStudentArray removeAllObjects];
    for (int k =0;k<addStudentList.count ;k++)
    {
        [tempStudentArray addObject:[addStudentList objectAtIndex:k]];
    }
    if(tempStudentArray.count==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"No students have been added to your account yet.Continue to add a new student in order to add some lesson." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add new student", nil];
        alert.tag = 3;
        [alert show];
        return;
    }
    
    [studentTableView reloadData];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    scrollView.scrollEnabled = NO;
    studentListBackView.hidden=NO;
    DoneSelectStudntBtn.hidden=NO;
    backBttn.userInteractionEnabled=NO;
    backIconImg.hidden=YES;
    cancelStudentAdBtt.hidden=NO;
}

- (IBAction)DoneAddingStudents:(id)sender {
    scrollView.scrollEnabled = YES;
    studentListBackView.hidden=YES;
    backBttn.userInteractionEnabled=YES;
    DoneSelectStudntBtn.hidden=YES;
    backIconImg.hidden=NO;
    cancelStudentAdBtt.hidden=YES;
    addStudentList= [tempStudentArray mutableCopy];
    
    
    if ( addStudentList.count==0  ||addStudentList.count==1) {
        numbrofStudntsSelctdLbl.text=[NSString stringWithFormat:@"%lu Student",(unsigned long)addStudentList.count];
        
    }
    else{
        numbrofStudntsSelctdLbl.text=[NSString stringWithFormat:@"%lu Students",(unsigned long)addStudentList.count];
        
    }
    
    
}

- (IBAction)MenuBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startTimeBttn:(id)sender
{
    [self.view endEditing:YES];
    getDate =@"Start";
    dateTimePickr.datePickerMode=UIDatePickerModeTime;
    NSString *dateEnd =startTimeLbl.text;
    if (![dateEnd isEqualToString:@"-Select Time-"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateSelected=dateEnd;
        dateTimePickr.date=date2;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *date2 = [formatter stringFromDate:[NSDate date]];
        NSDate* currentTime = [formatter dateFromString:date2];
        dateSelected=dateEnd;
        dateTimePickr.date=currentTime;
    }
    
    pickerBackView.hidden=NO;
}

- (IBAction)endTimeBttn:(id)sender {
    [self.view endEditing:YES];
    getDate =@"End";
    dateTimePickr.datePickerMode=UIDatePickerModeTime;
    NSString *dateEnd =endTimeLbl.text;
    if (![dateEnd isEqualToString:@"-Select Time-"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
        dateSelected=dateEnd;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *date2 = [formatter stringFromDate:[NSDate date]];
        NSDate* currentTime = [formatter dateFromString:date2];
        dateSelected=dateEnd;
        dateTimePickr.date=currentTime;
    }
    pickerBackView.hidden=NO;
    endBtn.titleLabel.text=dateEnd;
}


- (IBAction)lessonDate:(id)sender {
    [self.view endEditing:YES];
    
    getDate =@"LessonStart";
    NSString *dateEnd =startDateLbl.text;
    if (![dateEnd isEqualToString:@"-Select Start Date-"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
        dateSelected=dateEnd;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date2 = [formatter stringFromDate:[NSDate date]];
        NSDate* currentTime = [formatter dateFromString:date2];
        dateSelected=dateEnd;
        dateTimePickr.date=currentTime;
    }
    pickerBackView.hidden=NO;
    dateTimePickr.datePickerMode=UIDatePickerModeDate;
}

- (IBAction)lessonEndDate:(id)sender {
    if ([is_recur isEqualToString:@"YES"]) {
        [self.view endEditing:YES];
        getDate =@"LessonEnd";
        NSString *dateEnd =endDateLbl.text;
        if (![dateEnd isEqualToString:@"-Select Time-"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date2 = [formatter dateFromString:dateEnd];
            dateTimePickr.date=date2;
            dateSelected=dateEnd;
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date2 = [formatter stringFromDate:[NSDate date]];
            NSDate* currentTime = [formatter dateFromString:date2];
            dateSelected=dateEnd;
            dateTimePickr.date=currentTime;
        }
        pickerBackView.hidden=NO;
        dateTimePickr.datePickerMode=UIDatePickerModeDate;
    }
    
}

- (IBAction)recuringYesBttn:(id)sender {
    is_recur=@"YES";
    [recurngYesBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    
    recurngYesBtn.titleLabel.textColor =[UIColor whiteColor];
    [recurngNobtn setBackgroundColor:[UIColor whiteColor]];
    recurngNobtn.titleLabel.textColor =[UIColor blackColor];
}

- (IBAction)recuringNoBttn:(id)sender {
    is_recur=@"NO";
    [recurngNobtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    recurngNobtn.titleLabel.textColor =[UIColor whiteColor];
    [recurngYesBtn setBackgroundColor:[UIColor whiteColor]];
    recurngYesBtn.titleLabel.textColor =[UIColor blackColor];
}

- (IBAction)cancelStudentAddBttn:(id)sender {
    
    scrollView.scrollEnabled = YES;
    studentListBackView.hidden=YES;
    backBttn.userInteractionEnabled=YES;
    DoneSelectStudntBtn.hidden=YES;
    backIconImg.hidden=NO;
    cancelStudentAdBtt.hidden=YES;
    numbrofStudntsSelctdLbl.text=[NSString stringWithFormat:@"%lu Students",(unsigned long)addStudentList.count];
}

- (IBAction)addLessonBttn:(id)sender
{
    [self compairTimeSlots];
    [self.view endEditing:YES];
    if (isSlotAvailable) {
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
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
        tutor_id=tutorIDstr;
    }
    
    NSString* topic = @"";
    NSString* topicDetail = [descriptionTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* startTime = [startTimeLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* endTime = [endTimeLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* days = [daysBtn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* duration;
    NSString*lesson_date=[startDateLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*endLessonDate=[endDateLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (topicDetail .length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please Enter the topic description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (daysArray.count==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please Select the day." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    else if (addStudentList.count==0)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please Select the Students from List." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    
    NSString *dateStart =lesson_date;
    NSString *dateEnd = endLessonDate;
    
    NSDateFormatter*dateFormtr=[[NSDateFormatter alloc]init];
    
    NSDate *currntDate = [NSDate date] ;
    [dateFormtr setDateFormat:@"yyyy-MM-dd"];
    NSString*todayDateStr=[dateFormtr stringFromDate:currntDate];
    currntDate=[dateFormtr dateFromString:todayDateStr];
    
    NSDate *date1= [dateFormtr dateFromString:dateStart];
    NSDate *date2 = [dateFormtr dateFromString:dateEnd];
    
    NSComparisonResult result3 = [currntDate compare:date1];
    if(result3 == NSOrderedDescending)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select the valid Start Date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if(result3 == NSOrderedAscending)
    {
        NSLog(@"date2 is later than date1");
    }
    else
    {
    }
    
    
    NSComparisonResult result = [date1 compare:date2];
    if(result == NSOrderedDescending)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select the valid end Date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    else if(result == NSOrderedAscending)
    {
        NSLog(@"date2 is later than date1");
    }
    else
    {
        
    }
    
    NSString *time1 =startTime;
    NSString *time2 = endTime;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    
    NSDate *dateS1= [formatter1 dateFromString:time1];
    NSDate *dateE2 = [formatter1 dateFromString:time2];
    
    NSComparisonResult result1 = [dateS1 compare:dateE2];
    if(result1 == NSOrderedDescending)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select the valid end time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if(result1 == NSOrderedAscending)
    {
        NSLog(@"date2 is later than date1");
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select the valid end time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    NSDate *currntDateTime = [NSDate date] ;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString*todayDate=[df stringFromDate:currntDateTime];
    currntDateTime=[df dateFromString:todayDate];
    
    NSComparisonResult result2 = [currntDateTime compare:dateS1];
    if(result2 == NSOrderedDescending && result3==NSOrderedSame)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select the valid Start time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if(result2 == NSOrderedAscending)
    {
        NSLog(@"date2 is later than date1");
    }
    else
    {
    }
    
    NSTimeInterval interval = [dateE2 timeIntervalSinceDate:dateS1];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (int)interval / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    
    NSString*hourStr=[NSString stringWithFormat:@"%d",hours];
    NSString*minsStr=[NSString stringWithFormat:@"%d",minutes];
    
    
    if (minsStr.length==0 )
    {
        minsStr=[NSString stringWithFormat:@"00"];
    }
    else  if (minsStr.length==1 )
    {
        minsStr=[NSString stringWithFormat:@"0%@",minsStr];
    }
    else{
        minsStr=[NSString stringWithFormat:@"%@",minsStr];
    }
    
    
    
    
    
    if (hourStr.length==0 )
    {
        hourStr=[NSString stringWithFormat:@"00"];
        
        duration=[NSString stringWithFormat:@"%@:%@",hourStr,minsStr];
        
    }
    else  if (hourStr.length==1 )
    {
        hourStr=[NSString stringWithFormat:@"0%@",hourStr];
        
        duration=[NSString stringWithFormat:@"%@:%@",hourStr,minsStr];
        
    }
    else{
        duration=[NSString stringWithFormat:@"%d:%@",hours,minsStr];
        
    }
        
    minsStr = [NSString stringWithFormat:@"%d",POSITIVE([minsStr intValue])];
        
    NSString *studentlist=[[addStudentList valueForKey:@"description"] componentsJoinedByString:@","];
    days = [[daysArray valueForKey:@"description"] componentsJoinedByString:@","];
    
    _postData = [NSString stringWithFormat:@"t  utor_id=%@&topic=%@&description=%@&start_time=%@&end_time=%@&days=%@&lesson_date=%@&duration=%@&is_rec=%@&student_list=%@&req_sender=%@&end_date=%@", tutor_id,topic,topicDetail,startTime,endTime,days,lesson_date,minsStr,is_recur,studentlist,trigger,endLessonDate];
    
    webservice=2;
    [kappDelegate ShowIndicator];
    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/create-lesson.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength:0];
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
                NSString*greatest_last_updated =[userDetailDict valueForKey:@"greatest_last_updated"];
                
                if (![greatest_last_updated isKindOfClass:[NSNull class]])
                {
                    [[NSUserDefaults standardUserDefaults ]setValue:greatest_last_updated forKey:@"student_greatest_last_updated"];
                }
                
                NSArray*studentList =[userDetailDict valueForKey:@"student_list"];
                if (studentList.count>0)
                {
                    [self saveDataToDataBase:studentList];
                }
                [self getStudentDetailFromDataBase];
                webservice=0;
            }
            else if (webservice==2)
            {
                NSString*messageStr= [userDetailDict valueForKey:@"message"];
                
                if ([messageStr isEqualToString:@"success"])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"Your lesson added successfully."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    alert.tag=2;
                    webservice=0;
                    
                    
                    //----applying to update the database for new lesson record added
                   
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"try again."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }else if(webservice==3)
            {
                           }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    if (alertView.tag==2)
    {
        topicTxt.text=@"";
        descriptionTxt.text=@"";
        startDateLbl.text=@"";
        endDateLbl.text=@"";
        startTimeLbl.text=@"";
        endTimeLbl.text=@"";
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==3 && buttonIndex != alertView.cancelButtonIndex)
    {
        AddStudentViewController*addStudentVc=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
        addStudentVc.triggervalue= @"add";
        addStudentVc.trigger=@"Tutor";
        [self.navigationController pushViewController: addStudentVc animated:YES];
    }
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([getDate  isEqualToString:@"Start"]||[getDate isEqualToString:@"End"] )
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSLog(@"%@",datePicker.date);
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dateSelected=strDate;
}

- (IBAction)doneDateSelectionBttn:(id)sender
{
    
    if ([getDate  isEqualToString:@"Start"])
    {
        
        NSDateFormatter*df=[[NSDateFormatter alloc]init];
        
        [df setDateFormat:@"HH:mm"];
        NSDate*dateSet;
        if([dateSelected isEqualToString:@"-Select Time-"])
        {
            NSString *abc = [NSString stringWithFormat:@"%@",[NSDate date]];
            dateSet=[NSDate date];
        }else{
        dateSet=[df dateFromString:dateSelected];
        }
        
        NSInteger minuteInterval = 10;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:dateSet];
        NSInteger minutes = [dateComponents minute];
        
        float minutesF = [[NSNumber numberWithInteger:minutes] floatValue];
        float minuteIntervalF = [[NSNumber numberWithInteger:minuteInterval] floatValue];
        
        // Determine whether to add 0 or the minuteInterval to time found by rounding down
        NSInteger roundingAmount = (fmodf(minutesF, minuteIntervalF)) > minuteIntervalF/2.0 ? minuteInterval : 0;
        NSInteger minutesRounded = ( (NSInteger)(minutes / minuteInterval) ) * minuteInterval;
        NSDate *roundedDate = [[NSDate alloc] initWithTimeInterval:60.0 * (minutesRounded + roundingAmount - minutes) sinceDate:dateSet];
        
        
        dateSelected=[df stringFromDate:roundedDate];
        
        
        startTimeLbl.text=dateSelected;
        
        NSString *time1 =dateSelected;
        NSString *time2 = endTimeLbl.text;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"HH:mm"];
        
        NSDate *dateS1= [formatter1 dateFromString:time1];
        NSDate *dateE2 = [formatter1 dateFromString:time2];
        
        NSComparisonResult result1 = [dateS1 compare:dateE2];
        if(result1 == NSOrderedDescending)
        {
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"HH:mm"];
            NSLog(@"%@",[DateFormatter stringFromDate:dateS1]);
            
            NSTimeInterval secondsInOneHours = 1* 60 * 60;
            NSDate *dateOneHoursAhead = [dateS1 dateByAddingTimeInterval:secondsInOneHours];
            NSString*endTime=[DateFormatter stringFromDate:dateOneHoursAhead];
            
            endTimeLbl.text=endTime;
            
        }
        else if(result1 == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
        }
        else
        {
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"HH:mm"];
            NSLog(@"%@",[DateFormatter stringFromDate:dateS1]);
            NSTimeInterval secondsInOneHours = 1* 60 * 60;
            NSDate *dateOneHoursAhead = [dateS1 dateByAddingTimeInterval:secondsInOneHours];
            NSString*endTime=[DateFormatter stringFromDate:dateOneHoursAhead];
            
            endTimeLbl.text=endTime;
        }
    }
    
    
    
    else if ([getDate isEqualToString:@"End"])
    {
        
        NSDateFormatter*df=[[NSDateFormatter alloc]init];
        
        [df setDateFormat:@"HH:mm"];
        
        NSDate*dateSet=[df dateFromString:dateSelected];
        
        
        NSInteger minuteInterval = 10;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:dateSet];
        NSInteger minutes = [dateComponents minute];
        
        float minutesF = [[NSNumber numberWithInteger:minutes] floatValue];
        float minuteIntervalF = [[NSNumber numberWithInteger:minuteInterval] floatValue];
        
        // Determine whether to add 0 or the minuteInterval to time found by rounding down
        NSInteger roundingAmount = (fmodf(minutesF, minuteIntervalF)) > minuteIntervalF/2.0 ? minuteInterval : 0;
        NSInteger minutesRounded = ( (NSInteger)(minutes / minuteInterval) ) * minuteInterval;
        NSDate *roundedDate = [[NSDate alloc] initWithTimeInterval:60.0 * (minutesRounded + roundingAmount - minutes) sinceDate:dateSet];
        
        
        dateSelected=[df stringFromDate:roundedDate];
        NSString *time1 =startTimeLbl.text;
        NSString *time2 = dateSelected;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"HH:mm"];
        
        NSDate *dateS1= [formatter1 dateFromString:time1];
        NSDate *dateE2 = [formatter1 dateFromString:time2];
        
        NSComparisonResult result1 = [dateS1 compare:dateE2];
        if(result1 == NSOrderedDescending)
        {
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"HH:mm"];
            NSLog(@"%@",[DateFormatter stringFromDate:dateS1]);
            
            NSTimeInterval secondsInOneHours = 1* 60 * 60;
            NSDate *dateOneHoursAhead = [dateS1 dateByAddingTimeInterval:secondsInOneHours];
            NSString*endTime=[DateFormatter stringFromDate:dateOneHoursAhead];
            dateSelected=endTime;
        }
        else if(result1 == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
        }
        else
        {
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"HH:mm"];
            NSLog(@"%@",[DateFormatter stringFromDate:dateE2]);
            
            NSTimeInterval secondsInOneHours = 1* 60 * 60;
            NSDate *dateOneHoursAhead;
            if (![time1 isEqualToString:@"-Select Time-"]){
                dateOneHoursAhead = [dateS1 dateByAddingTimeInterval:secondsInOneHours];
            }else{
                dateOneHoursAhead = [dateE2 dateByAddingTimeInterval:secondsInOneHours];
            }
            NSString*endTime=[DateFormatter stringFromDate:dateOneHoursAhead];
            dateSelected=endTime;
        }
        
        endTimeLbl.text=dateSelected;
    }
    else if([getDate isEqualToString:@"LessonStart"])
    {
        NSDate *currentDate = [NSDate date];
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *selectedDate;
        if([dateSelected isEqualToString:@"-Select Start Date-"])
        {
         selectedDate = [NSDate date];
        dateSelected = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
            NSArray *ab = [dateSelected componentsSeparatedByString:@" "];
            dateSelected = [ab objectAtIndex:0];
        }else{
        selectedDate = [DateFormatter dateFromString:dateSelected];
        }
        NSString *compairDate = [DateFormatter stringFromDate:currentDate];
        currentDate = [DateFormatter dateFromString:compairDate];
        
        [DateFormatter setDateFormat:@"HH:mm"];
        NSString *compairTime = [DateFormatter stringFromDate:currentTime];
        currentTime = [DateFormatter dateFromString:compairTime];
        NSDate *startTime = [DateFormatter dateFromString:startTimeLbl.text];
        
        if ([currentDate compare:selectedDate] == NSOrderedSame) {
            if ([startTime compare:currentTime] == NSOrderedAscending) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutor Helper" message:[NSString stringWithFormat:@"%@ is passed away. Please select future time.",startTimeLbl.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }else{
                startDateLbl.text=dateSelected;
                [self GetDayDifference:dateSelected :endDateLbl.text ];
            }
        }else if ([currentDate compare:selectedDate] == NSOrderedAscending){
            
            startDateLbl.text=dateSelected;
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *selectedDate = [DateFormatter dateFromString:dateSelected];
            NSDateComponents *dateComponents = [NSDateComponents new];
            dateComponents.day = 1;
            
            NSDate *currentDatePlus6Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:selectedDate options:0];
            NSLog(@"Date = %@", currentDatePlus6Month);
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            dateSelected=[DateFormatter stringFromDate:currentDatePlus6Month];
            endDateLbl.text=dateSelected;
            [self GetDayDifference:dateSelected :endDateLbl.text ];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutor Helper" message:[NSString stringWithFormat:@" Please select future Date."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        endDateLbl.text=dateSelected;
        [self GetDayDifference:startDateLbl.text :dateSelected ];
    }
    pickerBackView.hidden=YES;
}



- (IBAction)cancelDateSelectionBttn:(id)sender {
    dateSelected=@"";
    pickerBackView.hidden=YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)mondayBttn:(id)sender {
    if (![daysArray containsObject:@"Monday"])
    {
        [daysArray addObject:@"Monday"];
        [mondayImg setImage:[UIImage imageNamed:@"mark.png"]];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:2]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else
    {
        [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Monday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:2]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
    
}

- (IBAction)tuesdayBttn:(id)sender {
    if (![daysArray containsObject:@"Tuesday"])
    {
        [daysArray addObject:@"Tuesday"];
        [tuesdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:3]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else{
        [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Tuesday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:3]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
}

- (IBAction)wednesdaybttn:(id)sender {
    if (![daysArray containsObject:@"Wednesday"])
    {
        [ wednesdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray addObject:@"Wednesday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:4]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else{
        [ wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Wednesday"];
        if ([is_recur isEqualToString:@"NO"]) {
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:4]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
    
}

- (IBAction)thursdatBttn:(id)sender {
    if (![daysArray containsObject:@"Thursday"])
    {
        [thursdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray addObject:@"Thursday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:5]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            if (endSelectedDateArray.count == 0) {
                endDateLbl.text = @"";
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    else{
        [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Thursday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:5]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
    
}

- (IBAction)fridayBttn:(id)sender {
    if (![daysArray containsObject:@"Friday"])
    {
        [fridayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray addObject:@"Friday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:6]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else{
        [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Friday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:6]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
}

- (IBAction)saturdayBttn:(id)sender {
    if (![daysArray containsObject:@"Saturday"])
    {
        [saturdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray addObject:@"Saturday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:7]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else{
        [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Saturday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:7]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
}

- (IBAction)sundayBttn:(id)sender {
    if (![daysArray containsObject:@"Sunday"])
    {
        [sundayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray addObject:@"Sunday"];
        if ([is_recur isEqualToString:@"NO"]) {
            
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:1]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray addObject:theDate];
            endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
        }
    }
    else{
        [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeObject:@"Sunday"];
        if ([is_recur isEqualToString:@"NO"]) {
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            NSLog(@"current locale: %@", locale);
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]]; // force US locale, because other countries (e.g. the rest of the world) might use different weekday numbering
            
            NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
            [nowComponents setWeekOfYear:nowComponents.weekOfYear+1];
            [nowComponents setWeekday:1]; //Sunday
            [nowComponents setHour:0]; // 12:00 AM = midnight (12:00 PM would be 12)
            [nowComponents setMinute:0];
            [nowComponents setSecond:0];
            
            NSDate *previousSunday = [calendar dateFromComponents:nowComponents];
            NSLog(@"sundaysDate: %@", previousSunday);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyy-MM-dd"];
            NSString *theDate = [dateFormatter stringFromDate:previousSunday];
            [endSelectedDateArray removeObject:theDate];
            if (endSelectedDateArray.count == 0) {
                NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
                [deltaComps setDay:1];
                NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd"];
                NSString *theDate = [dateFormatter stringFromDate:tomorrow];
                endDateLbl.text = [NSString stringWithFormat:@"%@",theDate];
            }else{
                endDateLbl.text = [NSString stringWithFormat:@"%@",[endSelectedDateArray objectAtIndex:[endSelectedDateArray count]-1]];
            }
        }
    }
    if (daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
    }
}


- (IBAction)daysBttn:(id)sender
{
    
    if ( daysArray.count<7)
    {
        [alldaysImg setImage:[UIImage imageNamed:@"mark.png"]];
        [sundayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [saturdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [fridayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [thursdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [wednesdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [tuesdayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [mondayImg setImage:[UIImage imageNamed:@"mark.png"]];
        [daysArray removeAllObjects];
        [daysArray addObject:@"Sunday"];
        [daysArray addObject:@"Monday"];
        [daysArray addObject:@"Tuesday"];
        [daysArray addObject:@"Wednesday"];
        [daysArray addObject:@"Thursday"];
        [daysArray addObject:@"Friday"];
        [daysArray addObject:@"Saturday"];
    }
    else{
        [alldaysImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
        [daysArray removeAllObjects];
    }
}


-(void)fetchStudentList{
    webservice=1;
    [kappDelegate ShowIndicator];
    
    NSString*tutorId;
    NSString*parentId;
    
    NSString* last_updated_date=[[NSUserDefaults standardUserDefaults ]valueForKey:@"student_greatest_last_updated"];
    if (last_updated_date==nil) {
        last_updated_date=@"";
    }
    last_updated_date=@"";
    if ([trigger isEqualToString:@"Tutor"])
    {
        tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        parentId=@"-1";
    }
    else
    {
        parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        tutorId=@"-1";
    }
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&last_updated_date=%@",parentId,tutorId,last_updated_date];
    
    
    NSMutableURLRequest*  request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-student.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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

-(void)saveDataToDataBase :(NSArray*)studentList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from StudentList "];
    [database executeUpdate:deleteQuery];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM StudentList "];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *student_idarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [student_idarray addObject:[results stringForColumn:@"student_id"]];
    }
    for (int i=0; i<studentList.count; i++)
    {
        NSString*tutorId,*parentId;
        if ([trigger isEqualToString:@"Tutor"])
        {
            tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
            parentId=@"";
        }
        else
        {
            parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
            tutorId=@"";
        }
        
        NSDictionary*tempDict=[studentList objectAtIndex:i];
        NSString*student_id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"student_id"]];
        
        if ([student_idarray containsObject:student_id])
        {
            NSString *updateSQL ;
            if ([trigger isEqualToString:@"Tutor"])
            {
                tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
                updateSQL = [NSString stringWithFormat:@"UPDATE StudentList SET parent_id = \"%@\" , name = \"%@\", email = \"%@\", contact_info =\"%@\", gender = \"%@\" ,address = \"%@\" ,fee =\"%@\", isActiveInMonth = \"%@\" ,notes=\"%@\" ,TUTORID = \"%@\" where student_id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],[tempDict valueForKey:@"notes"],tutorId,[tempDict valueForKey:@"student_id"] ];
            }
            else
            {
                updateSQL = [NSString stringWithFormat:@"UPDATE StudentList SET parent_id = \"%@\" , name = \"%@\", email = \"%@\", contact_info =\"%@\", gender = \"%@\" ,address = \"%@\" ,fee =\"%@\", isActiveInMonth = \"%@\" ,notes=\"%@\" where student_id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],[tempDict valueForKey:@"notes"],[tempDict valueForKey:@"student_id"] ];
            }
            [database executeUpdate:updateSQL];
        }
        else
        {
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO StudentList (parent_id, name, email, contact_info, gender, address,fee,isActiveInMonth,student_id,notes,TUTORID,PARENTID) VALUES (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],[tempDict valueForKey:@"student_id"],[tempDict valueForKey:@"notes"],tutorId,parentId];
            [database executeUpdate:insert];
        }
    }
    [database close];
}

-(void)getStudentDetailFromDataBase{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    if ([trigger isEqualToString:@"Tutor"])
    {
        NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        queryString = [NSString stringWithFormat:@"Select * FROM StudentList where TUTORID=\"%@\" ",tutorId];
    }
    else
    {
        NSString* parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        queryString = [NSString stringWithFormat:@"Select * FROM StudentList where parent_id=\"%@\" ",parentId];
    }
    
    FMResultSet *results = [database executeQuery:queryString];
    studentListArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        StudentList*StudentObj=[[StudentList alloc]init];
        
        StudentObj.studentId =[results stringForColumn:@"student_id"];
        StudentObj.parentId =[results stringForColumn:@"parent_id"];
        StudentObj.studentName =[results stringForColumn:@"name"];
        StudentObj.gender =[results stringForColumn:@"gender"];
        StudentObj.studentEmail =[results stringForColumn:@"email"];
        StudentObj.address =[results stringForColumn:@"address"];
        StudentObj.studentContact=[results stringForColumn:@"contact_info"];
        StudentObj.fees=[results stringForColumn:@"fee"];
        StudentObj.isActiveInMonth=[results stringForColumn:@"isActiveInMonth"];
        StudentObj.notes=[results stringForColumn:@"notes"];
        
        [studentListArray addObject:StudentObj];
    }
    [database close];
    [studentTableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [studentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UILabel*backLbl= [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 300,70)];
    backLbl.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:backLbl ];
    
    UILabel*studentNameLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 280,30)];
    studentNameLbl.backgroundColor = [UIColor clearColor];
    studentNameLbl.numberOfLines=1;
    studentNameLbl.font =  [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:studentNameLbl ];
    
    UILabel*studentIdLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 120,30)];
    studentIdLbl.backgroundColor = [UIColor clearColor];
    studentIdLbl.numberOfLines=1;
    studentIdLbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:studentIdLbl ];
    
    UILabel*parentIdLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 150,30)];
    parentIdLbl.backgroundColor = [UIColor clearColor];
    parentIdLbl.font = [UIFont boldSystemFontOfSize:13];
    parentIdLbl.numberOfLines=1;
    [cell.contentView addSubview:parentIdLbl ];
    
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(261,5, 23, 23)];
    
    if (IS_IPHONE_6 )
    {
        imv.frame=CGRectMake(311,22, 23, 23);
        parentIdLbl.frame= CGRectMake(10, 40, 350,30);
        studentIdLbl.frame= CGRectMake(10, 22, 320,30);
        studentNameLbl.frame=CGRectMake(10, 1, 380,30);
        backLbl.frame= CGRectMake(5, 1, 404,70);
        
    }
    
    if ( IS_IPHONE_6P)
    {
        imv.frame=CGRectMake(345,22, 23, 23);
        parentIdLbl.frame= CGRectMake(10, 40, 350,30);
        studentIdLbl.frame= CGRectMake(10, 22, 320,30);
        studentNameLbl.frame=CGRectMake(10, 1, 380,30);
        backLbl.frame= CGRectMake(5, 1, 404,70);
        
    }
    
    [studentNameLbl setTextColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    
    
    StudentList*studentListObj = [studentListArray objectAtIndex:indexPath.row];
    
    
    if ([tempStudentArray containsObject:studentListObj.studentId])
    {
        imv.image=[UIImage imageNamed:@"mark.png"];
    }
    else{
        imv.image=[UIImage imageNamed:@"unmark.png"];
    }
    
    imv.tag=indexPath.row+1000;
    [cell.contentView addSubview:imv];
    
    cell.backgroundColor=[UIColor clearColor];
    
    parentIdLbl.text=[NSString stringWithFormat:@"Parent Id:%@",studentListObj.parentId];
    studentIdLbl.text=[NSString stringWithFormat:@"Student Id:%@",studentListObj.studentId];
    studentNameLbl.text=[NSString stringWithFormat:@"%@",studentListObj.studentName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
    StudentList *studObj1 = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
    
    //  NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *check1 = (UIImageView*)[cell.contentView viewWithTag:indexPath.row+1000];
    
    if ([tempStudentArray containsObject:studObj1.studentId]) {
        [tempStudentArray removeObject:studObj1.studentId];
    }
    else{
        [tempStudentArray addObject:studObj1.studentId];
    }
    [studentTableView reloadData];
    
}

-(void)GetDayDifference :(NSString*)strtDate :(NSString*)endDate
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *StartDate=[DateFormatter dateFromString:strtDate];
    NSDate *EndDate=[DateFormatter dateFromString:endDate];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&StartDate
                 interval:NULL forDate:StartDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&EndDate
                 interval:NULL forDate:EndDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:StartDate toDate:EndDate options:0];
    
    NSLog(@"Diff = %ld", (long)difference.day);
    
    
    daysBtn.userInteractionEnabled=NO;
    mondayBtn.userInteractionEnabled=NO;
    tuesDayBtn.userInteractionEnabled=NO;
    wednesdayBtn.userInteractionEnabled=NO;
    thursdayBtn.userInteractionEnabled=NO;
    fridayBtn.userInteractionEnabled=NO;
    saturdayBtn.userInteractionEnabled=NO;
    sundayBtn.userInteractionEnabled=NO;
    
    daysLBL.textColor = [UIColor grayColor];
    [daysBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mondayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tuesDayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [wednesdayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [thursdayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [fridayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [saturdayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sundayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    if (difference.day>=6)
    {
        
        daysBtn.userInteractionEnabled=YES;
        mondayBtn.userInteractionEnabled=YES;
        tuesDayBtn.userInteractionEnabled=YES;
        wednesdayBtn.userInteractionEnabled=YES;
        thursdayBtn.userInteractionEnabled=YES;
        fridayBtn.userInteractionEnabled=YES;
        saturdayBtn.userInteractionEnabled=YES;
        sundayBtn.userInteractionEnabled=YES;
        
        daysLBL.textColor = [UIColor blackColor];
        [daysBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    else
    {
        //  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:StartDate];
        NSDateComponents *comps1 = [calendar components:NSWeekdayCalendarUnit fromDate:EndDate];
        
        int Strtweekday = [comps weekday];
        int Endweekday = [comps1 weekday];
        
        if (Strtweekday ==1)
        {
            if (difference.day==0)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                sundayBtn.userInteractionEnabled=YES;
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
            else if (difference.day==1)
            {
                
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
            }
        }
        
        if (Strtweekday ==2)
        {
            if (difference.day==0)
            {
                
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                
            }
            else if (difference.day==2)
            {
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Sunday"])
                {
                    [sundayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
        }
        if (Strtweekday ==3)
        {
            if (difference.day==0)
            {
                
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                tuesDayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
            }
        }
        if (Strtweekday ==4)
        {
            if (difference.day==0)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                wednesdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                
                
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
            }
        }
        if (Strtweekday ==5)
        {
            if (difference.day==0)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                thursdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                thursdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                
            }
        }
        if (Strtweekday ==6)
        {
            if (difference.day==0)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                if ([daysArray containsObject:@"Saturday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Saturday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                fridayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                saturdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                sundayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                mondayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                tuesDayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fridayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                wednesdayBtn.userInteractionEnabled=YES;
                fridayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                mondayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                
            }
            
        }
        if (Strtweekday ==7)
        {
            if (difference.day==0)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                if ([daysArray containsObject:@"Sunday"])
                {
                    [saturdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Sunday"];
                }
                
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==1)
            {
                if ([daysArray containsObject:@"Monday"])
                {
                    [mondayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Monday"];
                }
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                saturdayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==2)
            {
                if ([daysArray containsObject:@"Tuesday"])
                {
                    [tuesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Tuesday"];
                }
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                mondayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==3)
            {
                if ([daysArray containsObject:@"Wednesday"])
                {
                    [wednesdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Wednesday"];
                }
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==4)
            {
                if ([daysArray containsObject:@"Thursday"])
                {
                    [thursdayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Thursday"];
                }
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
            }
            else if (difference.day==5)
            {
                if ([daysArray containsObject:@"Friday"])
                {
                    [fridayImg setImage:[UIImage imageNamed:@"unmark.png"]];
                    [daysArray removeObject:@"Friday"];
                }
                
                [sundayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mondayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [tuesDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wednesdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [saturdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [thursdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                mondayBtn.userInteractionEnabled=YES;
                sundayBtn.userInteractionEnabled=YES;
                saturdayBtn.userInteractionEnabled=YES;
                tuesDayBtn.userInteractionEnabled=YES;
                wednesdayBtn.userInteractionEnabled=YES;
                thursdayBtn.userInteractionEnabled=YES;
                
            }
        }
    }
}

-(void) compairTimeSlots
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *startDate = [NSString stringWithFormat:@"%@",startDateLbl.text];
    NSString *endDate = [NSString stringWithFormat:@"%@",endDateLbl.text];
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM LessonSlots where lesson_date>=\"%@\" and lesson_date <=\"%@\" ",startDate,endDate];
    
    FMResultSet *results = [database executeQuery:queryString];
     count = 0;
    while([results next])
    {
        count++;
        NSString *startTimeStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_start_timing"]];
        NSString *endTimeStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_end_timing"]];
        NSString *lessonDescpStr = [NSString stringWithFormat:@"%@",[results stringForColumn:@"lesson_description"]];
        NSLog(@"%@ , %@", startTimeStr,endTimeStr);
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"HH:mm:ss"];
        
        NSDate *timeS1= [formatter1 dateFromString:startTimeStr];
        NSDate *timeE1 = [formatter1 dateFromString:endTimeStr];
        [formatter1 setDateFormat:@"HH:mm"];
        NSString *startT = [formatter1 stringFromDate:timeS1];
        NSString *endT = [formatter1 stringFromDate:timeE1];
        timeS1 = [formatter1 dateFromString:startT];
        timeE1 = [formatter1 dateFromString:endT];
        NSDate *timeS2= [formatter1 dateFromString:[NSString stringWithFormat:@"%@",startTimeLbl.text]];
        NSDate *timeE2 = [formatter1 dateFromString:[NSString stringWithFormat:@"%@",endTimeLbl.text]];
        NSLog(@"%@ , %@, %@, %@", timeS1,timeS2,timeE1,timeE2);
        NSComparisonResult firstSlotResult1 = [timeS1 compare:timeE2];
        NSComparisonResult secondSlotResult1 = [timeE1 compare:timeS2];
        
        if (firstSlotResult1 == NSOrderedAscending && secondSlotResult1 == NSOrderedDescending) {
            NSLog(@"Overlap Exist");
            isSlotAvailable = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutor helper" message:[NSString stringWithFormat:@"Time Slot for this slot is already booked for %@.",lessonDescpStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }else{
            isSlotAvailable = YES;
            NSLog(@"No Overlap Exist");
        }
    }
    if(count==0)
    {
    isSlotAvailable = YES;
    NSLog(@"No Overlap Exist");
    }
}



@end
