//
//  StudentMergeViewController.m
//  TutorHelper
//
//  Created by Br@R on 20/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentMergeViewController.h"
#import "StudentList.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface StudentMergeViewController ()

@end

@implementation StudentMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    backView.layer.borderColor=[UIColor clearColor].CGColor;
    backView.layer.borderWidth=1.0f;
    backView.layer.cornerRadius=4.0;
    backView.clipsToBounds = YES;
    backView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mergeActionBttn:(id)sender {
    [self.view endEditing:YES];

    NSString* firstStudIdStr = [firstDtudentIdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* secndStudIdStr = [secndStudentIdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
    if (firstStudIdStr.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter student Id." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (secndStudIdStr.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter another student's Id to merge." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([firstStudIdStr isEqualToString:secndStudIdStr])
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter valid student's Id to merge." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self fetchStudentList:firstStudIdStr :secndStudIdStr];

}
-(void)fetchStudentList :(NSString*)firstId :(NSString*)secondId
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString*parentId=[[NSUserDefaults standardUserDefaults]valueForKey:@"pin"];
    
    NSString * queryString = [NSString stringWithFormat:@"Select * FROM StudentList where parent_id=\"%@\"",parentId];
    
    
    FMResultSet *results = [database executeQuery:queryString];
    
    NSMutableArray *studentIdArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        StudentList*StudentObj=[[StudentList alloc]init];
        StudentObj.studentId =[results stringForColumn:@"student_id"];
        [studentIdArray addObject:StudentObj.studentId];
    }
    
    [database close];
    
    if ([studentIdArray containsObject:firstId] && [studentIdArray containsObject:secondId] )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to merge these students?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        alert.tag=1;
        [alert show];
        return;
    }
    
    if (![studentIdArray containsObject:firstId] && ![studentIdArray containsObject:secondId] )
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Student's id doesn't exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    
    
    
    if ([studentIdArray containsObject:firstId])
    {
        if ([studentIdArray containsObject:secondId])
        {
            
        }
        else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Second student id doesn't exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }

    }
    else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"First student id doesn't exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to merge these students?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    alert.tag=1;
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
        }
        else
        {
            [self mergeWebservice];
        }
    }
    if (alertView.tag==2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



-(void)mergeWebservice{
    webservice=1;
    
    NSString* _postData = [NSString stringWithFormat:@"first_id=%@&second_id=%@&trigger=Student", firstDtudentIdTxt.text,secndStudentIdTxt.text ];
    
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/merge-parent.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
                NSString*parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];

                getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:parentId delegate:self webdata:webData trigger:@"Parent"];
                [self.view addSubview: getDetailView];
            }
        }
    }
}


- (void)ReceivedResponse
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Students merge successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag=2;
    [alert show];
}


- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
