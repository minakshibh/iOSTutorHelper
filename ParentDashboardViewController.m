//
//  ParentDashboardViewController.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentDashboardViewController.h"
#import "ConnectionListViewController.h"
#import "StudentRequestViewController.h"
#import "SplashViewController.h"
#import "LessonRequestViewController.h"
#import "MyLessonsViewController.h"
#import "AddLessonViewController.h"
#import "AddStudentViewController.h"
#import "TutorRegistrationViewController.h"
#import "TutorListViewController.h"
#import "MyStudentsListViewController.h"
#import "ParentMergeViewController.h"
#import "StudentMergeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentListViewController.h"
#import "newsFeedViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "downloadInvoiceViewController.h"
@interface ParentDashboardViewController ()

@end

@implementation ParentDashboardViewController

- (void)viewDidLoad {
    
    [[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    [self GetBasicDetailsService];
    userIdLbl.text=[NSString stringWithFormat:@"parent Id : %@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    userNameLbl.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"parent_name"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 300) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 354, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 354, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 168, 300, 210) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    
    [self.view addSubview: calendarView];
    [self.view bringSubviewToFront:buttonsView];
    [calendarView bringSubviewToFront:buttonsView];


    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 300) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 354, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 394, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 260) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dayButtonPressed:(DayButton *)button {
    //For the sake of example, we obtain the date from the button object
    //and display the string in an alert view
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
//    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
//    
//    UIAlertView *dateAlert = [[UIAlertView alloc]
//                              initWithTitle:@"Date Pressed"
//                              message:theDate
//                              delegate:self
//                              cancelButtonTitle:@"Ok"
//                              otherButtonTitles:nil];
//    [dateAlert show];
}

- (void)nextButtonPressed {
    NSLog(@"Next...");
}

- (void)prevButtonPressed {
    NSLog(@"Prev...");
}

- (IBAction)myProfileBttn:(id)sender {
    buttonsView.hidden=YES;
    TutorRegistrationViewController*tutorRegVC=[[TutorRegistrationViewController alloc]initWithNibName:@"TutorRegistrationViewController" bundle:[NSBundle mainBundle]];
    tutorRegVC.trigger=@"edit";
    tutorRegVC.editView=@"Parent";
    [self.navigationController pushViewController:tutorRegVC  animated:YES];
    
}

- (IBAction)tutorListBttn:(id)sender {
    buttonsView.hidden=YES;
    TutorListViewController*tutorListVc=[[TutorListViewController alloc]initWithNibName:@"TutorListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:tutorListVc animated:YES];
}

- (IBAction)myStudentsList:(id)sender {
    buttonsView.hidden=YES;
    
    MyStudentsListViewController*studentsVc=[[MyStudentsListViewController alloc]initWithNibName:@"MyStudentsListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:studentsVc animated:YES];
}

- (IBAction)ParentMerge:(id)sender {
    buttonsView.hidden=YES;

    ParentMergeViewController*parentMergVC=[[ParentMergeViewController alloc]initWithNibName:@"ParentMergeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:parentMergVC animated:YES];
}

- (IBAction)studentMerge:(id)sender {
    buttonsView.hidden=YES;

    StudentMergeViewController*studentMergVC=[[StudentMergeViewController alloc]initWithNibName:@"StudentMergeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:studentMergVC animated:YES];
}

- (IBAction)creditsBtnAction:(id)sender {
    NSString *parentIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    paymentListViewController *paymentVC = [[paymentListViewController alloc] initWithNibName:@"paymentListViewController" bundle:nil];
    paymentVC.paymentType = @"AddCredit";
    paymentVC.parentId = parentIdStr;
    [self.navigationController pushViewController:paymentVC animated:NO];
}

- (IBAction)payentBtnAction:(id)sender {
    NSString *parentIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    paymentListViewController *paymentVC = [[paymentListViewController alloc] initWithNibName:@"paymentListViewController" bundle:nil];
    paymentVC.paymentType = @"PayFees";
    paymentVC.parentId = parentIdStr;
    [self.navigationController pushViewController:paymentVC animated:NO];
}

- (IBAction)newsFeedBtnAction:(id)sender {
    NSString *parentIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    newsFeedViewController *newsFeedVC = [[newsFeedViewController alloc] initWithNibName:@"newsFeedViewController" bundle:nil];
    newsFeedVC.userId = parentIdStr;
    [self.navigationController pushViewController:newsFeedVC animated:NO];
}
- (IBAction)btnInvoice:(id)sender
{
    downloadInvoiceViewController *DIvc = [[downloadInvoiceViewController alloc]initWithNibName:@"downloadInvoiceViewController" bundle:nil];
    [self.navigationController pushViewController:DIvc animated:YES];
    
}
- (IBAction)connectionBttn:(id)sender {
     buttonsView.hidden=YES;
    ConnectionListViewController*connctListVc=[[ConnectionListViewController alloc]initWithNibName:@"ConnectionListViewController" bundle:[NSBundle mainBundle]];
    connctListVc.trigger=@"Parent";
    [self.navigationController pushViewController:connctListVc animated:YES];
    
}

- (IBAction)logOutBttn:(id)sender {
    
    NSString*deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    NSString*UDID=[[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
    
    
     buttonsView.hidden=YES;
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"pin"];
    
    [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]setValue:UDID forKey:@"UDID"];

    
    SplashViewController*splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:splashVc   animated:YES];
}

- (IBAction)studentRequestBttn:(id)sender
{
    buttonsView.hidden=YES;
    StudentRequestViewController*studentReqVc=[[StudentRequestViewController alloc]initWithNibName:@"StudentRequestViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:studentReqVc animated:YES];

}

- (IBAction)menuBttn:(id)sender
{
    if (buttonsView.hidden==YES)
    {
        buttonsView.hidden=NO;
    }
    else{
        buttonsView.hidden=YES;
    }
}

- (IBAction)lessonRequestBttn:(id)sender
{
    buttonsView.hidden=YES;

    LessonRequestViewController*lessonRequstVC=[[LessonRequestViewController alloc]initWithNibName:@"LessonRequestViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Parent";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)myLessons:(id)sender {
    buttonsView.hidden=YES;

    MyLessonsViewController*lessonRequstVC=[[MyLessonsViewController alloc]initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Parent";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)addLessonBttn:(id)sender {
    buttonsView.hidden=YES;

    AddLessonViewController*addLessonVc=[[AddLessonViewController alloc]initWithNibName:@"AddLessonViewController" bundle:[NSBundle mainBundle]];
    addLessonVc.trigger=@"Parent";

    [self.navigationController pushViewController: addLessonVc animated:YES];
}

- (IBAction)addNewStudentBttn:(id)sender {
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStdentVC.trigger=@"Parent";
    addStdentVC.triggervalue= @"add";

    [self.navigationController pushViewController:addStdentVC animated:YES];
}

-(void) GetBasicDetailsService{
    NSString*_postData ;
    
    
    NSString *parentId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    
    if (parentId.length>0)
    {
        _postData = [NSString stringWithFormat:@"parent_id=%@",parentId ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail-parent.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webdata==nil)
            {
                webdata = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webdata=nil;
                webdata = [NSMutableData data] ;
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
    webdata =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data>>%@",data);
    webdata=[[NSMutableData alloc]initWithData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webdata length]);
    if ([webdata length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webdata encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    NSLog(@"%@",userDetailDict);
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
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM ParentProfile"];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *tutorIdarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [tutorIdarray addObject:[results stringForColumn:@"parentId"]];
    }
    
    NSString *parentId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    
    if ([tutorIdarray containsObject:parentId])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TutorProfile SET feesCollected = \"%@\", fees_due = \"%@\", activeLessons =\"%@\"  where tutorID =\"%@\"",fee_collected,fee_due,activalessons,parentId];
        [database executeUpdate:updateSQL];
    }
    else{
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO TutorProfile (tutorID, feesCollected, fees_due, activeLessons) VALUES (\"%@\", \"%@\",\"%@\",\"%@\")",parentId,fee_collected,fee_due,activalessons];
        [database executeUpdate:insert];
    }
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from LessonList "];
    [database executeUpdate:deleteQuery];
    
    
    
    for (int i=0; i<lessonList.count; i++)
    {
        NSDictionary*tempDict=[lessonList objectAtIndex:i];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonList (userId, NumberOfLessons, fulldayBlockOut, halfdayBlockOut, lessonDate) VALUES(\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",parentId,[tempDict valueForKey:@"no._of_lessons"],[tempDict valueForKey:@"block_out_time_for_fullday"],[tempDict valueForKey:@"block_out_time_for_halfday"],[tempDict valueForKey:@"lesson_date"]];
        [database executeUpdate:insert];
        
        
    }
    [database close];
    
    
}
@end