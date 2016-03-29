//
//  lessonDetailsViewController.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "lessonDetailsViewController.h"
#import "StudentLessonDetailTableViewCell.h"
#import "StudentDetailViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "PDFReportsViewController.h"
@interface lessonDetailsViewController ()

@end

@implementation lessonDetailsViewController
@synthesize lessondetailObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    detailBgLbl.layer.borderColor=[UIColor clearColor].CGColor;
    detailBgLbl.layer.borderWidth=2.0f;
    detailBgLbl.layer.cornerRadius=5.0;
    
    detailBgLbl.clipsToBounds = YES;
    detailBgLbl.layer.masksToBounds = YES;
    
    descriptionLbl.text=lessondetailObj.lesson_description;
    recuringLbl.text=lessondetailObj.lesson_is_recurring;
    endDateLbl.text=lessondetailObj.end_date;
    startDateLbl.text=lessondetailObj.lesson_date;
    durationLbl.text=[NSString stringWithFormat:@"%@",lessondetailObj.lesson_duration];
    numberOfStudentsLbl.text = [NSString stringWithFormat:@"%@",lessondetailObj.noOfStudents];
    studentListArray=lessondetailObj.studentArrayList;
//
    NSString*startTimeStr=lessondetailObj.lesson_start_time;
    NSString*endTimeStr=lessondetailObj.lesson_end_time;
    
    startTimeStr=[startTimeStr substringToIndex:5];
    endTimeStr=[endTimeStr substringToIndex:5];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    
    timeLbl.text=lessonTime;
//
//    NSArray *daysArray = [lessondetailObj.lesson_days componentsSeparatedByString:@","];
//
    tutornameLbl.text=lessondetailObj.tutor_name;
    
    [studentTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *feesStr;
    if([[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_fee"]] isEqualToString:@"<null>"])
    {
        feesStr =@"0";
    }else{
        feesStr =[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_fee"]];
    }

    
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_name"]] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_email"]] :[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_contact_info"]]:[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_address"]]:[NSString stringWithFormat:@"%@",feesStr]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    NSDictionary*dict = [studentListArray objectAtIndex:indexPath.row];
    StudentList*studentObj=[[StudentList alloc]init];
    
    studentObj.studentId=[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_id"]];
    studentObj.studentName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_name"]];
    studentObj.address=[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_address"]];
    studentObj.studentContact=[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_contact_info"]];
    studentObj.studentEmail=[NSString stringWithFormat:@"%@",[dict valueForKey:@"student_email"]];
    studentObj.isActive=[NSString stringWithFormat:@"%@",[dict valueForKey:@"isactive"]];

    
    StudentDetailViewController*studentDetailVc=[[StudentDetailViewController alloc]initWithNibName:@"StudentDetailViewController" bundle:[NSBundle mainBundle]];
    studentDetailVc.editBtnHiddn=YES;
    
    
    studentDetailVc.StudentObj=studentObj;
    [self.navigationController pushViewController:studentDetailVc  animated:YES];
}

- (IBAction)btnGenerateReport:(id)sender {
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    webservice=2;
    _postData = [NSString stringWithFormat:@"month=%@&lesson_ids=%@",self.date_selected,self.selected_id];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/month-report.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (IBAction)backBttn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
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
    
    if (webservice==2) {
        NSArray *data = [userDetailDict valueForKey:@"lesson_data"];
        Session_Dates = [[data valueForKey:@"session_dates"] objectAtIndex:0];
        
        PDFReportsViewController *obj = [[PDFReportsViewController alloc]initWithNibName:@"PDFReportsViewController" bundle:nil];
        obj.lessondetailObj1 = self.lessondetailObj;
        obj.session = Session_Dates;
        obj.date =_date_selected;
        [self.navigationController pushViewController:obj animated:YES];
       
    }
}
@end
