//
//  ParentDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentDetailViewController.h"
#import "StudentDetailTableViewCell.h"
#import "HistoryViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AddStudentViewController.h"
#import "StudentDetailViewController.h"
#import "HistoryDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ParentDetailViewController ()

@end

@implementation ParentDetailViewController
@synthesize parentObj,trigger;


- (void)viewDidLoad
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    parenyIdLbl.text=[NSString stringWithFormat:@"Parent Id:%@",parentObj.parent_id];
    headerLbl. text=[NSString stringWithFormat:@"%@",parentObj.parentName];
    contactNubrLbl.text=[NSString stringWithFormat:@":%@",parentObj.contactNumbr];
    emailAddressLbl.text=[NSString stringWithFormat:@":%@",parentObj.parentEmail];
    notesTxtView.text=[NSString stringWithFormat:@"%@",parentObj.notes];
    numbrOfStudntsLbl.text=[NSString stringWithFormat:@":%@",parentObj.numbrOfStudents];
    outstandingBalanceLbl.text=[NSString stringWithFormat:@":$%@",parentObj.balance];
    addressLbl.text=[NSString stringWithFormat:@":%@",parentObj.address];
    notesTxtView.text=parentObj.notes;
 
    CGSize expectedLabelSize2 = [parentObj.parentEmail sizeWithFont:emailAddressLbl.font constrainedToSize:emailAddressLbl.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    
    UIView *viewUnderline2=[[UIView alloc] init];
   
    
    CGSize expectedLabelSize = [parentObj.contactNumbr sizeWithFont:contactNubrLbl.font constrainedToSize:contactNubrLbl.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    
    UIView *viewUnderline=[[UIView alloc] init];
 
    
    if (IS_IPHONE_6P)
    {
           viewUnderline2.frame=CGRectMake(emailAddressLbl.frame.origin.x+48 , emailAddressLbl.frame.size.height+emailAddressLbl.frame.origin.y+15,   expectedLabelSize2.width+3, 1);
           viewUnderline.frame=CGRectMake(contactNubrLbl.frame.origin.x+48 , contactNubrLbl.frame.size.height+contactNubrLbl.frame.origin.y+7,   expectedLabelSize.width+3, 1);
    }
    else if (IS_IPHONE_6)
    {
        viewUnderline2.frame=CGRectMake(emailAddressLbl.frame.origin.x+30 , emailAddressLbl.frame.size.height+emailAddressLbl.frame.origin.y+10,   expectedLabelSize2.width+3, 1);
        viewUnderline.frame=CGRectMake(contactNubrLbl.frame.origin.x+30 , contactNubrLbl.frame.size.height+contactNubrLbl.frame.origin.y+5,   expectedLabelSize.width+3, 1);
    }

    else{
        viewUnderline2.frame=CGRectMake(emailAddressLbl.frame.origin.x , emailAddressLbl.frame.size.height+emailAddressLbl.frame.origin.y,   expectedLabelSize2.width+3, 1);
         viewUnderline.frame=CGRectMake(contactNubrLbl.frame.origin.x , contactNubrLbl.frame.size.height+contactNubrLbl.frame.origin.y,   expectedLabelSize.width+3, 1);
    }
    viewUnderline.backgroundColor=[UIColor blackColor];
    [parentInfoBackView addSubview:viewUnderline];
    viewUnderline2.backgroundColor=[UIColor blackColor];
    [parentInfoBackView addSubview:viewUnderline2];
    parentInfoBackView.layer.borderColor=[UIColor clearColor].CGColor;
    parentInfoBackView.layer.borderWidth=2.0f;
    parentInfoBackView.layer.cornerRadius=5.0;
    parentInfoBackView.clipsToBounds = YES;
    parentInfoBackView.layer.masksToBounds = YES;
   
    notesTxtView.layer.borderColor=[UIColor grayColor].CGColor;
    notesTxtView.layer.borderWidth=1.0f;
    notesTxtView.layer.cornerRadius=1.0;
    notesTxtView.clipsToBounds = YES;
    notesTxtView.layer.masksToBounds = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [self getStudentDetailFromDataBase];
    [self fetchStudentList];
}


- (IBAction)updateBtn:(id)sender
{
    [notesTxtView resignFirstResponder];
  
    NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    NSString*parentId = parentObj.parent_id;
    NSString* notesStr = [notesTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (notesStr.length>0)
    {
        _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&notes=%@&sender=Tutor",parentId,tutorId,notesStr];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter note to update" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    webservice=2;
    [kappDelegate ShowIndicator];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/insert-parents-notes.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [self postWebService];
}

- (IBAction)addStudentBtn:(id)sender
{
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStdentVC.trigger=@"Tutor";
    addStdentVC.triggervalue= @"add";
    addStdentVC.parentListObj=parentObj;
    [self.navigationController pushViewController:addStdentVC animated:YES];
}

- (IBAction)historyBtn:(id)sender {
    HistoryDetailViewController *histryVc=[[HistoryDetailViewController alloc]initWithNibName:@"HistoryDetailViewController" bundle:[NSBundle mainBundle]];
    histryVc.parentIdStr = [NSString stringWithFormat:@"%@",parentObj.parent_id];
    [self.navigationController pushViewController:histryVc animated:YES];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callActionBtn:(id)sender
{
    NSString*contactNum=parentObj.contactNumbr;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactNum ]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)emailActionBtn:(id)sender
{
    
    NSString*emailAddress=parentObj.parentEmail;
    
    NSString * subject = @"";
    //email body
    NSString * body = @"";
    //recipient(s)
    NSArray * recipients = [NSArray arrayWithObjects:emailAddress, nil];
    
    //create the MFMailComposeViewController
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    if (composer==nil) {
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please configure you email id to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    [composer setToRecipients:recipients];
    [self presentViewController:composer animated:YES completion:NULL];
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result)
    {
        case MFMailComposeResultSaved:
        {
            mailAlert.message = @"Message Saved";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            mailAlert.message = @"Message Sent";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [[NSUserDefaults standardUserDefaults] setValue:@"Mail" forKey:@"Mail"];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            mailAlert.message = @"Message Failed";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            //[mailAlert show];
        }
            break;
        default:
            break;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [studentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    StudentDetailTableViewCell *cell = (StudentDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    studentListObj = [studentListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:studentListObj.studentName :[NSString stringWithFormat:@"Email     : %@",studentListObj.studentEmail] :[NSString stringWithFormat:@"Contact : %@",studentListObj.studentContact]:[NSString stringWithFormat:@"Notes     : %@",studentListObj.notes]];
    
    
    /////// EDIT BUTTON //////////
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ( IS_IPHONE_6)
    {
        editBtn.frame = CGRectMake(335.0f, 19.0f,20.0f,20.0f);
    }
    else if (IS_IPHONE_6P )
    {
        editBtn.frame = CGRectMake(370.0f, 19.0f,20.0f,20.0f);
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
    StudentList *studentObj ;
    
    studentObj = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
   
    
    StudentDetailViewController*studentDetailVc=[[StudentDetailViewController alloc]initWithNibName:@"StudentDetailViewController" bundle:[NSBundle mainBundle]];
    studentDetailVc.StudentObj=studentObj;
    studentDetailVc.parentObj=parentObj;

    [self.navigationController pushViewController:studentDetailVc  animated:YES];
}


- (IBAction)EditActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    StudentList *studObj = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
    
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStdentVC.trigger=@"Tutor";
    addStdentVC.triggervalue= @"edit";
    addStdentVC.studentListObj= studObj;
    addStdentVC.parentListObj=parentObj;
    [self.navigationController pushViewController:addStdentVC animated:YES];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return FALSE;
    }
    return TRUE;
}



-(void)fetchStudentList
{
    webservice=1;
    [kappDelegate ShowIndicator];

    NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];

    NSString*parentId = parentObj.parent_id;
    
    NSString* last_updated_date=[[NSUserDefaults standardUserDefaults ]valueForKey:@"student_greatest_last_updated"];
    if (last_updated_date == nil)
    {
        last_updated_date=@"";
    }
     last_updated_date=@"";
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&last_updated_date=%@",parentId,tutorId,last_updated_date];
    
    
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
    NSString*parentId=0;
    
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
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE StudentList SET parent_id = \"%@\" , name = \"%@\", email = \"%@\", contact_info =\"%@\", gender = \"%@\" ,address = \"%@\" ,fee =\"%@\", isActiveInMonth = \"%@\" ,notes=\"%@\" where student_id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],notesStr,[tempDict valueForKey:@"student_id"]];
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

-(void)getStudentDetailFromDataBase{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
     NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM StudentList where TUTORID=\"%@\" AND parent_id=\"%@\"  ",tutorId,parentObj.parent_id ];
    
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
        
        if (![trigger isEqualToString:@"all"])
        {
            if (![StudentObj.isActiveInMonth isEqualToString:@"0"])
            {
                [studentListArray addObject:StudentObj];
            }
        }
        else
        {
            [studentListArray addObject:StudentObj];
        }
    }
    
    [database close];
    [studentTableView reloadData];
}
@end
