//
//  paymentListViewController.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "paymentListViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "paymentListTableViewCell.h"
#import "paymentListDetailViewController.h"
#import "paymentViewController.h"
@interface paymentListViewController ()

@end

@implementation paymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    savDataArray = [[NSMutableArray alloc]init];
    orderIdtempArray = [[NSMutableArray alloc]init];
    
    parentIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"pin"]];
    if ([parentIdStr isEqualToString:@"(null)"]) {
        searchImg.hidden = YES;
        searchTutorTxt.hidden = YES;
        totalCreditLbl.hidden = YES;
        creditLbl.hidden = YES;
        //[paymentTableView setFrame:CGRectMake(0, 155, 320, 485)];
        [self.view addSubview:paymentTableView];
    }else{
        searchImg.hidden = YES;
        searchTutorTxt.hidden = YES;
        totalCreditLbl.hidden = NO;
        creditLbl.hidden = NO;
       // [paymentTableView setFrame:CGRectMake(0, 155, 320, 485)];
        [self.view addSubview:paymentTableView];
    }
    if ([self.paymentType isEqualToString:@"AddCredit"]) {
        if (![parentIdStr isEqualToString:@"(null)"]) {
            titleLbl.text = @"Credits";
        }else{
        titleLbl.text = @"Add Credit";
        }
    }else{
        
        titleLbl.text = @"Payment";
        
    }
   
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    if ([parentIdStr isEqualToString:@"(null)"]) {
        searchImg.hidden = YES;
        searchTutorTxt.hidden = YES;
        totalCreditLbl.hidden = YES;
        creditLbl.hidden = YES;
        //[paymentTableView setFrame:CGRectMake(0, 155, 320, 485)];
        [self.view addSubview:paymentTableView];
    }else{
        searchImg.hidden = YES;
        searchTutorTxt.hidden = YES;
        totalCreditLbl.hidden = NO;
        creditLbl.hidden = NO;
        //[paymentTableView setFrame:CGRectMake(0, 155, 320, 485)];
        [self.view addSubview:paymentTableView];
    }
     [self fetchPaymentlist];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. fetch-transaction-detail.php
}

- (void)fetchPaymentlist{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    NSString *parentId,*trigger,*tutorid;
    tutorid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tutor_id"]];
     parentId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"pin"]];
    if ([parentId isEqualToString:@"(null)"]) {
        parentId = [NSString stringWithFormat:@""];
        trigger = @"tutor";
    }else{
        addbtn.hidden = YES;
        addbtnImg.hidden = YES;
        tutorid = [NSString stringWithFormat:@""];
        trigger = @"parent";
    }
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&trigger=%@",parentId,tutorid,trigger];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-transaction-detail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    NSMutableArray *paymentArrayList = [userDetailDict valueForKey:@"payment_list"];
    creditLbl.text = [NSString stringWithFormat:@"$ %@",[userDetailDict valueForKey:@"totalCredits"]];
    paymentArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [paymentArrayList count]; i++) {
        paymentObj = [[paymentListOC alloc] init];
        paymentObj.paymentId = [[paymentArrayList valueForKey:@"ID"]objectAtIndex:i];
        paymentObj.fee_paid = [[paymentArrayList valueForKey:@"fee_paid"]objectAtIndex:i];
        paymentObj.last_updated = [[paymentArrayList valueForKey:@"last_updated"]objectAtIndex:i];
        paymentObj.parent_id = [[paymentArrayList valueForKey:@"parent_id"]objectAtIndex:i];
        paymentObj.parent_name = [[paymentArrayList valueForKey:@"parent_name"]objectAtIndex:i];
        paymentObj.payment_mode = [[paymentArrayList valueForKey:@"payment_mode"]objectAtIndex:i];
        paymentObj.remarks = [[paymentArrayList valueForKey:@"remarks"]objectAtIndex:i];
        paymentObj.tutor_id = [[paymentArrayList valueForKey:@"tutor_id"]objectAtIndex:i];
        paymentObj.tutor_name = [[paymentArrayList valueForKey:@"tutor_name"]objectAtIndex:i];
        NSString *paymentModeStr = [NSString stringWithFormat:@"%@",paymentObj.payment_mode];
        if ([paymentModeStr isEqualToString:self.paymentType]) {
            [paymentArray addObject:paymentObj];
            [savDataArray addObject:paymentObj];
        }
        
    }
    [paymentTableView reloadData];
    [kappDelegate HideIndicator];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [paymentArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    paymentListTableViewCell *cell = (paymentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"paymentListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    paymentObj=[[paymentListOC alloc]init];
    
    paymentObj = [paymentArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    if ([parentIdStr isEqualToString:@"(null)"]) {
        [cell setLabelText:paymentObj.fee_paid  :paymentObj.parent_name :paymentObj.last_updated];
    }else{
        [cell setLabelText:paymentObj.fee_paid  :paymentObj.tutor_name :paymentObj.last_updated];
    }

    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return  cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
    paymentObj = [paymentArray objectAtIndex:indexPath.row];
    
    paymentListDetailViewController*lessonRequstVC=[[paymentListDetailViewController alloc]initWithNibName:@"paymentListDetailViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.paymentObj=paymentObj;
    lessonRequstVC.paymentType = self.paymentType;
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)paymentBtnAction:(id)sender {
    paymentViewController *paymentVc=[[paymentViewController alloc]initWithNibName:@"paymentViewController" bundle:[NSBundle mainBundle]];
    paymentVc.paymentType = self.paymentType;
    [self.navigationController pushViewController:paymentVc animated:YES];
    
}
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    // orderList=[savDataArray mutableCopy];
    NSString *substring;
    substring = [NSString stringWithString:searchTutorTxt.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    
    if (substring.length==0)
    {
        paymentArray=[savDataArray mutableCopy];
    }
    
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    
    
    return  YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    
    [orderIdtempArray removeAllObjects];
    
    for(paymentObj in savDataArray)
    {
        
        NSString *tutorIdStr = paymentObj.tutor_id ;
        NSString *tutorNameStr = paymentObj.tutor_name ;
        tutorIdStr = [tutorIdStr lowercaseString];
        tutorNameStr = [tutorNameStr lowercaseString];
        substring = [substring lowercaseString];
        NSRange tutorIdStrRange = [tutorIdStr rangeOfString:substring];
        NSRange tutorNameStrRange = [tutorNameStr rangeOfString:substring];
        
        if (tutorIdStrRange.location == 0 ||  tutorNameStrRange.location==0)
        {
            
            [orderIdtempArray addObject:paymentObj];
        }
    }
    
    if (substring.length>0) {
        [paymentArray removeAllObjects];
        paymentArray =[orderIdtempArray mutableCopy];
    }
    
    
    
    [paymentTableView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
