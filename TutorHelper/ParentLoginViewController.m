//
//  ParentLoginViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentLoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "ParentDashboardViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ParentLoginViewController ()

@end

@implementation ParentLoginViewController
@synthesize emailAddressTxt,passwordTxt;
- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
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

- (IBAction)loginActionBtn:(id)sender
{
    [self.view endEditing:YES];

    emailStr=[NSString stringWithFormat:@"%@",emailAddressTxt.text];
    passordStr=[NSString stringWithFormat:@"%@",passwordTxt.text];
    
    if (emailStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    else if (![self validateEmailWithString:emailAddressTxt.text]==YES)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter valid email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        return;
//
//    }
    else if (passordStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *_postData = [NSString stringWithFormat:@"username=%@&password=%@",emailStr,passordStr];

    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/parent-login.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)forgotPasswordActionBtn:(id)sender
{
    [self.view endEditing:YES];
    emailAddressTxt.text=@"";
    passwordTxt.text=@"";

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
    forgotvc.trigger=@"parent";
    [self.navigationController pushViewController:forgotvc animated:YES];
}


-(void)MoveToParentFirstView
{
    emailAddressTxt.text=@"";
    passwordTxt.text=@"";
    ParentDashboardViewController*parentVc=[[ParentDashboardViewController alloc]initWithNibName:@"ParentDashboardViewController" bundle:[NSBundle mainBundle]];
    [[NSUserDefaults standardUserDefaults ]setValue:@"parent" forKey:@"role"];

    [self.navigationController pushViewController:parentVc animated:YES];
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
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            NSString*parent_id=[userDetailDict valueForKey:@"pin"];
            [[NSUserDefaults standardUserDefaults]setValue:parent_id forKey:@"pin"];
            [self saveDataTodtaaBase:userDetailDict];
            
            getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:parent_id delegate:self webdata:webData trigger:@"Parent"];
            [self.view addSubview: getDetailView];
            
          //  [self MoveToParentFirstView];
        }
    }
}


- (void)ReceivedResponse
{
    [self MoveToParentFirstView];
}



-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from ParentProfile "];
    
    
    [database executeUpdate:deleteQuery];
    NSString *parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    [[NSUserDefaults standardUserDefaults]setValue:[userDetailDict valueForKey:@"name"] forKey:@"parent_name"];

    
    
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO ParentProfile (parentId, name, password, address, contactNumber , alt_contactNumber , gender ,email) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",parentId,[userDetailDict valueForKey:@"name"],passordStr,[userDetailDict valueForKey:@"address"],[userDetailDict valueForKey:@"contact_number"],[userDetailDict valueForKey:@"alt_c_number"],[userDetailDict valueForKey:@"gender"],[userDetailDict valueForKey:@"email"]];
    
    [database executeUpdate:insert];
    [database close];
}

- (IBAction)MenuBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
