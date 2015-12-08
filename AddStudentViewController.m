//
//  AddStudentViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AddStudentViewController.h"
#import "ParentList.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AddNewParentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddStudentViewController ()

@end

@implementation AddStudentViewController
@synthesize parentDetailDict,trigger,triggervalue,parentListObj,studentListObj,fromView;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"parentDetailDict"];
    enterParentIdTxt.text=@"";
    
    gender=@"male";
    maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];

    noteTxtView.layer.borderColor=[UIColor grayColor].CGColor;
    noteTxtView.layer.borderWidth=1.0f;
    noteTxtView.layer.cornerRadius=1.0;
    noteTxtView.clipsToBounds = YES;
    noteTxtView.layer.masksToBounds = YES;
    
    
    addStudentBackView.layer.borderColor=[UIColor clearColor].CGColor;
    addStudentBackView.layer.borderWidth=2.0f;
    addStudentBackView.layer.cornerRadius=5.0;
    addStudentBackView.clipsToBounds = YES;
    addStudentBackView.layer.masksToBounds = YES;
    
    
    parentInfoBackView.layer.borderColor=[UIColor clearColor].CGColor;
    parentInfoBackView.layer.borderWidth=2.0f;
    parentInfoBackView.layer.cornerRadius=5.0;
    parentInfoBackView.clipsToBounds = YES;
    parentInfoBackView.layer.masksToBounds = YES;
    
    
    if ([trigger isEqualToString:@"Parent"])
    {
        parentIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        addStudentBackView.frame=CGRectMake(addStudentBackView.frame.origin.x, 7, addStudentBackView.frame.size.width, addStudentBackView.frame.size.height);
        BackView.hidden=YES;
        gender=studentListObj.gender;
        
        if ([triggervalue isEqualToString:@"edit"]){
            notesLbl.hidden=YES;
            noteTxtView.hidden=YES;
            genderLbl.hidden=YES;
            maleBtn.hidden=YES;
            femaleBtn.hidden=YES;
            maleImageView.hidden=YES;
            femaleImageView.hidden=YES;
            feesIconImg.hidden=YES;
            feesTxt.hidden=YES;
            addressTxt.hidden=NO;
            addressIconImg.hidden=NO;
            
            [addStudentBttn setTitle:@"EDIT" forState:UIControlStateNormal];

            addStudentBttn.frame=CGRectMake(addStudentBttn.frame.origin.x, 260, addStudentBttn.frame.size.width, addStudentBttn.frame.size.height);
            
            addStudentBackView.frame=CGRectMake(addStudentBackView.frame.origin.x, addStudentBackView.frame.origin.y, addStudentBackView.frame.size.width, addStudentBackView.frame.size.height-100);
            
            nameTxt.text=studentListObj.studentName;
            
            emailTxt.text=studentListObj.studentEmail;
            contactTxt.text=studentListObj.studentContact;
            feesTxt.text=studentListObj.fees;
            addressTxt.text=studentListObj.address;

        }
        else{
            
            webservice=1;
            
            _postData = [NSString stringWithFormat:@"parent_id=%@",parentIdStr];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/parent-info.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
            [self postWebService];
 
        }
       
    }
    
    
    else
    {
        if ([triggervalue isEqualToString:@"edit"])
        {
            [addStudentBttn setTitle:@"EDIT" forState:UIControlStateNormal];
            tutor_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"tutor_id"]];
            parentIdStr=parentListObj.parent_id;
            nameTxt.text=studentListObj.studentName;
            
            emailTxt.text=studentListObj.studentEmail;
            contactTxt.text=studentListObj.studentContact;
            feesTxt.text=studentListObj.fees;
            noteTxtView.text=studentListObj.notes;
            gender=studentListObj.gender;
            maleBtn.userInteractionEnabled=NO;
            femaleBtn.userInteractionEnabled=NO;
            nameTxt.userInteractionEnabled=NO;
            
            if ([gender isEqualToString:@"male"])
            {
                maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
                femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
            }
            else {
                femaleImageView.image=[UIImage imageNamed:@"radio_active.png"];
                maleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
            }
            
            addStudentBackView.frame=CGRectMake(addStudentBackView.frame.origin.x, 7, addStudentBackView.frame.size.width, addStudentBackView.frame.size.height);
            BackView.hidden=YES;
        }
        else
        {
            parentIdStr=parentListObj.parent_id;
            if (parentIdStr.length==0)
            {
                parentIdStr=@"";
            }
            else
            {
                parentIdLbl.text=[NSString stringWithFormat:@"Parent Id:%@",parentIdStr];
                parentNameLbl.text=parentListObj.parentName;
                contactNubrLbl.text=[NSString stringWithFormat:@":%@",parentListObj.contactNumbr];
                emailAddresslbl.text=[NSString stringWithFormat:@":%@",parentListObj.parentEmail];
                addressLbl.text=[NSString stringWithFormat:@":%@",parentListObj.address];
            }
        
            tutor_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"tutor_id"]];

            backScrollView.scrollEnabled = YES;
            backScrollView.delegate = self;
            if (IS_IPHONE_6 || IS_IPHONE_6P)
            {
                backScrollView.contentSize = CGSizeMake(320, 1360);

            }else{
                backScrollView.contentSize = CGSizeMake(320, 1160);

            }
            backScrollView.backgroundColor=[UIColor clearColor];
        }
    }
    
    [super viewDidLoad];
    parentListObj=[[ParentList alloc]init];
    [self fetchParentListFomDataBase];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    parentDetailDict=[[NSUserDefaults standardUserDefaults] valueForKey: @"parentDetailDict"];

    if ([[parentDetailDict valueForKey:@"p_id"]isEqualToString:@"-1"])
    {
        parentIdLbl.text=[NSString stringWithFormat:@""];

        parentIdStr=@"-1";
        NSString*parenName= [parentDetailDict valueForKey:@"p_name"];
        NSString*parentemail=[parentDetailDict valueForKey:@"p_email"];
        NSString*parenContact=[parentDetailDict valueForKey:@"p_contact"];
        NSString*parentAddress=[parentDetailDict valueForKey:@"p_address"];
        
        parentNameLbl.text=parenName;
        selectParentLbl.text=parenName;
        contactNubrLbl.text=[NSString stringWithFormat:@":%@",parenContact];
        addressLbl.text=[NSString stringWithFormat:@":%@",parentAddress];
        emailAddresslbl.text=[NSString stringWithFormat:@":%@",parentemail];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sameAsParentBttn:(id)sender
{
    if ([triggervalue isEqualToString:@"edit"])
    {
        emailTxt.text=parentListObj.parentEmail;
        contactTxt.text=parentListObj.contactNumbr;
    }
    else{
        NSString *emailStr = [emailAddresslbl.text stringByReplacingOccurrencesOfString: @":" withString:@""];
        NSString *contactStr = [contactNubrLbl.text stringByReplacingOccurrencesOfString: @":" withString:@""];
        emailTxt.text=emailStr;
        contactTxt.text=contactStr;
    }
}

- (IBAction)MenuBtn:(id)sender {
    enterParentIdTxt.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addStudentBtn:(id)sender
{
    [backScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.view endEditing:YES];
    NSString* nameStr = [nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* emailAddressStr = [emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*contactStr = [contactTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*feesStr = [feesTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*parentIdTxtStr = [enterParentIdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    [self.view endEditing:YES];
    
    
    if ([[parentDetailDict valueForKey:@"p_id"]isEqualToString:@"-1"])
    {
        parentIdStr=@"-1";
    }
   
    if (parentIdTxtStr.length!=0)
    {
        parentIdStr=parentIdTxtStr;
    }
    if ([parentIdStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Select the Parent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([nameStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Name of Student." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([emailAddressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the User Email Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([emailTest evaluateWithObject:emailAddressStr] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:KalertTittle message:@"Enter valid User Email Address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
        return;
    }
    else if ([contactStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Phone Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (contactStr.length>11 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter a valid Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }else if (contactStr.length<7 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter a valid Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![triggervalue isEqualToString:@"edit"]) {
        if (feesStr.length==0  )
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Fees." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    NSString*parenName= [parentDetailDict valueForKey:@"p_name"];
    NSString*parentemail=[parentDetailDict valueForKey:@"p_email"];
    NSString*parenContact=[parentDetailDict valueForKey:@"p_contact"];
    NSString*parentAddress=[parentDetailDict valueForKey:@"p_address"];
    NSString*parentGender=[parentDetailDict valueForKey:@"p_gender"];
    
    NSString*addressStr;
    if ([triggervalue  isEqualToString:@"add"] && [trigger isEqualToString:@"Tutor" ]) {
        addressStr = [addressLbl.text stringByReplacingOccurrencesOfString: @":" withString:@""];
        addressStr = [addressStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }
    if ([triggervalue  isEqualToString:@"edit"] && [trigger isEqualToString:@"Tutor" ]) {
        addressStr = parentListObj.address;
    }
    
    
    if ([triggervalue  isEqualToString:@"add"] && [trigger isEqualToString:@"Parent" ]) {
        addressStr =parentListObj.address;
    }

    
    if ([triggervalue  isEqualToString:@"edit"] && [trigger isEqualToString:@"Parent"])

    {
        addressStr = [addressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    
    webservice=2;
       
     if ([trigger isEqualToString:@"Parent"])
     {
         tutor_id=@"";
        
         if ([triggervalue isEqualToString:@"edit"])
         {
             _postData = [NSString stringWithFormat:@"name=%@&email=%@&parent_id=%@&phone=%@&alternate_phone=%@&address=%@&parent_name=%@&parent_email=%@&parent_contact=%@&parent_address=%@&parent_gender=%@&creator=%@&creator_id=%@&trigger=%@&gender=%@&fee=%@&notes=%@&student_id=%@",nameStr,emailAddressStr,parentIdStr,contactStr,parentListObj.altrContctNumbr,addressStr,parentListObj.parentName,parentListObj.parentEmail,parentListObj.contactNumbr,addressStr,parentGender,trigger,tutor_id,triggervalue,gender,feesStr,noteTxtView.text,studentListObj.studentId];
         }

         
         else{
             _postData = [NSString stringWithFormat:@"name=%@&email=%@&parent_id=%@&phone=%@&alternate_phone=%@&address=%@&parent_name=%@&parent_email=%@&parent_contact=%@&parent_address=%@&parent_gender=%@&creator=%@&creator_id=%@&trigger=%@&gender=%@&fee=%@&notes=%@",nameStr,emailAddressStr,parentIdStr,contactStr,parentListObj.altrContctNumbr,addressStr,parentListObj.parentName,parentListObj.parentEmail,parentListObj.contactNumbr,addressStr,parentGender,trigger,tutor_id,triggervalue,gender,feesStr,noteTxtView.text];
         }
     }
     else{
         if ([triggervalue isEqualToString:@"edit"])
         {
             _postData = [NSString stringWithFormat:@"name=%@&email=%@&parent_id=%@&phone=%@&alternate_phone=%@&address=%@&parent_name=%@&parent_email=%@&parent_contact=%@&parent_address=%@&parent_gender=%@&creator=%@&creator_id=%@&trigger=%@&gender=%@&fee=%@&student_id=%@&notes=%@",nameStr,emailAddressStr,parentIdStr,contactStr,parentListObj.altrContctNumbr,parentListObj.address,parentListObj.parentName,parentListObj.parentEmail,parentListObj.contactNumbr,addressStr,parentGender,trigger,tutor_id,triggervalue,gender,feesStr,studentListObj.studentId,noteTxtView.text];
         }
         else{
             _postData = [NSString stringWithFormat:@"name=%@&email=%@&parent_id=%@&phone=%@&alternate_phone=%@&address=%@&parent_name=%@&parent_email=%@&parent_contact=%@&parent_address=%@&parent_gender=%@&creator=%@&creator_id=%@&trigger=%@&gender=%@&fee=%@&notes=%@",nameStr,emailAddressStr,parentIdStr,contactStr,parentListObj.altrContctNumbr,addressStr,parenName,parentemail,parenContact,addressStr,parentGender,trigger,tutor_id,triggervalue,gender,feesStr,noteTxtView.text];
            }
    }
  
    NSLog(@"data post >>> %@",_postData);
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/student-register.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        
    [self postWebService];
    
 }

- (IBAction)addNewParentBtn:(id)sender
{
    AddNewParentViewController*addNewParentVc=[[AddNewParentViewController alloc]initWithNibName:@"AddNewParentViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController presentViewController:addNewParentVc animated:YES completion:nil];
}

- (IBAction)showParentListBtn:(id)sender
{
    if (parentListArray.count>0)
    {
        parntListTableView.hidden=NO;
        enterParentIdTxt.text=@"";
    }
}

- (IBAction)femaleBtn:(id)sender {
    gender=@"female";
    femaleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    maleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
}

- (IBAction)maleBtn:(id)sender {
    gender=@"male";
    maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
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
    parentIdLbl.text=[NSString stringWithFormat:@"Parent Id:%@",parentListObj.parent_id];

    parentNameLbl.text=parentListObj.parentName;
    selectParentLbl.text=parentListObj.parentName;
    parentIdStr=parentListObj.parent_id;
    contactNubrLbl.text=[NSString stringWithFormat:@":%@",parentListObj.contactNumbr];
    addressLbl.text=[NSString stringWithFormat:@":%@",parentListObj.address];
    emailAddresslbl.text=[NSString stringWithFormat:@":%@",parentListObj.parentEmail];
    parntListTableView.hidden=YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [backScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==5)
    {
        parentIdLbl.text=@"";
        parntListTableView .hidden=YES;
        parentIdStr=@"";
        selectParentLbl.text=@" -Select Parent-";
        parentNameLbl.text=@"Parent Name";
        emailAddresslbl.text=@":";
        addressLbl.text=@":";
        contactNubrLbl.text=@":";
    }
    
    if (textField.tag==3 || textField.tag==4 ) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
    
    if (![trigger isEqualToString:@"Parent"] )
    {
        if ([triggervalue isEqualToString:@"add"])
        {
            if(IS_IPHONE_4_OR_LESS)
            {
                if (textField.tag== 1 ||textField.tag== 2 || textField.tag== 3  || textField.tag==4)
                {
                    [backScrollView setContentOffset:CGPointMake(0.0, 400.0) animated:YES];
                    return YES;
                }
            }
            else if(IS_IPHONE_5)
            {
                if (textField.tag== 1 ||textField.tag== 2 )
                {
                    [backScrollView setContentOffset:CGPointMake(0.0, 350.0) animated:YES];
                    return YES;
                }
                else if (textField.tag== 3  || textField.tag==4)
                {
                    [backScrollView setContentOffset:CGPointMake(0.0, 450.0) animated:YES];
                    return YES;
                }
            }
            else{
                if (textField.tag== 1 ||textField.tag== 2 )
                {
                    [backScrollView setContentOffset:CGPointMake(0.0, 400.0) animated:YES];
                    return YES;
                }
                else if ( textField.tag== 3  || textField.tag==4)
                {
                    [backScrollView setContentOffset:CGPointMake(0.0, 480.0) animated:YES];
                    return YES;
                }

            }
        }
    }
    return  YES;
}


- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    if (textField.tag==5 )
    {
        if (parntListTableView.hidden==NO)
        {
            parntListTableView .hidden=YES;
            parentIdStr=@"";
            parentIdLbl.text=@"";
            
            selectParentLbl.text=@" -Select Parent-";
            parentNameLbl.text=@"Parent Name";
            emailAddresslbl.text=@":";
            addressLbl.text=@":";
            contactNubrLbl.text=@":";

        }
    }
    return  YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==5)
    {
        webservice=1;
        NSString*parentId = [enterParentIdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (parentId.length>0) {
            _postData = [NSString stringWithFormat:@"parent_id=%@",parentId];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/parent-info.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
            [self postWebService];
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    if (![trigger isEqualToString:@"Parent"] )
    {
        if ([triggervalue isEqualToString:@"add"])
        {
            [backScrollView setContentOffset:CGPointMake(0.0, 480.0) animated:YES];
        }
        else
        {
            [backScrollView setContentOffset:CGPointMake(0.0, 150.0) animated:YES];
        }
    }
    else{
         [backScrollView setContentOffset:CGPointMake(0.0, 150.0) animated:YES];
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [backScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

        return FALSE;
    }
    return TRUE;
}


-(void)dismissKeyboard
{
    [backScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.view endEditing:YES];
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
                NSMutableDictionary*tempDict =[[userDetailDict valueForKey:@"parent_info"]objectAtIndex:0];
                parentIdStr=[tempDict valueForKey:@"parent_id"];
                parentIdLbl.text=[NSString stringWithFormat:@"Parent Id:%@",parentIdStr];

                parentNameLbl.text=[tempDict valueForKey:@"name"];
                contactNubrLbl.text=[NSString stringWithFormat:@":%@",[tempDict valueForKey:@"contact_number"]];
                emailAddresslbl.text=[NSString stringWithFormat:@":%@",[tempDict valueForKey:@"email"]];
                addressLbl.text=[NSString stringWithFormat:@":%@",[tempDict valueForKey:@"address"]];
                
                if ([trigger isEqualToString:@"Parent"])
                {
                    parentListObj.parent_id=parentIdStr;
                    
                    parentListObj.parentEmail=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"email"]];
                    parentListObj.parentName=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"name"]];
                     parentListObj.contactNumbr=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"contact_number"]];
                    parentListObj.address=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"address"]];
                     parentListObj.altrContctNumbr=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"alt_c_number"]];
                }
                webservice=0;
            }
            else  if(webservice==2)
            {
                UIAlertView *alert;
                
                if ([triggervalue isEqualToString:@"edit"]) {
                      alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"Student Edit successfuly."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    if ([fromView isEqualToString:@"studentDetail"])
                    {
                        alert.tag=3;
                        
                    }
                    else{
                        alert.tag=2;
                    }
                }
                else{
                      alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"New Student added successfuly."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag=2;

                }
                [alert show];
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    if (alertView.tag==2)
    {
        emailTxt.text=@"";
        nameTxt.text=@"";
        feesTxt.text=@"";
        contactTxt.text=@"";
        feesTxt.text=@"";

        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==3)
    {
        emailTxt.text=@"";
        nameTxt.text=@"";
        contactTxt.text=@"";
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:NO];
    }
}


-(void) postWebService{
    
     NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
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
