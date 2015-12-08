//
//  ParentMergeViewController.m
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentMergeViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>


@interface ParentMergeViewController ()

@end

@implementation ParentMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    backView.layer.borderColor=[UIColor clearColor].CGColor;
    backView.layer.borderWidth=1.0f;
    backView.layer.cornerRadius=4.0;
    backView.clipsToBounds = YES;
    backView.layer.masksToBounds = YES;
    
    

    passwordBackView.layer.borderColor=[UIColor clearColor].CGColor;
    passwordBackView.layer.borderWidth=1.0f;
    passwordBackView.layer.cornerRadius=4.0;
    passwordBackView.clipsToBounds = YES;
    passwordBackView.layer.masksToBounds = YES;
    
    


    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mergeBttn:(id)sender
{
    [self.view endEditing:YES];
    NSString* passwordStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (passwordStr.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter Password to confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self loginWebservice];
 }


-(void)loginWebservice
{
    webservice=1;
    NSString *_postData = [NSString stringWithFormat:@"username=%@&password=%@",parentIdTxt.text,passwordTxt.text];
    
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
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to merge parent." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
                alert.tag=1;
                [alert show];
                
            }
            else if (webservice==2)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Parent merge successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=2;
                [alert show];
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    if (alertView.tag==1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            passwordBackView.hidden=YES;
            passwordTxt.text=@"";
        }
        else
        {
            [self mergeWebservice];
        }
    }
}

-(void)mergeWebservice{
    webservice=2;
    
    
    NSString*parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    
    NSString* _postData = [NSString stringWithFormat:@"first_id=%@&second_id=%@&trigger=Parent", parentId,parentIdTxt.text ];
    
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

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBttn:(id)sender
{
    [self.view endEditing:YES];
    NSString*parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];

    
    
    NSString* parentIdStr = [parentIdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parentIdStr.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter parent Id to merge." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([parentIdStr isEqualToString:parentId])
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter another parent's Id to merge." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    passwordBackView.hidden=NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
