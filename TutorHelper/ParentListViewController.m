//
//  ParentListViewController.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentListViewController.h"
#import "ParentListTableViewCell.h"
#import "ParentDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ParentListViewController ()

@end

@implementation ParentListViewController
@synthesize trigger;

- (void)viewDidLoad {
     if ([trigger isEqualToString:@"all"])
     {
         headerLbl.text= @"My Connections";
     }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void )viewWillAppear:(BOOL)animated{

    NSString* tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    isActivSTudentFilter=NO;
    isBalaceFilter=NO;
    sortByLessons=NO;
    sortByName=NO;
    sortByBalance=NO;
    filterLbl.hidden=YES;
    sortBylbl.hidden=YES;
    cancelFilterBttn.hidden=YES;
    cancelSortBttn.hidden=YES;
    cancelSortCrossImg.hidden=YES;
    cancelFilterCrossImg.hidden=YES;
    getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:tutorId delegate:self webdata:webData trigger :@"parentList"];
    [self.view addSubview: getDetailView];
    ParentIDTempArray=[[NSMutableArray alloc]init];
    savDataArray=[[NSMutableArray alloc]init];
    savDataBalanceArray=[[NSMutableArray alloc]init];
    savDataStudentsArray=[[NSMutableArray alloc]init];
    parentListArray=[[NSMutableArray alloc]init];
    parentListObj=[[ParentList alloc]init];
    outStandingBalancArray=[[NSMutableArray alloc]init];
    activestudentsArray=[[NSMutableArray alloc]init];
    if(IS_IPHONE_4_OR_LESS)
    {
      [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 95, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
    }
    else if(IS_IPHONE_5)
    {
       [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 115, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
    }
    else{
        [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 135, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        
    }
   
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
  
    // Dispose of any resources that can be recreated.
}

- (void)ReceivedResponse
{
    [self fetchParentListFomDataBase];

}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isActivSTudentFilter)
    {
        return [activestudentsArray count];
        
    }
    else if (isBalaceFilter)
    {
        return  [outStandingBalancArray count];
        
    }
    else{
        return [parentListArray count];
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    ParentListTableViewCell *cell = (ParentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ParentListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    parentListObj=[[ParentList alloc]init];
    if (isActivSTudentFilter)
    {
        parentListObj = [activestudentsArray objectAtIndex:indexPath.row];
    }
    else if (isBalaceFilter)
    {
        parentListObj = [outStandingBalancArray objectAtIndex:indexPath.row];
    }
    else{
        parentListObj = [parentListArray objectAtIndex:indexPath.row];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:parentListObj.parentName :parentListObj.numbrOfStudents :parentListObj.balance:parentListObj.lessons];
    
    
    /////// CALL BUTTON //////////
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callBtn setTitle: @"" forState: UIControlStateNormal];
    if (IS_IPHONE_6 )
    {
        callBtn.frame = CGRectMake(300.0f, 8.0f,50.0f,18.0f);
    }
    else if (IS_IPHONE_6P){
        callBtn.frame = CGRectMake(330.0f, 8.0f,50.0f,18.0f);

    }
    else{
        callBtn.frame = CGRectMake(250.0f, 8.0f,50.0f,18.0f);
    }
    callBtn.tag = indexPath.row;
    [callBtn setTintColor:[UIColor clearColor]] ;
    [callBtn addTarget:self action:@selector(CallActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"btn_03.png"];
    [callBtn setBackgroundColor:[UIColor clearColor]];
    [callBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    [cell.contentView addSubview:callBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //////// EMAIL BUTTON ////////
    UIButton *email = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (IS_IPHONE_6 )
    {
        email.frame = CGRectMake(300.0f, 40.0f,50.0f,18.0f);
    }
    else if ( IS_IPHONE_6P)
    {
        email.frame = CGRectMake(330.0f, 40.0f,50.0f,18.0f);
    }
    else{
        email.frame = CGRectMake(250.0f, 35.0f,50.0f,18.0f);
    }

    [email setTitle: @"" forState: UIControlStateNormal];
    
    
    
    email.tag = indexPath.row;
    [email setTintColor:[UIColor whiteColor]] ;
    [email setBackgroundColor:[UIColor blackColor]];
    [email addTarget:self action:@selector(EmailActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackground= [UIImage imageNamed:@"btn_06.png"];
    
    [email setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [cell.contentView addSubview:email];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    ParentList *parentObj ;
    if (isActivSTudentFilter)
    {
        parentObj = (ParentList *)[activestudentsArray objectAtIndex:indexPath.row];
    }
    else if (isBalaceFilter)
    {
         parentObj = (ParentList *)[outStandingBalancArray objectAtIndex:indexPath.row];
    }
    else{
        parentObj = (ParentList *)[parentListArray objectAtIndex:indexPath.row];
    }

    ParentDetailViewController*parentDetailVc=[[ParentDetailViewController alloc]initWithNibName:@"ParentDetailViewController" bundle:[NSBundle mainBundle]];
    parentDetailVc.parentObj=parentObj;
    parentDetailVc.trigger=trigger;
    
    [self.navigationController pushViewController:parentDetailVc  animated:YES];
}


- (IBAction)CallActionBtn:(UIControl *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    ParentList *parentObj = (ParentList *)[parentListArray objectAtIndex:indexPath.row];
    NSString*contactNum=parentObj.contactNumbr;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactNum ]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)EmailActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    ParentList *parentObj = (ParentList *)[parentListArray objectAtIndex:indexPath.row];
    NSString*emailAddress=parentObj.parentEmail;
    
    NSString * subject = @"";
    NSString * body = @"";
    NSArray * recipients = [NSArray arrayWithObjects:emailAddress, nil];
    
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    
    if (composer==nil) {
    
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please configure you email id to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
    }
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    [composer setToRecipients:recipients];
    [self presentViewController:composer animated:YES completion:nil];
}


-(void)fetchParentListFomDataBase
{
    [savDataArray removeAllObjects];
    
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM ParentList "];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        ParentList*parentObj=[[ParentList alloc]init];
        parentObj.parent_id =[results stringForColumn:@"id"];
        parentObj.parentName =[results stringForColumn:@"name"];
        parentObj.parentEmail =[results stringForColumn:@"email"];
        parentObj.contactNumbr =[results stringForColumn:@"contactNumber"];
        parentObj.altrContctNumbr =[results stringForColumn:@"altrContactNumber"];
        parentObj.address =[results stringForColumn:@"address"];
        parentObj.balance =[results stringForColumn:@"outstandingBalance"];
        parentObj.numbrOfStudents =[results stringForColumn:@"numberOfStudents"];
        parentObj.lessons =[results stringForColumn:@"lessons"];
        parentObj.notes=[results stringForColumn:@"notes"];
        parentObj.activeStudents=[results stringForColumn:@"activeStudents"];
        
        
        
        if (![trigger isEqualToString:@"all"])
        {
            if (![parentObj.activeStudents isEqualToString:@"0"])
            {
                [parentListArray addObject:parentObj];
                [savDataArray addObject:parentObj];
            }
        }
        else{
            [parentListArray addObject:parentObj];
            [savDataArray addObject:parentObj];
        }
    }
    
    [database close];
    [parentsListTableView reloadData];
}


- (IBAction)MenuBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result)
    {
        case MFMailComposeResultSaved:
        {
            mailAlert.message = @"Message Saved";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            mailAlert.message = @"Message Sent";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [[NSUserDefaults standardUserDefaults] setValue:@"Mail" forKey:@"Mail"];
            [Alert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            mailAlert.message = @"Message Failed";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
        }
            break;
        default:
            break;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    NSString *substring;
    substring = [NSString stringWithString:searchTxt.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    substring = [substring stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    if (substring.length==0)
    {
        
        
        if (isBalaceFilter)
        {
            outStandingBalancArray=[savDataBalanceArray mutableCopy];

        }
        else if (isActivSTudentFilter)
        {
            activestudentsArray=[savDataStudentsArray mutableCopy];
            
        }
        else {
            parentListArray=[savDataArray mutableCopy];
        }
        
        
        if (sortByBalance)
        {
            NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"balance"
                                                                            ascending:NO
                                                                             selector:@selector(localizedStandardCompare:)];
            if (isBalaceFilter)
            {
                outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }
            else if (isActivSTudentFilter)
            {
                activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }
            else {
                parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }
        }
        else  if (sortByLessons)
        {
            
            NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lessons"
                                                                            ascending:NO
                                                                             selector:@selector(localizedStandardCompare:)];
            
            if (isBalaceFilter)
            {
                outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }
            else if (isActivSTudentFilter)
            {
                activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }
            else {
                parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
            }

        }
        else  if (sortByName)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES];
            if (isBalaceFilter)
            {
                [outStandingBalancArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
            else if (isActivSTudentFilter)
            {
                [activestudentsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
            else {
                [parentListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
        }
        [parentsListTableView reloadData];
   }
    
    if (substring.length>0)
    {
        [self searchAutocompleteEntriesWithSubstring:substring];
    }
    return  YES;
}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [ParentIDTempArray removeAllObjects];
    
    if (isActivSTudentFilter)
    {
        for(parentListObj in savDataStudentsArray)
        {
            NSString *parentNameStr = parentListObj.parentName ;
            NSString *parentIdStr=parentListObj.parent_id ;
            NSRange parentNameRange = [parentNameStr rangeOfString:substring];
            NSRange parentIdStrRange = [parentIdStr rangeOfString:substring];
            
            if (parentNameRange.location == 0 ||  parentIdStrRange.location==0)
            {
                [ParentIDTempArray addObject:parentListObj];
            }
        }

    }
    else if (isBalaceFilter)
    {
        for(parentListObj in savDataBalanceArray)
        {
            NSString *parentNameStr = parentListObj.parentName ;
            NSString *parentIdStr=parentListObj.parent_id ;
            NSRange parentNameRange = [parentNameStr rangeOfString:substring];
            NSRange parentIdStrRange = [parentIdStr rangeOfString:substring];
            
            if (parentNameRange.location == 0 ||  parentIdStrRange.location==0)
            {
                [ParentIDTempArray addObject:parentListObj];
            }
        }

    }
    else{
        for(parentListObj in savDataArray)
        {
            NSString *parentNameStr = parentListObj.parentName ;
            NSString *parentIdStr=parentListObj.parent_id ;
            NSRange parentNameRange = [parentNameStr rangeOfString:substring];
            NSRange parentIdStrRange = [parentIdStr rangeOfString:substring];
            
            if (parentNameRange.location == 0 ||  parentIdStrRange.location==0)
            {
                [ParentIDTempArray addObject:parentListObj];
            }
        }

    }
    
    
    if (substring.length>0)
    {
        
        if (isBalaceFilter)
        {
            [outStandingBalancArray removeAllObjects];
            outStandingBalancArray=[ParentIDTempArray mutableCopy];
        }
        else if (isActivSTudentFilter)
        {
            [activestudentsArray removeAllObjects];
            activestudentsArray=[ParentIDTempArray mutableCopy];
        }
        else{
            [parentListArray removeAllObjects];
            parentListArray =[ParentIDTempArray mutableCopy];
        }
    }
    [parentsListTableView reloadData];
}

- (IBAction)sortByActionBtn:(id)sender
{
    searchTxt.text=@"";
    [self.view endEditing:YES];
    
    if (sortBackView.hidden==YES)
    {
        sortBackView.hidden=NO;
    }
    else{
        sortBackView.hidden=YES;
    }
    filterBackView.hidden=YES;
}
- (IBAction)filterActionBtn:(id)sender
{
    searchTxt.text=@"";
    [self.view endEditing:YES];

    sortBackView.hidden=YES;
    if (filterBackView.hidden==YES)
    {
        filterBackView.hidden=NO;
    }
    else{
        filterBackView.hidden=YES;
    }
}

- (IBAction)sortByNameBttn:(id)sender {
  
    if (sortBylbl.hidden==YES)
    {
        sortBylbl.hidden=NO;
        cancelSortBttn.hidden=NO;
        cancelSortCrossImg.hidden = NO;
        if(IS_IPHONE_4_OR_LESS)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 170, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
        
    }
  
    sortByName=YES;
    sortByLessons=NO;
    sortByBalance=NO;
    
    sortBylbl.text=@"by Name";
    searchTxt.text=@"";
    [self.view endEditing:YES];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES];
    if (isActivSTudentFilter)
    {
        [activestudentsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

    }
    else if (isBalaceFilter)
    {
        [outStandingBalancArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

    }
    else{
        [parentListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

    }
    [parentsListTableView reloadData];
    sortBackView.hidden=YES;
   }

- (IBAction)sortByUpcomingBttn:(id)sender {
    if (sortBylbl.hidden==YES)
    {
        cancelSortBttn.hidden=NO;
        cancelSortCrossImg.hidden = NO;
        sortBylbl.hidden=NO;
        if(IS_IPHONE_4_OR_LESS)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 170, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
        
    }
    sortByName=NO;
    sortByLessons=YES;
    sortByBalance=NO;
    searchTxt.text=@"";
    [self.view endEditing:YES];

    
    sortBylbl.text=@"by lessons";
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lessons"
                                                                    ascending:NO
                                                                     selector:@selector(localizedStandardCompare:)];
    


    if (isActivSTudentFilter)
    {
         activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    }
    else if (isBalaceFilter)
    {
         outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
        
    }
    else{
        parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
        
    }
    [parentsListTableView reloadData];
    sortBackView.hidden=YES;
        
}

- (IBAction)sortByBalanceBtn:(id)sender {
    sortByName=NO;
    sortByLessons=NO;
    sortByBalance=YES;
    if (sortBylbl.hidden==YES)
    {
        sortBylbl.hidden=NO;
        cancelSortBttn.hidden=NO;
        cancelSortCrossImg.hidden = NO;
        if(IS_IPHONE_4_OR_LESS)
        {
             [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 170, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
       
    }

    sortBylbl.text=@"by balance";
    searchTxt.text=@"";
    [self.view endEditing:YES];
    parentListArray=[savDataArray mutableCopy];
    activestudentsArray =[savDataStudentsArray mutableCopy];
    outStandingBalancArray =[savDataBalanceArray mutableCopy];

    
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"balance"
                                                                    ascending:NO
                                                                     selector:@selector(localizedStandardCompare:)];
    
    
    
    if (isActivSTudentFilter)
    {
        activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    }
    
    else if (isBalaceFilter)
    {
       
        outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

        
    }
    else{
     
        parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

        
    }
    [parentsListTableView reloadData];
    sortBackView.hidden=YES;
}

- (IBAction)filterActiveStudentsBttn:(id)sender {
    if (filterLbl.hidden==YES)
    {
        filterLbl.hidden=NO;
        cancelFilterBttn.hidden=NO;
        cancelFilterCrossImg.hidden = NO;
        if(IS_IPHONE_4_OR_LESS)
        {
             [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 110, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
        
    }
    parentListArray=[savDataArray mutableCopy];
    activestudentsArray =[savDataStudentsArray mutableCopy];
    outStandingBalancArray =[savDataBalanceArray mutableCopy];
    
    isActivSTudentFilter=YES;
    isBalaceFilter=NO;
    filterBackView.hidden=YES;
    [savDataStudentsArray removeAllObjects];
    filterLbl.text=@"ActiveStudents";
    activestudentsArray =[[NSMutableArray alloc]init];
    for (int k=0;k<parentListArray.count ; k++)
    {
        ParentList*parentObj=[[ParentList alloc]init];
        parentObj=[parentListArray objectAtIndex:k];
        
        if (![parentObj.activeStudents isEqualToString:@"0"])
        {
            [activestudentsArray addObject:parentObj];
            [savDataStudentsArray addObject:parentObj];

        }
    }
    NSSortDescriptor *sort;
    if (sortByName)
    {
        sort = [NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES];
        [activestudentsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

        
    }
    else if (sortByLessons)
    {
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lessons"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        
        activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

    }
    else if (sortByBalance)
    {
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"balance"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        activestudentsArray = [[activestudentsArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

    }

    [parentsListTableView reloadData];
    
}

- (IBAction)filterOfBalanceBttn:(id)sender {
    if (filterLbl.hidden==YES)
    {
        filterLbl.hidden=NO;
        cancelFilterBttn.hidden=NO;
        cancelFilterCrossImg.hidden = NO;
        if(IS_IPHONE_4_OR_LESS)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x,110, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
        
    }

    [parentListArray removeAllObjects];
    
    parentListArray=[savDataArray mutableCopy];
    activestudentsArray =[savDataStudentsArray mutableCopy];
    outStandingBalancArray =[savDataBalanceArray mutableCopy];
    
    isActivSTudentFilter=NO;
    isBalaceFilter=YES;
    filterBackView.hidden=YES;
    filterLbl.text=@"Balance";
    [savDataBalanceArray removeAllObjects];
    outStandingBalancArray=[[NSMutableArray alloc ]init];
    for (int k=0;k<parentListArray.count ; k++)
    {
        ParentList*parentObj=[[ParentList alloc]init];
        parentObj=[parentListArray objectAtIndex:k];
        
        if (![parentObj.balance isEqualToString:@"0"])
        {
            [outStandingBalancArray addObject:parentObj];
            [savDataBalanceArray addObject:parentObj];
        }
    }
    NSSortDescriptor *sort;
    if (sortByName)
    {
        sort = [NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES];
        [outStandingBalancArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    else if (sortByLessons)
    {
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lessons"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        
        outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

    }
    else if (sortByBalance)
    {
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"balance"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        
        outStandingBalancArray = [[outStandingBalancArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];

     

    }

    [parentsListTableView reloadData];
}

- (IBAction)cancelSortBttn:(id)sender {
    sortBylbl.text=@"";
    sortByLessons=NO;
    sortByName=NO;
    sortByBalance=NO;
    [parentsListTableView reloadData];
    cancelSortBttn.hidden=YES;
    cancelSortCrossImg.hidden = YES;
    sortBylbl.hidden=YES;
    if (filterLbl.hidden == YES) {
        if(IS_IPHONE_4_OR_LESS)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 95, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 115, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 135, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
    }else{
        if(IS_IPHONE_4_OR_LESS)
        {
             [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 110, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else if(IS_IPHONE_5)
        {
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 130, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        }
        else{
            [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 150, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
            
        }
    
    }

}

- (IBAction)cancelFilterBttn:(id)sender {
    isActivSTudentFilter=NO;
    isBalaceFilter=NO;
    filterLbl.text=@"";
    
    if (sortByBalance)
    {
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"balance"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    }
    else  if (sortByLessons)
    {
        
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lessons"
                                                                        ascending:NO
                                                                         selector:@selector(localizedStandardCompare:)];
        
        parentListArray = [[parentListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    }
    else  if (sortByName)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES];
                   [parentListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    [parentsListTableView reloadData];

    cancelFilterBttn.hidden=YES;
    filterLbl.hidden=YES;
    cancelFilterCrossImg.hidden=YES;
    if(IS_IPHONE_4_OR_LESS)
    {
        [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 95, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
    }
    else if(IS_IPHONE_5)
    {
        [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 115, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
    }
    else{
        [parentsListTableView setFrame:CGRectMake(parentsListTableView.frame.origin.x, 135, parentsListTableView.frame.size.width, parentsListTableView.frame.size.height)];
        
    }
    [self cancelSortBttn:sender];
}



@end
