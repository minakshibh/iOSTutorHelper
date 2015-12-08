//
//  HistoryDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "HistoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "lessonsViewController.h"
#import "paymentListViewController.h"
#import "StatementViewController.h"
@interface HistoryDetailViewController ()

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tempHistoryListByParentArray = [[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    detailView.layer.borderColor=[UIColor clearColor].CGColor;
    detailView.layer.borderWidth=2.0f;
    detailView.layer.cornerRadius=5.0;
    detailView.clipsToBounds = YES;
    detailView.layer.masksToBounds = YES;
    menuBtn.hidden = YES;
    menuBtnImg.hidden = YES;
    filterView.hidden = YES;
    
    isByParent = NO;
   
    
    sortByStr=@"month";
    [byMonthSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byParentSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byParentSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byMonthSortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (self.parentIdStr == nil) {
        [self fetchPaymentHistory:@"ByMonth"];
        byMonthSortBtn.hidden = NO;
        byParentSortBtn.hidden = NO;
    }else{
        [self fetchPaymentHistory:@"ByParent"];
        byMonthSortBtn.hidden = YES;
        byParentSortBtn.hidden = YES;
        [historyTableView setFrame:CGRectMake(historyTableView.frame.origin.x, 75, historyTableView.frame.size.width, 300)];
    }
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isByParent) {
        if (isSortFiler) {
            return [tempHistoryListByParentArray count];
        }else{
            return [historyListByParentArray count];
        }
    }else{
        return [historyListByMonthArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isByParent) {
        return 132;
    }else{
        
        historyListObj = [historyListByMonthArray objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@",historyListObj.lesson_ids];
        if ([str isEqualToString:@"-1"]) {
            return 30;
        }else{
            return 132;
        }
       
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
     
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
   
    historyListObj=[[HistoryList alloc]init];
        if (isByParent) {
            if (isSortFiler) {
                historyListObj = [tempHistoryListByParentArray objectAtIndex:indexPath.row];
            }else{
                historyListObj = [historyListByParentArray objectAtIndex:indexPath.row];
            }
    }else{
        historyListObj = [historyListByMonthArray objectAtIndex:indexPath.row];
        
        if ([historyListObj.lesson_ids isEqualToString:@"-1"]) {
            
        }
    }
    [cell sethistoryObj:historyListObj :isByParent];
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
//    yearNameStr = [NSString stringWithFormat:@"%@",historyListObj.yearName];
//       [cell setLabelText:historyListObj.monthName :historyListObj.numbrOfLessons :historyListObj.outstanding_balance :historyListObj.feesColllected :historyListObj.feesDue : historyListObj.yearName];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    if (isByParent) {
        historyListObj = [historyListByParentArray objectAtIndex:indexPath.row];
    }else{
        historyListObj = [historyListByMonthArray objectAtIndex:indexPath.row];
    }
    if ([historyListObj.lesson_ids isEqualToString:@"-1"]) {
        return;
    }
    NSString *lessonIds = [NSString stringWithFormat:@"%@",historyListObj.lesson_ids];
    lessonsViewController *lessonVC = [[lessonsViewController alloc] initWithNibName:@"lessonsViewController" bundle:nil];
    lessonVC.lessonId = lessonIds;
    lessonVC.feesDue = [NSString stringWithFormat:@"%@", historyListObj.feesDue];
    lessonVC.date = [NSString stringWithFormat:@"%@-%@",historyListObj.monthName,historyListObj.yearName];
    [self.navigationController pushViewController:lessonVC animated:nil];
    
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)byMonthSortBtn:(id)sender {
    menuBtn.hidden = YES;
    menuBtnImg.hidden = YES;
    filterView.hidden = YES;
    isByParent = NO;
    sortByStr=@"month";
    [byMonthSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byParentSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byParentSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byMonthSortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        [self fetchPaymentHistory:@"ByMonth"];
    
        [historyTableView reloadData];
    
    
}

- (IBAction)byParentSortBtn:(id)sender {
    menuBtn.hidden = NO;
    menuBtnImg.hidden = NO;
    
    isByParent = YES;
    sortByStr=@"parent";
    [byParentSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byMonthSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byMonthSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byParentSortBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    
        [self fetchPaymentHistorybyParent];
   
        [historyTableView reloadData];
   
    
    
}

- (IBAction)menuBtnAction:(id)sender {
    if (filterView.hidden == YES) {
        [detailView setUserInteractionEnabled:NO];
        [historyTableView setUserInteractionEnabled:NO];
        [byMonthSortBtn setUserInteractionEnabled:NO];
        [byParentSortBtn setUserInteractionEnabled:NO];
        [backBtn setUserInteractionEnabled:NO];
       filterView.hidden = NO;
    }else{
        [detailView setUserInteractionEnabled:YES];
        [historyTableView setUserInteractionEnabled:YES];
        [byMonthSortBtn setUserInteractionEnabled:YES];
        [byParentSortBtn setUserInteractionEnabled:YES];
        [backBtn setUserInteractionEnabled:YES];
        filterView.hidden = YES;
    }
    feesCollectedRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    outStandingRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    byNameRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    
}

- (IBAction)viewByNameBtnAction:(id)sender {
    NSSortDescriptor *sort;
    if ([sortByNameBtn.titleLabel.text isEqualToString:@"By Name"]) {
        isSortFiler =NO;
        sort = [NSSortDescriptor sortDescriptorWithKey:@"monthName" ascending:YES];
        [historyListByParentArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }else{
        isSortFiler =YES;
        for (int i = 0; i < [historyListByParentArray count]; i++) {
            historyListObj =[historyListByParentArray objectAtIndex:i];
        
            if (![historyListObj.outstanding_balance isEqualToString:@"0"]) {
                [tempHistoryListByParentArray addObject:historyListObj];
            }
        }
        }
    
    feesCollectedRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    outStandingRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    byNameRadioImg.image = [UIImage imageNamed:@"radio_active.png"];
    [detailView setUserInteractionEnabled:YES];
    [historyTableView setUserInteractionEnabled:YES];
    [byMonthSortBtn setUserInteractionEnabled:YES];
    [byParentSortBtn setUserInteractionEnabled:YES];
    [backBtn setUserInteractionEnabled:YES];
    selectSortView.hidden = YES;
    [historyTableView reloadData];
   
}

- (IBAction)viewFeesCollectedBtnAction:(id)sender {
    isSortFiler =NO;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"feesColllected" ascending:YES];
    
    [historyListByParentArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    feesCollectedRadioImg.image = [UIImage imageNamed:@"radio_active.png"];
    outStandingRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    byNameRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    [detailView setUserInteractionEnabled:YES];
    [historyTableView setUserInteractionEnabled:YES];
    [byMonthSortBtn setUserInteractionEnabled:YES];
    [byParentSortBtn setUserInteractionEnabled:YES];
    [backBtn setUserInteractionEnabled:YES];
    selectSortView.hidden = YES;
    [historyTableView reloadData];
}

- (IBAction)viewOutStandingBtnAction:(id)sender {
    isSortFiler =NO;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"outstanding_balance" ascending:YES];
    
    [historyListByParentArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    feesCollectedRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    outStandingRadioImg.image = [UIImage imageNamed:@"radio_active.png"];
    byNameRadioImg.image = [UIImage imageNamed:@"radio_inactive.png"];
    [detailView setUserInteractionEnabled:YES];
    [historyTableView setUserInteractionEnabled:YES];
    [byMonthSortBtn setUserInteractionEnabled:YES];
    [byParentSortBtn setUserInteractionEnabled:YES];
    [backBtn setUserInteractionEnabled:YES];
    selectSortView.hidden = YES;
    [historyTableView reloadData];
}

- (IBAction)sortBtnAction:(id)sender {
    filterView.hidden = YES;
    selectSortView.hidden = NO;
    selectSortView.layer.borderColor=[UIColor grayColor].CGColor;
    selectSortView.layer.borderWidth=1.0f;
    selectSortView.layer.cornerRadius=5.0;
    selectSortView.clipsToBounds = YES;
    selectSortView.layer.masksToBounds = YES;
    sortViewTitleLbl.text = @"Select Sort Order";
    [sortByNameBtn setTitle:@"By Name" forState:UIControlStateNormal];
    [selectSortView setFrame:CGRectMake(selectSortView.frame.origin.x, selectSortView.frame.origin.y, selectSortView.frame.size.width, 129)];
    sortFeesCollectedBtn.hidden = NO;
    sortOutstandingBalanceBtn.hidden = NO;
    
    feesCollectedRadioImg.hidden = NO;
    outStandingRadioImg.hidden = NO;
}

- (IBAction)filterBtnAction:(id)sender {
    filterView.hidden = YES;
    selectSortView.hidden = NO;
    selectSortView.layer.borderColor=[UIColor grayColor].CGColor;
    selectSortView.layer.borderWidth=1.0f;
    selectSortView.layer.cornerRadius=5.0;
    selectSortView.clipsToBounds = YES;
    selectSortView.layer.masksToBounds = YES;
    sortViewTitleLbl.text = @"Select Filter";
    [sortByNameBtn setTitle:@"Outstanding Balance > 0" forState:UIControlStateNormal];
    [selectSortView setFrame:CGRectMake(selectSortView.frame.origin.x, selectSortView.frame.origin.y, selectSortView.frame.size.width, 67)];
    sortFeesCollectedBtn.hidden = YES;
    sortOutstandingBalanceBtn.hidden = YES;
    
    feesCollectedRadioImg.hidden = YES;
    outStandingRadioImg.hidden = YES;
    
}

- (IBAction)addCreditBtn:(id)sender {
    paymentListViewController *paymentVc=[[paymentListViewController alloc]initWithNibName:@"paymentListViewController" bundle:[NSBundle mainBundle]];
    paymentVc.parentId = self.parentIdStr;
     paymentVc.paymentType = @"AddCredit";
    [self.navigationController pushViewController:paymentVc animated:YES];
   
    
}

- (IBAction)statementBtn:(id)sender {
    StatementViewController *obj = [[StatementViewController alloc]initWithNibName:@"StatementViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)invoiceBtn:(id)sender {
}

- (IBAction)paymentBtn:(id)sender {
    paymentListViewController *paymentVc=[[paymentListViewController alloc]initWithNibName:@"paymentListViewController" bundle:[NSBundle mainBundle]];
    paymentVc.parentId = self.parentIdStr;
    paymentVc.paymentType = @"PayFees";
    [self.navigationController pushViewController:paymentVc animated:YES];
}

- (void)fetchPaymentHistory: (NSString *)trigger{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    NSString *parentId;
    
    if (self.parentIdStr == nil) {
         parentId = [NSString stringWithFormat:@""];
    }else{
        parentId = [NSString stringWithFormat:@"%@",self.parentIdStr];
    }
    webserviceCode = 1;
    NSString *tutorid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tutor_id"]];
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&trigger=%@",parentId,tutorid,trigger];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-payment-history.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (void)fetchPaymentHistorybyParent{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    isByParent = YES;
    webserviceCode = 2;
    NSString *tutorid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tutor_id"]];
    _postData = [NSString stringWithFormat:@"tutor_id=%@",tutorid];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-payment-history-parent.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"responseString:%@",userDetailDict);
    
    
    if (webserviceCode == 1) {
        NSMutableArray *fetchDataArray = [[NSMutableArray arrayWithObject:[userDetailDict valueForKey:@"year_data"]] objectAtIndex:0];
        historyListByMonthArray = [[NSMutableArray alloc] init];
        
    for (int i = 0; i < [fetchDataArray count]; i++) {
        
        NSMutableArray *lessonArray = [[fetchDataArray valueForKey:@"month_list"] objectAtIndex:i];
        HistoryList *yearObj=[[HistoryList alloc]init];
        yearObj.yearName=[[fetchDataArray valueForKey:@"name"] objectAtIndex:i];
        yearObj.lesson_ids = @"-1";
        [historyListByMonthArray addObject:yearObj];
        
        for (int j =0; j < [lessonArray count]; j ++) {
            HistoryList*historyobj=[[HistoryList alloc]init];
            historyobj.yearName=[[fetchDataArray valueForKey:@"name"] objectAtIndex:i];
            historyobj.monthName=[[lessonArray valueForKey:@"name"] objectAtIndex:j];
            historyobj.lesson_ids = [[lessonArray valueForKey:@"lesson_ids"]objectAtIndex:j];
            historyobj.parent_id=[[lessonArray valueForKey:@""] objectAtIndex:j];
            historyobj.numbrOfLessons=[[lessonArray valueForKey:@"no of lessons"] objectAtIndex:j];
            historyobj.outstanding_balance=[[lessonArray valueForKey:@"outstanding_balance"] objectAtIndex:j];
            historyobj.feesColllected=[[lessonArray valueForKey:@"fee_collected"] objectAtIndex:j];
            historyobj.feesDue=[[lessonArray valueForKey:@"feeDue"] objectAtIndex:j];
            
            NSString *outstandingFeesSTR=[NSString stringWithFormat:@"%@",[[lessonArray valueForKey:@"fee_outstanding"] objectAtIndex:j]];
            if ([outstandingFeesSTR isEqualToString:@""] || [outstandingFeesSTR isEqualToString:@"<null>"]) {
                outstandingFeesSTR = @"0";
            }
            historyobj.outstandingFees=outstandingFeesSTR;
            [historyListByMonthArray addObject:historyobj];
        }
        
    }
    }else if (webserviceCode == 2){
        NSMutableArray *fetchDataArray = [[NSMutableArray arrayWithObject:[userDetailDict valueForKey:@"parent_list"]] objectAtIndex:0];
        historyListByParentArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [fetchDataArray count]; i++) {
            HistoryList*historyobj=[[HistoryList alloc]init];
            
            historyobj.monthName=[[fetchDataArray valueForKey:@"name"] objectAtIndex:i];
            historyobj.parent_id=[[fetchDataArray valueForKey:@"ID"] objectAtIndex:i];
            historyobj.numbrOfLessons=[[fetchDataArray valueForKey:@"no of lessons"] objectAtIndex:i];
            historyobj.outstanding_balance=[[fetchDataArray valueForKey:@"outstanding_balance"] objectAtIndex:i];
            historyobj.feesColllected=[[fetchDataArray valueForKey:@"fee_collected"] objectAtIndex:i];
            historyobj.feesDue=[[fetchDataArray valueForKey:@"feeDue"] objectAtIndex:i];
            historyobj.lesson_ids = [[fetchDataArray valueForKey:@"lesson_ids"]objectAtIndex:i];
            
            NSString *outstandingFeesSTR =[NSString stringWithFormat:@"%@",[[fetchDataArray valueForKey:@"fee_outstanding"] objectAtIndex:i]];
            if ([outstandingFeesSTR isEqualToString:@""] || [outstandingFeesSTR isEqualToString:@"<null>"]) {
                outstandingFeesSTR = @"0";
            }
            historyobj.outstandingFees=outstandingFeesSTR;
            [historyListByParentArray addObject:historyobj];
        }
    }
    NSString *outStandingBalStr =[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Total_OutstandingBalance"]];
    if ([outStandingBalStr isEqualToString:@""]) {
        outStandingBalStr = @"0";
    }
    totalOutstndngBalancLbl.text=[NSString stringWithFormat:@": $%@",outStandingBalStr];
    NSString *feesCollectedStr =[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Total_Fee_Collected"]];;
    if ([feesCollectedStr isEqualToString:@""]) {
        feesCollectedStr = @"0";
    }
    feesCollectedLbl.text=[NSString stringWithFormat:@": $%@",feesCollectedStr];;
    NSString *feesDueStr =[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Total_Feedue"]];;
    if ([feesDueStr isEqualToString:@""]) {
        feesDueStr = @"0";
    }
    feesDueLbl.text=[NSString stringWithFormat:@": $%@",feesDueStr];;
    [historyTableView reloadData];
}
@end
