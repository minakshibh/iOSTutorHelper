//
//  newsFeedViewController.m
//  TutorHelper
//
//  Created by Sahil Dhiman on 6/25/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "newsFeedViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "newsFeedTableViewCell.h"
@interface newsFeedViewController ()

@end

@implementation newsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchNewsFeedlist];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchNewsFeedlist{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData,*tokenValue;
    
    tokenValue = [NSString stringWithFormat:@"0"];
    
    _postData = [NSString stringWithFormat:@"user_id=%@&page_token=%@",self.userId,tokenValue];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-news-feed.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"responseString:%@",userDetailDict);
    NSMutableArray *paymentArrayList = [userDetailDict valueForKey:@"notification_list"];
    newsFeedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [paymentArrayList count]; i++) {
        newsFeedOC = [[newsFeedObj alloc] init];
        newsFeedOC.notificationId = [[paymentArrayList valueForKey:@"ID"]objectAtIndex:i];
        newsFeedOC.lesson_id = [[paymentArrayList valueForKey:@"lesson_id"]objectAtIndex:i];
        newsFeedOC.message = [[paymentArrayList valueForKey:@"message"]objectAtIndex:i];
        newsFeedOC.notitype = [[paymentArrayList valueForKey:@"notitype"]objectAtIndex:i];
        newsFeedOC.parent_id = [[paymentArrayList valueForKey:@"parent_id"]objectAtIndex:i];
        newsFeedOC.receiver_id = [[paymentArrayList valueForKey:@"receiver_id"]objectAtIndex:i];
        newsFeedOC.request_id = [[paymentArrayList valueForKey:@"request_id"]objectAtIndex:i];
        newsFeedOC.tutor_id = [[paymentArrayList valueForKey:@"tutor_id"]objectAtIndex:i];
        newsFeedOC.student_id = [[paymentArrayList valueForKey:@"student_id"]objectAtIndex:i];
        
        newsFeedOC.last_updated = [[paymentArrayList valueForKey:@"last_updated"]objectAtIndex:i];
        [newsFeedArray addObject:newsFeedOC];
    }
    [newsFeedTableView reloadData];
    [kappDelegate HideIndicator];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsFeedArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    newsFeedTableViewCell *cell = (newsFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"newsFeedTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
   
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Hello" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
//    alert.tag= 40;
    newsFeedOC = [newsFeedArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    
    [cell fetchData:newsFeedOC];
    
    
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return  cell;
    
}

- (IBAction)backBtnAction:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}

@end
