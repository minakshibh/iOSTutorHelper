//
//  TutorRegistrationViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "TutorRegistrationViewController.h"
#import "TutorFirstViewController.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#define kCountriesFileName @"countries.json"


@interface TutorRegistrationViewController ()

@end

@implementation TutorRegistrationViewController
@synthesize trigger,editView;


- (void)viewDidLoad
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self getCountryAndPhoneCode];
    if ([trigger isEqualToString:@"add"])
    {
        maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
        femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
        gender=@"male";
        editBttn.hidden=YES;
        [registerBtn setTitle: @"Register" forState: UIControlStateNormal];
        tutorIdStr=@"";
    }
    else{
        
        if ([editView isEqualToString:@"Parent"])
        {
            [self textFieldDisable];
            editBttn.hidden=NO;
            [registerBtn setTitle: @"Done" forState: UIControlStateNormal];
            parentIdStr= [[NSUserDefaults standardUserDefaults]valueForKey:@"pin"];
            [self getProfileDataFromDataBase];
        }
        else {
            [self textFieldDisable];
            editBttn.hidden=NO;
            [registerBtn setTitle: @"Done" forState: UIControlStateNormal];
            tutorIdStr= [[NSUserDefaults standardUserDefaults]valueForKey:@"tutor_id"];
            [self getProfileDataFromDataBase];
        }
    }
    
    self.navigationController.navigationBar.hidden=YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        scrollView.contentSize = CGSizeMake(320, 720);
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        scrollView.contentSize = CGSizeMake(320, 700);
    }
    else{
        scrollView.contentSize = CGSizeMake(320, 850);
    }
    scrollView.backgroundColor=[UIColor clearColor];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)getCountryAndPhoneCode
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    NSArray*countriesList = (NSArray *)parsedObject;
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    // NSString *currntCountryCode=@"IN";
    
    for (NSDictionary *countryCode1 in countriesList)
    {
        NSLog(@"%@",[countryCode1 valueForKey:@"code"]);
        if ([countryCode isEqualToString:[countryCode1 valueForKey:@"code"]])
        {
            NSLog(@"%@",[countryCode1 valueForKey:@"dial_code"]);
            phoneCountryCodeTxt.text = [NSString stringWithFormat:@"%@",[countryCode1 valueForKey:@"dial_code"]];
            alternateCountryCodeTxt.text = [NSString stringWithFormat:@"%@",[countryCode1 valueForKey:@"dial_code"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    return YES;
}
- (IBAction)editBttn:(id)sender {
    [self textFieldEnable];
    editBttn.hidden=YES;
}

- (IBAction)MenuBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerBtn:(id)sender {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    NSString* nameStr = [nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* emailAddressStr = [emailAddressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    passwordStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* confrmPassStr = [confirmPasswordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* phoneNumStr = [phoneNumberTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* alternatephoneNumStr = [alternatePhoneNumTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* addressStr = [addressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    [self.view endEditing:YES];
    
    if([nameStr isEqualToString:@""] &&[emailAddressStr isEqualToString:@""] && [passwordStr isEqualToString:@""] && [confrmPassStr isEqualToString:@""] && [phoneNumStr isEqualToString:@""] && [alternatephoneNumStr isEqualToString:@""] && [addressStr isEqualToString:@""])
        
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  KalertTittle message:@"Please enter all the details." delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([nameStr isEqualToString:@""])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Name of user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailAddressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the User Email Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([emailTest evaluateWithObject:emailAddressStr] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:KalertTittle message:@"Enter valid User Email Address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }
    else if ([passwordStr isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([confrmPassStr isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter Password to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![passwordStr isEqualToString:confrmPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Password does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([phoneNumStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Phone Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if (phoneNumStr.length<10 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the valid Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
//    
//    else if ([alternatephoneNumStr isEqualToString:@""])
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the alternative Phone Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    
    else if (alternatephoneNumStr.length<10 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the valid Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([addressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    
    else {
        phoneNumStr =[NSString stringWithFormat:@"%@ %@",phoneCountryCodeTxt.text,phoneNumStr];
        alternatephoneNumStr =[NSString stringWithFormat:@"%@ %@",alternateCountryCodeTxt.text,alternatephoneNumStr];
        [self UserRegistration:nameStr Emailid:emailAddressStr Password:passwordStr Contactnum:phoneNumStr Contactnum2:alternatephoneNumStr Address:addressStr];
    }
}

- (IBAction)MaleBtn:(id)sender {
    gender=@"male";
    
    maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
}

- (IBAction)FemaleBtn:(id)sender {
    gender=@"female";
    femaleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    maleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];

}

-(void)UserRegistration:(NSString*)name Emailid:(NSString*)emailid Password:(NSString *)password Contactnum:(NSString *)contactnum Contactnum2:(NSString*)Contactnum2 Address:(NSString*)Address
{
    NSString *_postData ;
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;

   // contactnum=[NSString stringWithFormat:@"%@%@",phoneCode,contactnum];
    if ([editView isEqualToString:@"Parent"])
    {
        _postData = [NSString stringWithFormat:@"name=%@&email=%@&pass=%@&contact_number=%@&alt_contact_number=%@&address=%@&gender=%@&parent_id=%@",name,emailid,password,contactnum,Contactnum2,Address,gender,parentIdStr];
          request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/edit-profile.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    else{
      _postData = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&phone=%@&alternate_phone=%@&address=%@&trigger=%@&gender=%@&tutor_id=%@",name,emailid,password,contactnum,Contactnum2,Address,trigger,gender,tutorIdStr];
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/register.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
  
    }
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

    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        {
            nameTxt.text=@"";
            passwordTxt.text=@"";
            confirmPasswordTxt.text=@"";
            emailAddressTxt.text=@"";
            phoneNumberTxt.text=@"";
            alternatePhoneNumTxt.text=@"";
            addressTxt.text=@"";
            
            if ([trigger isEqualToString:@"add"])
            {
                NSString*tutor_id=[userDetailDict valueForKey:@"tutor_id"];
                [[NSUserDefaults standardUserDefaults]setValue:tutor_id forKey:@"tutor_id"];
                   
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"Congrats!!! Your account has been registered with us.Your Tutor Id is %@",tutor_id] delegate:self cancelButtonTitle:@"Get Started!" otherButtonTitles:nil];
                [alert show];
                
                [self saveDataTodtaaBase:userDetailDict];

                getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:tutor_id delegate:self webdata:webData trigger:@"Tutor"];
                [self.view addSubview: getDetailView];
                   
            }
            else {
                [self saveDataTodtaaBase:userDetailDict];

                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"Your account has been edit successfuly."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert.tag=5;
            }
        }
    }
}

- (void)ReceivedResponse {
    [self MoveToTutorFirstView];
}

-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *insert;
    if (![editView isEqualToString:@"Parent"])
    {
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from TutorProfile "];
        [database executeUpdate:deleteQuery];
        
        [[NSUserDefaults standardUserDefaults]setValue:[userDetailDict valueForKey:@"name"] forKey:@"tutor_name"];
        NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        insert = [NSString stringWithFormat:@"INSERT INTO TutorProfile (tutorID, name, password, address, contactNumber , alt_contactNumber , gender ,email) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",tutorId,[userDetailDict valueForKey:@"name"],passwordStr,[userDetailDict valueForKey:@"address"],[userDetailDict valueForKey:@"contact_number"],[userDetailDict valueForKey:@"alt_c_number"],[userDetailDict valueForKey:@"gender"],[userDetailDict valueForKey:@"email"]];
    }
    else
    {
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from ParentProfile "];
        [database executeUpdate:deleteQuery];
        NSString *parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        
        [[NSUserDefaults standardUserDefaults]setValue:[userDetailDict valueForKey:@"name"] forKey:@"parent_name"];
        
        insert = [NSString stringWithFormat:@"INSERT INTO ParentProfile (parentId, name, password, address, contactNumber , alt_contactNumber , gender ,email) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",parentId,[userDetailDict valueForKey:@"name"],passwordStr,[userDetailDict valueForKey:@"address"],[userDetailDict valueForKey:@"contact_number"],[userDetailDict valueForKey:@"alt_c_number"],[userDetailDict valueForKey:@"gender"],[userDetailDict valueForKey:@"email"]];
    }
    [database executeUpdate:insert];
    [database close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (alertView.tag==6)
    {
        [self MoveToTutorFirstView];
    }
    if (alertView.tag==5)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Text field Delegates


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField== phoneNumberTxt || textField==alternatePhoneNumTxt )
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
       if(IS_IPHONE_4_OR_LESS)
       {
           if (textField.tag== 1 ||textField.tag== 2)
           {
               [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
               return YES;
           }
           else if (textField.tag== 3 ||textField.tag== 4 ||textField.tag== 5)
           {
               [scrollView setContentOffset:CGPointMake(0.0, 140.0) animated:YES];
               return  YES;
           }
           else if (textField.tag== 6 ||textField.tag== 7 )
           {
               [scrollView setContentOffset:CGPointMake(0.0, 105.0) animated:YES];
               return  YES;
           }
           else if (textField.tag==8)
           {
               [scrollView setContentOffset:CGPointMake(0.0, 120.0) animated:YES];
               return  YES;
           }
       }
       else
       {
           if (textField.tag== 1 ||textField.tag== 2 || textField.tag== 3  )
           {
               [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
               return YES;
           }
           else if (textField.tag== 4 ||textField.tag== 5 )
           {
               [scrollView setContentOffset:CGPointMake(0.0, 150.0) animated:YES];
               return  YES;
           }
           else if (textField.tag== 6 ||textField.tag== 7 ||textField.tag==8)
           {
               [scrollView setContentOffset:CGPointMake(0.0, 130.0) animated:YES];
               return  YES;
           }
       }

    return  YES;
}

-(void)dismissKeyboard
{
    [phoneNumberTxt resignFirstResponder];
    [alternatePhoneNumTxt resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

-(void)MoveToTutorFirstView
{
    TutorFirstViewController* tutorFirstVc=[[TutorFirstViewController alloc]initWithNibName:@"TutorFirstViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:tutorFirstVc animated:YES];
}

-(void)textFieldDisable{
    nameTxt.userInteractionEnabled=NO;
    emailAddressTxt.userInteractionEnabled=NO;
    passwordTxt.userInteractionEnabled=NO;
    confirmPasswordTxt.userInteractionEnabled=NO;
    addressTxt.userInteractionEnabled=NO;
    phoneNumberTxt.userInteractionEnabled=NO;
    alternatePhoneNumTxt.userInteractionEnabled=NO;
    maleBtn.userInteractionEnabled=NO;
    femateBtn.userInteractionEnabled=NO;
    registerBtn.userInteractionEnabled=NO;
    registerBtn.hidden=YES;
    confirmPassBackImg.hidden=YES;
    confirmPassIcon.hidden=YES;
    confirmPasswordTxt.hidden=YES;
}

-(void)textFieldEnable
{
    
    nameTxt.userInteractionEnabled=YES;
    emailAddressTxt.userInteractionEnabled=YES;
    passwordTxt.userInteractionEnabled=YES;
    confirmPasswordTxt.userInteractionEnabled=YES;
    addressTxt.userInteractionEnabled=YES;
    phoneNumberTxt.userInteractionEnabled=YES;
    alternatePhoneNumTxt.userInteractionEnabled=YES;
    maleBtn.userInteractionEnabled=YES;
    femateBtn.userInteractionEnabled=YES;
    registerBtn.userInteractionEnabled=YES;
    registerBtn.hidden=NO;
    confirmPassBackImg.hidden=NO;
    confirmPassIcon.hidden=NO;
    confirmPasswordTxt.hidden=NO;

}

-(void)getProfileDataFromDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    if ([editView isEqualToString:@"Tutor"])
    {
        queryString = [NSString stringWithFormat:@"Select * FROM TutorProfile where tutorID=\"%@\" ",tutorIdStr];
    }
    else
    {
        parentIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        queryString = [NSString stringWithFormat:@"Select * FROM ParentProfile where parentId=\"%@\" ",parentIdStr];
    }
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        nameTxt.text =[results stringForColumn:@"name"];
        emailAddressTxt.text =[results stringForColumn:@"email"];
        passwordTxt.text =[results stringForColumn:@"password"];
        confirmPasswordTxt.text =[results stringForColumn:@"password"];
        phoneNumberTxt.text =[results stringForColumn:@"contactNumber"];
        alternatePhoneNumTxt.text=[results stringForColumn:@"alt_contactNumber"];
        addressTxt.text=[results stringForColumn:@"address"];
        gender= [results stringForColumn:@"gender"];
        if ([gender isEqualToString:@"male"])
        {
            maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
            femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
        }
        else
        {
            femaleImageView.image=[UIImage imageNamed:@"radio_active.png"];
            maleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
        }
    }
    [database close];
}
@end
