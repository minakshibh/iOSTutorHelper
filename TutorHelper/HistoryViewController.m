//
//  HistoryViewController.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryDetailViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize studentIdStr;

- (void)viewDidLoad {
    historyListArray=[[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    for (int k=0;k<3;k++)
    {
        HistoryList*historyobj=[[HistoryList alloc]init];
        
        historyobj.monthName=@"JAN";
        historyobj.parent_id=@"123";
        historyobj.numbrOfLessons=@"10";
        historyobj.outstanding_balance=@"$1234";
        historyobj.feesColllected=@"$1234";
        historyobj.feesDue=@"$122";
        [historyListArray addObject:historyobj];
    }

    
   // [self fetchHistoryWebService];
    
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchHistoryWebService
{
    webservice=1;
    [kappDelegate ShowIndicator];
    
    NSString*_postData = [NSString stringWithFormat:@"student_id=%@",studentIdStr];
    
    
    NSMutableURLRequest*  request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-student-history.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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
        
                
            }
            else
            {
                
            }
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [historyListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    historyListObj=[[HistoryList alloc]init];
    
    historyListObj = [historyListArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:historyListObj.monthName :historyListObj.numbrOfLessons :historyListObj.outstanding_balance :historyListObj.feesColllected :historyListObj.feesDue :historyListObj.yearName :historyListObj.outstandingFees];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
//    HistoryDetailViewController *histryDetailVc=[[HistoryDetailViewController alloc]initWithNibName:@"HistoryDetailViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:histryDetailVc animated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
