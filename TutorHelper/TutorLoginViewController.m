//
//  TutorLoginViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "TutorLoginViewController.h"
#import "TutorFirstViewController.h"
#import "ForgotPasswordViewController.h"
#import "TutorRegistrationViewController.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface TutorLoginViewController ()

@end

@implementation TutorLoginViewController
@synthesize emailAddressTxt,passwordTxt;
- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    self.navigationController.navigationBar.hidden=YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginActionBtn:(id)sender {
    [self.view endEditing:YES];
    

    emailStr=[NSString stringWithFormat:@"%@",emailAddressTxt.text];
    passordStr=[NSString stringWithFormat:@"%@",passwordTxt.text];

    if (emailStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    else if (passordStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSString *_postData = [NSString stringWithFormat:@"tutor_pin=%@&password=%@",emailStr,passordStr];
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webservice=1;
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



- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)signupActionBtn:(id)sender {
    TutorRegistrationViewController*tutorRegVc=[[TutorRegistrationViewController alloc]initWithNibName:@"TutorRegistrationViewController" bundle:[NSBundle mainBundle]];
    tutorRegVc.trigger=@"add";
    [self.navigationController pushViewController:tutorRegVc animated:YES];
}

- (IBAction)forgotPasswordActionBtn:(id)sender
{
    ForgotPasswordViewController*forgotvc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            forgotvc=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:[NSBundle mainBundle]];
        }
        else
        {
            forgotvc=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:[NSBundle mainBundle]];
        }
    }
    emailAddressTxt.text=@"";
    passwordTxt.text=@"";
    forgotvc.trigger=@"tutor";
    [self.navigationController pushViewController:forgotvc animated:YES];
    
}

- (IBAction)MenuBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MoveToTutorFirstView
{
    [[NSUserDefaults standardUserDefaults]setValue:emailStr forKey:@"emailAddress"];
    [[NSUserDefaults standardUserDefaults]setValue:passordStr forKey:@"password"];
    
    TutorFirstViewController*tutorFirstVc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            tutorFirstVc=[[TutorFirstViewController alloc]initWithNibName:@"TutorFirstViewController" bundle:[NSBundle mainBundle]];
        }
        else
        {
            tutorFirstVc=[[TutorFirstViewController alloc]initWithNibName:@"TutorFirstViewController" bundle:[NSBundle mainBundle]];
        }
    }
    [[NSUserDefaults standardUserDefaults ]setValue:@"tutor" forKey:@"role"];
    emailAddressTxt.text=@"";
    passwordTxt.text=@"";
    [self.navigationController pushViewController:tutorFirstVc animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
  

    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        if(webservice==1)
        {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            NSString*tutor_id=[userDetailDict valueForKey:@"tutor_id"];
            [[NSUserDefaults standardUserDefaults]setValue:tutor_id forKey:@"tutor_id"];

            [self saveDataTodtaaBase:userDetailDict];
            
            getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:tutor_id delegate:self webdata:webData trigger:@"Tutor"];
            [self.view addSubview: getDetailView];
            
            //[self GetBasicDetailsService];


        }
        }else if(webservice==2)
        {
            [kappDelegate HideIndicator];
            
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
            webservice=0;
            
            return;
        }

        
    }
     [kappDelegate HideIndicator];
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
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    if ([tutorIdarray containsObject:tutorId])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TutorProfile SET feesCollected = \"%@\", fees_due = \"%@\", activeLessons =\"%@\"  where tutorID =\"%@\"",feesCollectd,feesDue,activLesson,tutorId];
        [database executeUpdate:updateSQL];
    }
    else{
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO TutorProfile (tutorID, feesCollected, fees_due, activeLessons) VALUES (\"%@\", \"%@\",\"%@\",\"%@\")",tutorId,feesCollectd,feesDue,activLesson];
        [database executeUpdate:insert];
    }
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from LessonList "];
    [database executeUpdate:deleteQuery];
    NSString *deleteQuery1 = [NSString stringWithFormat:@"DELETE from LessonSlots "];
    [database executeUpdate:deleteQuery1];
    
    
    for (int i=0; i<lessonList.count; i++)
    {
        NSDictionary*tempDict=[lessonList objectAtIndex:i];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonList (userId, NumberOfLessons, fulldayBlockOut, halfdayBlockOut, lessonDate) VALUES(\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",tutorId,[tempDict valueForKey:@"no._of_lessons"],[tempDict valueForKey:@"block_out_time_for_fullday"],[tempDict valueForKey:@"block_out_time_for_halfday"],[tempDict valueForKey:@"lesson_date"]];
        [database executeUpdate:insert];
        NSArray *lessonSlots = [tempDict valueForKey:@"timing"];
        for (int k = 0; k < lessonSlots.count; k++) {
            NSDictionary*tempLessonSlotsDict=[lessonSlots objectAtIndex:k];
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonSlots (userId,lesson_id, lesson_date, lesson_description, lesson_end_timing, lesson_start_timing) VALUES(\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",tutorId,[tempLessonSlotsDict valueForKey:@"ID"],[tempDict valueForKey:@"lesson_date"],[tempLessonSlotsDict valueForKey:@"description"],[tempLessonSlotsDict valueForKey:@"end_timing"],[tempLessonSlotsDict valueForKey:@"start_timing"]];
            [database executeUpdate:insert];
        }
        
    }
    
    [database close];
}

-(void) GetBasicDetailsService {
    NSString*_postData ;
    webservice=2;
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    if (tutorId.length>0)
    {
        _postData = [NSString stringWithFormat:@"tutor_id=%@",tutorId ];
        
        NSLog(@"data post >>> %@",_postData);
       // [kappDelegate ShowIndicator];
        
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

-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from TutorProfile "];
    [database executeUpdate:deleteQuery];
    
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    [[NSUserDefaults standardUserDefaults]setValue:[userDetailDict valueForKey:@"name"] forKey:@"tutor_name"];


    NSString *insert = [NSString stringWithFormat:@"INSERT INTO TutorProfile (tutorID, name, password, address, contactNumber , alt_contactNumber , gender ,email) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",tutorId,[userDetailDict valueForKey:@"name"],passordStr,[userDetailDict valueForKey:@"address"],[userDetailDict valueForKey:@"contact_number"],[userDetailDict valueForKey:@"alt_c_number"],[userDetailDict valueForKey:@"gender"],[userDetailDict valueForKey:@"email"]];
        [database executeUpdate:insert];
    
    [database close];
}


- (void)ReceivedResponse {
      [self MoveToTutorFirstView];
}

@end
