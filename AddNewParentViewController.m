//
//  AddNewParentViewController.m
//  TutorHelper
//
//  Created by Br@R on 24/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AddNewParentViewController.h"
#import "AddStudentViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kCountriesFileName @"countries.json"
@interface AddNewParentViewController ()

@end

@implementation AddNewParentViewController

- (void)viewDidLoad {
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"parentDetailDict"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self getCountryAndPhoneCode];
    
    gender=@"male";
    maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];

    
    
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
            countryCodetxt.text = [NSString stringWithFormat:@"%@",[countryCode1 valueForKey:@"dial_code"]];
        }
    }
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

- (IBAction)doneBtn:(id)sender {
    
    [self.view endEditing:YES];
    NSString* nameStr = [nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* emailAddressStr = [emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*contactStr = [contactTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*addressStr = [addressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    [self.view endEditing:YES];
  
    if ([nameStr isEqualToString:@""])
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
    else if (contactStr.length>11)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter a valid phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }else if (contactStr.length<7)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter a valid phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else  if ([addressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Enter the Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    contactStr =[NSString stringWithFormat:@"%@ %@",countryCodetxt.text,contactStr];
    NSMutableDictionary*parentDetailDict=[[NSMutableDictionary alloc]init];
    [parentDetailDict setValue:@"-1" forKey:@"p_id"];
    [parentDetailDict setValue:nameStr forKey:@"p_name"];
    [parentDetailDict setValue:emailAddressStr forKey:@"p_email"];
    [parentDetailDict setValue:contactStr forKey:@"p_contact"];
    [parentDetailDict setValue:addressStr forKey:@"p_address"];
    [parentDetailDict setValue:gender forKey:@"p_gender"];

    [[NSUserDefaults standardUserDefaults ]setValue:parentDetailDict forKey:@"parentDetailDict"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)maleBtn:(id)sender {
    gender=@"male";
    maleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    femaleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
}

- (IBAction)femaleBtn:(id)sender {
    gender=@"female";
    femaleImageView.image=[UIImage imageNamed:@"radio_active.png"];
    maleImageView.image=[UIImage imageNamed:@"radio_inactive.png"];
}

- (IBAction)cancelBtn:(id)sender {
     [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"parentDetailDict"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==3) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
    return  YES;
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
