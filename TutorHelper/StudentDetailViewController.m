//
//  StudentDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "StudentList.h"
#import "AddStudentViewController.h"
#import "MyLessonsViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface StudentDetailViewController ()

@end

@implementation StudentDetailViewController
@synthesize StudentObj,parentObj,editBtnHiddn;

- (void)viewDidLoad {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    backView.layer.borderColor=[UIColor clearColor].CGColor;
    backView.layer.borderWidth=2.0f;
    backView.layer.cornerRadius=5.0;
    backView.clipsToBounds = YES;
    backView.layer.masksToBounds = YES;

    studentNameLbl.text=StudentObj.studentName;
    parentNameLbl.text=parentObj.parentName;
    studentIdLbl.text= [NSString stringWithFormat:@"Student Id : %@",StudentObj.studentId];
    emailAddressLbl.text=StudentObj.studentEmail;
    contactNumbrLbl.text=StudentObj.studentContact;
    feesLbl.text=StudentObj.fees;
    addressLbl.text=StudentObj.address;
    notesLbl.text=StudentObj.notes;
    studentInactiveLbl.hidden = YES;

    if ([StudentObj.isActive isEqualToString:@"1"]) {
        studentInactiveLbl.hidden = NO;
        studentIdLbl.textColor = [UIColor blackColor];
    }
    if (editBtnHiddn)
    {
        editBttn.hidden=YES;
        histryImg.hidden=YES;
        histryLbl.hidden=YES;
        historyBtn.hidden=YES;
    }
    
    if (parentObj==nil)
    {
        histryImg.hidden=NO;
        histryLbl.hidden=NO;
        historyBtn.hidden=NO;
        feeDotsLbl.hidden=YES;
        feesLbl.hidden=YES;
        feeStaticLbl.hidden=YES;
        
        [self getProfileDataFromDataBase];
        backView.frame=CGRectMake(backView.frame.origin.x,backView.frame.origin.y,backView.frame.size.width, backView.frame.size.height-40);
    }
    if (editBtnHiddn)
    {
        feesLbl.hidden=YES;
        feeStaticLbl.hidden=YES;
        feeDotsLbl.hidden=YES;
        editBttn.hidden=YES;
        histryImg.hidden=YES;
        histryLbl.hidden=YES;
        historyBtn.hidden=YES;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editBttn:(id)sender
{
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    if (parentObj==nil)
    {
        addStdentVC.trigger=@"Parent";
    }
    else{
        addStdentVC.trigger=@"Tutor";
        addStdentVC.parentListObj=parentObj;
    }

    addStdentVC.triggervalue= @"edit";
    addStdentVC.studentListObj= StudentObj;
    addStdentVC.fromView=@"studentDetail";
    
    [self.navigationController pushViewController:addStdentVC animated:YES];
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)emailBttn:(id)sender {
    
    NSString*emailAddress=StudentObj.studentEmail;
    
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



- (IBAction)callBttn:(id)sender
{
    NSString*contactNum=StudentObj.studentContact;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactNum ]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)historyBttn:(id)sender
{
    MyLessonsViewController*lessonVc=[[MyLessonsViewController alloc]initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
    lessonVc.dateDetail=@"History";
    lessonVc.studentIdStr=StudentObj.studentId;
    [self.navigationController pushViewController:lessonVc animated:YES];
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


-(void)getProfileDataFromDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
   NSString* parentIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    NSString*queryString = [NSString stringWithFormat:@"Select * FROM ParentProfile where parentId=\"%@\" ",parentIdStr];
    
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        parentNameLbl.text =[results stringForColumn:@"name"];
    }
    [database close];
}




@end
