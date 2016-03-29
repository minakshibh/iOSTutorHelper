//
//  ConnectionListViewController.m
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ConnectionListViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "ConnectionRequestTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "StudentRequestViewController.h"

@interface ConnectionListViewController ()

@end

@implementation ConnectionListViewController
@synthesize trigger;
- (void)viewDidLoad {
    
   requestTableView.tableFooterView = [[UIView alloc] init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    connctListObj=[[ConnectRequset alloc]init];

    [self FetchConnectionList];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
                connectionRequestListArray =[[NSMutableArray alloc]init];
                NSArray*requestArray=[userDetailDict valueForKey:@"request_list"];
                connctListObj=[[ConnectRequset alloc]init];
//                if (requestArray.count>0) {
//                    requestArray=[requestArray objectAtIndex:0];
//                }
                
                for(int k=0;k<[requestArray count];k++)
                {
                    ConnectRequset*connctObj=[[ConnectRequset alloc]init];
                    connctObj.parent_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k]valueForKey:@"parent_id" ]];
                    connctObj.parent_name=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"parent_name"]];
                    connctObj.tutor_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"tutor_id"]];
                    connctObj.tutor_name=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"tutor_name"]];
                    connctObj.request_id=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"request_id"]];

                    [connectionRequestListArray addObject:connctObj];
                    
              
                }
                
                [requestTableView reloadData];
                
                    webservice=0;
            }
            else if (webservice==2){
                [self FetchConnectionList];
                [requestTableView reloadData];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your connection request approved successfully,Now please approve corresponding student requests." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=1;
                [alert show];
            }
            else {
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    if (alertView.tag==1)
    {
        StudentRequestViewController*studentReqVc=[[StudentRequestViewController alloc]initWithNibName:@"StudentRequestViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:studentReqVc animated:YES];

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [connectionRequestListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    ConnectionRequestTableViewCell *cell = (ConnectionRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConnectionRequestTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    connctListObj=[[ConnectRequset alloc]init];
    
    connctListObj = [connectionRequestListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];

    if ([trigger isEqualToString:@"Parent"])
    {
        [cell setLabelText:[NSString stringWithFormat:@"Tutor ID : %@",connctListObj.tutor_id] :[NSString stringWithFormat:@"%@ has sent you a connection request",connctListObj.tutor_name]];
    }
    else{
        [cell setLabelText:[NSString stringWithFormat:@"Parent ID : %@",connctListObj.parent_id] :[NSString stringWithFormat:@"%@ has sent you a connection request",connctListObj.parent_name]];
    }
    
    /////// Reject  BUTTON //////////

    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rejectBtn setTitle: @"edit" forState: UIControlStateNormal];
    
    
    if (IS_IPHONE_6P)
    {
        rejectBtn.frame = CGRectMake(210.0f, 60.0f,130.0f,24.0f);
    }
   else if (IS_IPHONE_6)
    {
        rejectBtn.frame = CGRectMake(190.0f, 60.0f,130.0f,24.0f);
    }
    else{
        rejectBtn.frame = CGRectMake(160.0f, 60.0f,100.0f,24.0f);
        
    }
    rejectBtn.tag = indexPath.row;
    [rejectBtn setTintColor:[UIColor whiteColor]] ;
    [rejectBtn addTarget:self action:@selector(RejectActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rejectBtn setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:rejectBtn];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"reject.png"];
    [rejectBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    rejectBtn.titleLabel.textColor=[UIColor whiteColor];
    [rejectBtn setTitle:@"REJECT" forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    /////// Connect  BUTTON //////////
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [connectBtn setTitle: @"" forState: UIControlStateNormal];
    
    if (IS_IPHONE_6P)
    {
        connectBtn.frame = CGRectMake(60.0f, 60.0f,130.0f,24.0f);
    }else if (IS_IPHONE_6)
    {
        connectBtn.frame = CGRectMake(40.0f, 60.0f,130.0f,24.0f);
    }
    else{
        connectBtn.frame = CGRectMake(40.0f, 60.0f,100.0f,24.0f);
        
    }

    connectBtn.tag = indexPath.row;
    [connectBtn setTintColor:[UIColor whiteColor]] ;
    [connectBtn addTarget:self action:@selector(ConnectActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail1= [UIImage imageNamed:@"accept.png"];
    [connectBtn setBackgroundImage:buttonBackgroundShowDetail1 forState:UIControlStateNormal];
    connectBtn.titleLabel.textColor=[UIColor whiteColor];

    [connectBtn setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:connectBtn];
    [connectBtn setTitle:@"CONNECT" forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}


- (IBAction)ConnectActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"connect");
    
    ConnectRequset *connctObj = (ConnectRequset *)[connectionRequestListArray objectAtIndex:indexPath.row];
   
  
    NSString*_postData = [NSString stringWithFormat:@"request_id=%@&status=Approved", connctObj.request_id ];
    webservice=2;
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/approve-connection-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [kappDelegate ShowIndicator];

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
- (IBAction)RejectActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"Reject");

    ConnectRequset *connctObj = (ConnectRequset *)[connectionRequestListArray objectAtIndex:indexPath.row];
    
    NSString*_postData = [NSString stringWithFormat:@"request_id=%@&status=Rejected", connctObj.request_id ];
    webservice=2;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/approve-connection-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

-(void)FetchConnectionList
{
    NSString*_postData ;

    if ([trigger isEqualToString:@"Parent"])
    {
        NSString*parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        _postData = [NSString stringWithFormat:@"parent_id=%@&trigger=%@", parentId,trigger ];
    }
    else{
        NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        _postData = [NSString stringWithFormat:@"parent_id=%@&trigger=%@", tutorId,trigger];
    }

    webservice=1;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-connection-request.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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


@end
