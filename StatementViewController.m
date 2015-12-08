//
//  StatementViewController.m
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 17/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StatementViewController.h"
#import "ParentList.h"
#import "PDFGenerateViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "PDFViewController.h"
@interface StatementViewController ()

@end

@implementation StatementViewController
@synthesize parentListObj;
- (void)viewDidLoad {
    tutor_id =[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    [super viewDidLoad];
    tableview.hidden= YES;
    [self fetchParentListFomDataBase];
    [dateTimePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
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

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnGenerateStatement:(id)sender {
    
    if([lblStartTime.text isEqualToString:@"-Select Start Date-"] || [lblEndTime.text isEqualToString:@"-Select End Date-"] || [selected_parent_id isEqualToString:@" "])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Plese select all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [kappDelegate ShowIndicator];
    [self getData];
    
}

- (IBAction)btnSelectParent:(id)sender {
    if (parentListArray.count>0)
    {
        tableview.hidden=NO;
       
    }
}

- (IBAction)btnSelectEndTime:(id)sender {
    
    if([lblStartTime.text isEqualToString:@"-Select Start Date-"])
    {
        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Select start date First" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    
        [self.view endEditing:YES];
        btnGenerateStatement.hidden = YES;

    
        getDate =@"LessonEnd";
        NSString *dateEnd =lblEndTime.text;
        if (![dateEnd isEqualToString:@"-Select End Date-"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date2 = [formatter dateFromString:dateEnd];
            dateTimePicker.date=date2;
            dateSelected=dateEnd;
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date2 = [formatter stringFromDate:[NSDate date]];
            NSDate* currentTime = [formatter dateFromString:date2];
            dateSelected=date2;
            dateTimePicker.date=currentTime;
        }
        pickerbackView.hidden=NO;
        dateTimePicker.datePickerMode=UIDatePickerModeDate;
}

- (IBAction)btnSelectStartTime:(id)sender {
    [self.view endEditing:YES];
    btnGenerateStatement.hidden = YES;
    [self.view bringSubviewToFront:pickerbackView];
    getDate =@"LessonStart";
    NSString *dateEnd =lblStartTime.text;
    if (![dateEnd isEqualToString:@"-Select Start Date-"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePicker.date=date2;
        dateSelected=dateEnd;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date2 = [formatter stringFromDate:[NSDate date]];
        NSDate* currentTime = [formatter dateFromString:date2];
        dateSelected=date2;
        dateTimePicker.date=currentTime;
    }
    pickerbackView.hidden=NO;
    dateTimePicker.datePickerMode=UIDatePickerModeDate;
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dateSelected=strDate;
}

- (IBAction)cancelDateView:(id)sender {
    dateSelected=@"";
    pickerbackView.hidden=YES;
}

- (IBAction)doneDateView:(id)sender {
   
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    if([getDate isEqualToString:@"LessonStart"])
    {
        NSDate *date1 = [NSDate date];
        NSDate *date2 = [DateFormatter dateFromString:dateSelected];
        
        if ([date1 compare:date2] != NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select a valid date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        lblStartTime.text = dateSelected;
    }else{
        NSDate *date1 = [DateFormatter dateFromString:lblStartTime.text];
        NSDate *date2 = [DateFormatter dateFromString:dateSelected];

         if ([date1 compare:date2] == NSOrderedDescending)
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select a valid date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
             return;
         }
        
        
        NSDate *date22 = [NSDate date];
        NSDate *date11 = [DateFormatter dateFromString:dateSelected];
        if ([date11 compare:date22] == NSOrderedDescending) {
            NSLog(@"date1 is later than date2");
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:@"Please select a valid date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        lblEndTime.text = dateSelected;
    }
    
       
        pickerbackView.hidden=YES;
    btnGenerateStatement.hidden = NO;

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
    [tableview reloadData];
}


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
    tableview.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=parentListObj.parentName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    parentListObj = (ParentList *)[parentListArray objectAtIndex:indexPath.row];
    lblSelectparent.text=[NSString stringWithFormat:@"Parent Id:%@",parentListObj.parentName];
    selected_parent_id = parentListObj.parent_id;
       tableview.hidden=YES;
    parent_name = parentListObj.parentName;
}


-(void)getData
{
    
    NSString*_postData = [NSString stringWithFormat:@"start_date=%@&end_date=%@&parent_id=%@&tutor_id=%@",lblStartTime.text,lblEndTime.text,selected_parent_id,[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/parent-statement.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength:0];
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
        else  if (result==0)
        {
            NSArray *recieved_Data = [userDetailDict valueForKey:@"payment_list"];
            
            if (!recieved_Data || !recieved_Data.count){
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Tutor Helper"
                                              message:@"No data to display"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Okey"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handel your yes please button action here
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                
                                            }];
                
                [alert addAction:yesButton];
           
                [self presentViewController:alert animated:YES completion:nil];

                return;
            }
            
            NSDictionary *data = [recieved_Data objectAtIndex:0];
            
            statement_data = [[NSMutableArray alloc]init];
            
            for (int i=0; i<recieved_Data.count; i++){
                PDFViewController *obj = [[PDFViewController alloc]init];
                obj.fee_paid = [[recieved_Data valueForKey:@"fee_paid"] objectAtIndex:i];
                obj.last_update = [[recieved_Data valueForKey:@"last_updated"] objectAtIndex:i];

                obj.parent_id = [[recieved_Data valueForKey:@"parent_id"] objectAtIndex:i];
                obj.parent_name = [[recieved_Data valueForKey:@"parent_name"] objectAtIndex:i];
                obj.payment_mode = [[recieved_Data valueForKey:@"payment_mode"] objectAtIndex:i];
                obj.remarks = [[recieved_Data valueForKey:@"remarks"] objectAtIndex:i];
                obj.tutor_id = [[recieved_Data valueForKey:@"tutor_id"] objectAtIndex:i];
                obj.tutor_name = [[recieved_Data valueForKey:@"tutor_name"] objectAtIndex:i];
                [statement_data addObject:obj];
            }
            PDFGenerateViewController *obj = [[PDFGenerateViewController alloc]initWithNibName:@"PDFGenerateViewController" bundle:nil];
            obj.data = statement_data;
            obj.startdate = lblStartTime.text;
            obj.enddate = lblEndTime.text;
            obj.parent_name1 = parent_name;
            if(recieved_Data.count >0)
            {
                
                if ([[recieved_Data valueForKey:@"tutor_name"] objectAtIndex:0] == (NSString *)[NSNull null] || [[recieved_Data valueForKey:@"tutor_id"] objectAtIndex:0]== (NSString *)[NSNull null] ||  [[recieved_Data valueForKey:@"parent_id"] objectAtIndex:0]== (NSString *)[NSNull null])
                {
                    obj.tutor_name = [[recieved_Data valueForKey:@"tutor_name"] objectAtIndex:0];
                    obj.tutor_id = [[recieved_Data valueForKey:@"tutor_id"] objectAtIndex:0];
                    obj.parent_id = [[recieved_Data valueForKey:@"parent_id"] objectAtIndex:0];
                }
            

            }else
            {
                obj.tutor_name = @" ";
                obj.tutor_id = @" ";
                obj.parent_id = @" ";
            }
            [self.navigationController pushViewController:obj  animated:YES];
            [kappDelegate HideIndicator];
    }
}
}

@end
