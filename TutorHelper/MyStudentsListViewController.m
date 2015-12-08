//
//  MyStudentsListViewController.m
//  TutorHelper
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MyStudentsListViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "StudentList.h"
#import "StudentDetailTableViewCell.h"
#import "AddStudentViewController.h"
#import "StudentDetailViewController.h"
#import "StudentLessonDetailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface MyStudentsListViewController ()

@end

@implementation MyStudentsListViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self fetchStudentList];
}

-(void)fetchStudentList{
    webservice=1;
    [kappDelegate ShowIndicator];
    
    parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    NSString* last_updated_date=[[NSUserDefaults standardUserDefaults ]valueForKey:@"student_greatest_last_updated"];
    if (last_updated_date == nil)
    {
        last_updated_date=@"";
    }
    last_updated_date=@"";
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=-1&last_updated_date=%@",parentId,last_updated_date];
    
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-student.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [self postWebService];
}
-(void) postWebService{
    
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"Your note updated successfully."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=2;
                [alert show];
            }
        }
    }
}
-(void)saveDataToDataBase :(NSArray*)studentList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
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
        NSDictionary*tempDict=[studentList objectAtIndex:i];
        NSString*student_id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"student_id"]];
        
        if ([student_idarray containsObject:student_id])
        {
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE StudentList SET parent_id = \"%@\" , name = \"%@\", email = \"%@\", contact_info =\"%@\", gender = \"%@\" ,address = \"%@\" ,fee =\"%@\", isActiveInMonth = \"%@\" ,notes=\"%@\" where student_id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],notesStr,[tempDict valueForKey:@"student_id"] ];
            [database executeUpdate:updateSQL];
        }
        else{
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO StudentList (parent_id, name, email, contact_info, gender, address,fee,isActiveInMonth,student_id,notes,TUTORID,PARENTID) VALUES (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],[tempDict valueForKey:@"student_id"],notesStr,tutorId,parentId];
            [database executeUpdate:insert];
        }
    }
    [database close];
}

-(void)getStudentDetailFromDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM StudentList where parent_id=\"%@\"  ",parentId];
    
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
    [studentsTableView reloadData];
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
    
    studentListObj = [studentListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    
    
    NSString*studentIdNameStr=[NSString stringWithFormat:@"%@(%@)",studentListObj.studentName,studentListObj.studentId];
    
    [cell setLabelText:studentIdNameStr :[NSString stringWithFormat:@"%@",studentListObj.studentEmail] :[NSString stringWithFormat:@"%@",studentListObj.studentContact]:[NSString stringWithFormat:@"%@",studentListObj.address]: [NSString stringWithFormat:@"%@",studentListObj.fees]];
    

    /////// EDIT BUTTON //////////
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if( IS_IPHONE_6P)
    {
        editBtn.frame = CGRectMake(370.0f, 16.0f,20.0f,20.0f);
    }else if( IS_IPHONE_6)
    {
        editBtn.frame = CGRectMake(335.0f, 16.0f,20.0f,20.0f);
    }
    else{
        editBtn.frame = CGRectMake(270.0f, 16.0f,20.0f,20.0f);
    }
    editBtn.tag = indexPath.row;
    [editBtn addTarget:self action:@selector(EditActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"edit-icon.png"];
    [editBtn setBackgroundColor:[UIColor clearColor]];
    [editBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    [cell.contentView addSubview:editBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    StudentList * studentObj = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
    StudentDetailViewController*studentDetailVc=[[StudentDetailViewController alloc]initWithNibName:@"StudentDetailViewController" bundle:[NSBundle mainBundle]];
    studentDetailVc.StudentObj=studentObj;
    [self.navigationController pushViewController:studentDetailVc  animated:YES];
}

- (IBAction)EditActionBtn:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    StudentList *studObj = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStdentVC.trigger=@"Parent";
    addStdentVC.triggervalue= @"edit";
    addStdentVC.studentListObj= studObj;
    [self.navigationController pushViewController:addStdentVC animated:YES];
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
