//
//  paymentViewController.m
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/9/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "paymentViewController.h"

@interface paymentViewController ()

@end

@implementation paymentViewController
@synthesize parentListObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.paymentType isEqualToString:@"AddCredit"]) {
        viewTitle.text = @"Add Credit";
        [addCreditBtn setTitle:@"Add Credit" forState:UIControlStateNormal];
    }else{
        viewTitle.text = @"Payment";
        [addCreditBtn setTitle:@"Make Payment" forState:UIControlStateNormal];
    }
    [self fetchParentListFomDataBase];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchParentListFomDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM ParentList "];
    
    FMResultSet *results = [database executeQuery:queryString];
    parentListArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        ParentList*parentObj=[[ParentList alloc]init];
        parentObj.parent_id =[results stringForColumn:@"id"];
        parentObj.parentName =[results stringForColumn:@"name"];
        parentObj.parentEmail =[results stringForColumn:@"email"];
        parentObj.contactNumbr =[results stringForColumn:@"contactNumber"];
        parentObj.altrContctNumbr =[results stringForColumn:@"altrContactNumber"];
        parentObj.address =[results stringForColumn:@"address"];
        [parentListArray addObject:parentObj];
    }
    [database close];
    [parntListTableView reloadData];
}

- (IBAction)selectParentBtnAction:(id)sender {
    if (parentListArray.count>0)
    {
        parntListTableView.hidden=NO;
       
    }
}

- (IBAction)addcreditBtnAction:(id)sender {
    NSLog(@"%@",parentId);
    [remarkTextView resignFirstResponder];
    [feesTxt resignFirstResponder];
    if (parentId == nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please setect the Parent from list." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([feesTxt.text isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please enter the fee amount." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([remarkTextView.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please add remarks." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
    NSString *paymentModeStr;
     updateRequestObj = [[updateRequest alloc]  init];
    NSString *tutorIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tutor_id"]];
    NSString *amountStr = [NSString stringWithFormat:@"%@",feesTxt.text];
    NSString *remarksStr = [NSString stringWithFormat:@"%@",remarkTextView.text];
    if ([self.paymentType isEqualToString:@"AddCredit"]) {
        paymentModeStr = [NSString stringWithFormat:@"AddCredit"];
    }else{
        paymentModeStr = [NSString stringWithFormat:@"PayFees"];
    }
    
    
    [updateRequestObj makePayment:parentId delegate:self tutor_Id:tutorIdStr payment_Mode:paymentModeStr amount:amountStr remarks:remarksStr];
        parentNameLbl.text = @"-Select Parent-";
        feesTxt.text = @"";
        remarkTextView.text= @"";
    }
}

- (IBAction)backBtnAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [parentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    parentListObj=[parentListArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    parntListTableView.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=parentListObj.parentName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    parentListObj = (ParentList *)[parentListArray objectAtIndex:indexPath.row];
    parentId = [NSString stringWithFormat:@"%@",parentListObj.parent_id];
    parentNameLbl.text=[NSString stringWithFormat:@"  %@",parentListObj.parentName];
    parntListTableView.hidden=YES;
}
-(void)recivedResponce{
    updateRequestObj = [[updateRequest alloc]  init];
    NSString* status = [updateRequestObj statusValue];
    NSLog(@"%@", self.paymentType);
    if ([status isEqualToString:@"True"]) {
        NSLog( @"recived responce...");
       
        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if(textView == remarkTextView){
        CGPoint pt;
        CGRect rc = [remarkTextView bounds];
        rc = [remarkTextView convertRect:rc toView:scroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y -=70;
        [scroller setContentOffset:pt animated:YES];
    }
    
    
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        
        [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
        [textView resignFirstResponder];
        
    }
    return YES;
}


@end
