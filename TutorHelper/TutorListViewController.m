//
//  TutorListViewController.m
//  TutorHelper
//
//  Created by Br@R on 23/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "TutorListViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "tutorList.h"
#import "TutorDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TutorListViewController ()

@end

@implementation TutorListViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    tutorListArray=[[NSMutableArray alloc]init];
    [self fetchTutorList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchTutorList
{
    
    NSString*parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    NSString*_postData = [NSString stringWithFormat:@"parent_id=%@&last_updated_date=", parentId ];
   
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-tutor.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
            tutorListArray =[[NSMutableArray alloc]init];
            NSArray*tutorArray=[userDetailDict valueForKey:@"tutor_list"];
            
            for(int k=0;k<[tutorArray count];k++)
            {
                tutorList*tutorObj=[[tutorList alloc]init];
                tutorObj.TutorId=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k]valueForKey:@"tutor_id" ]];
                tutorObj.Name=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"name"]];
                tutorObj.Address=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"address"]];
                tutorObj.Email=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"email"]];
                tutorObj.ContactNumber=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"contact_number"]];
                tutorObj.AlternateContact=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"alt_c_number"]];
                tutorObj.feeDetailList=[[tutorArray objectAtIndex:k]valueForKey:@"fee_list"];
                tutorObj.notes=[NSString stringWithFormat:@"%@",[[tutorArray objectAtIndex:k ] valueForKey:@"notes"]];
                    
                [tutorListArray addObject:tutorObj];
            }
            [tutorListTableView reloadData];
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tutorListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel*backLbl= [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 300,100)];
    backLbl.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:backLbl ];
    
    backLbl.layer.borderColor=[UIColor clearColor].CGColor;
    backLbl.layer.borderWidth=2.0f;
    backLbl.layer.cornerRadius=5.0;
    backLbl.clipsToBounds = YES;
    backLbl.layer.masksToBounds = YES;

    UILabel*tutorNameLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 280,30)];
    tutorNameLbl.backgroundColor = [UIColor clearColor];
    tutorNameLbl.numberOfLines=1;
    tutorNameLbl.font =  [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:tutorNameLbl ];
    
    UILabel*tutorIdLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280,30)];
    tutorIdLbl.backgroundColor = [UIColor clearColor];
    tutorIdLbl.numberOfLines=1;
    tutorIdLbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:tutorIdLbl ];
    
    UILabel*contactLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 280,30)];
    contactLbl.backgroundColor = [UIColor clearColor];
    contactLbl.font = [UIFont boldSystemFontOfSize:13];
        contactLbl.numberOfLines=1;
    [cell.contentView addSubview:contactLbl ];
    
    UILabel*emailLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 280,30)];
    emailLbl.backgroundColor = [UIColor clearColor];
    emailLbl.font = [UIFont boldSystemFontOfSize:13];
    emailLbl.numberOfLines=1;
    [cell.contentView addSubview:emailLbl ];
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        emailLbl.frame= CGRectMake(10, 75, 330,30);
        contactLbl.frame= CGRectMake(10, 50, 330,30);
        tutorIdLbl.frame= CGRectMake(10, 25, 330,30);
        tutorNameLbl.frame= CGRectMake(10, 1, 330,30);
        backLbl.frame= CGRectMake(5, 1, 400,100);
    }
    
    tutorNameLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];

    tutorList*tutorListObj = [tutorListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    tutorIdLbl.text=[NSString stringWithFormat:@"Tutor Id : %@",tutorListObj.TutorId];
    tutorNameLbl.text=[NSString stringWithFormat:@"%@",tutorListObj.Name];
    contactLbl.text=[NSString stringWithFormat:@"Contact no. : %@",tutorListObj.ContactNumber];
    emailLbl.text=[NSString stringWithFormat:@"Email : %@",tutorListObj.Email];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    tutorList *tutorObj ;
    
    tutorObj = (tutorList *)[tutorListArray objectAtIndex:indexPath.row];
    
    
    TutorDetailViewController*tutorDetailVc=[[TutorDetailViewController alloc]initWithNibName:@"TutorDetailViewController" bundle:[NSBundle mainBundle]];
    tutorDetailVc.tutorListObj=tutorObj;
    
    [self.navigationController pushViewController:tutorDetailVc  animated:YES];
}





- (IBAction)backBttn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
 }
@end
