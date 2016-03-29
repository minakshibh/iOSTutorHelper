//
//  downloadInvoiceViewController.m
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 23/10/15.
//  Copyright © 2015 Krishnais. All rights reserved.
//

#import "downloadInvoiceViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "MBProgressHUD.h"
#import "downloadInvoiceTableViewCell.h"
@interface downloadInvoiceViewController ()

@end

@implementation downloadInvoiceViewController
MBProgressHUD *hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getinvoiceDetail];
    
     lblbackgroundPOPUP.alpha=0.5;
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


- (IBAction)backBttn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) getinvoiceDetail{
    NSString*_postData ;
    
    
    NSString *parentId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
    
    if (parentId.length>0)
    {
        _postData = [NSString stringWithFormat:@"pid=%@",parentId ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/generateInvoice.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webdata==nil)
            {
                webdata = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webdata=nil;
                webdata = [NSMutableData data] ;
            }
            NSLog(@"server connection made");
        }
        else
        {
            NSLog(@"connection is NULL");
        }
    }
    else{
        
    }
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webdata =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data>>%@",data);
    webdata=[[NSMutableData alloc]initWithData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webdata length]);
    if ([webdata length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webdata encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
    if([resultStr isEqualToString:@"0"])
    {
        year = [[userDetailDict valueForKey:@"invoices"]valueForKey:@"year"];
        months = [[userDetailDict valueForKey:@"invoices"]valueForKey:@"months"];
//        noOfmonths = [[months valueForKey:@"month"]objectAtIndex:2];
        
        [tableView reloadData];
    }
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return year.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    for (int i=0; i<year.count; i++) {
        
        if (section==i) {
           noOfmonths = [[months valueForKey:@"month"]objectAtIndex:i];
        }
    }
   
    return noOfmonths.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"Number of Sections");
    NSString *sectionHeading;
    for (int i=0; i<year.count; i++) {
        if (section==i) {
            sectionHeading = [NSString stringWithFormat:@"%@",[year objectAtIndex:i]];
        }
    }
        return sectionHeading;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    NSString *sectionHeading;
    for (int i=0; i<year.count; i++) {
        if (section==i) {
            sectionHeading = [NSString stringWithFormat:@"%@",[year objectAtIndex:i]];
        }
    }
    
    [label setText:sectionHeading];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:71/255.0 green:186/255.0 blue:204/255.0 alpha:1.0]]; //your background color...
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    
    downloadInvoiceTableViewCell *cell = (downloadInvoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"downloadInvoiceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
//    UILabel *btnurl;
//      
//    btnurl = [[UILabel alloc]initWithFrame:CGRectMake(cell.textLabel.frame.size.width +40, cell.frame.size.height/4, self.view.frame.size.width-cell.textLabel.frame.size.width-40, 25.0f)];
//    
//    
//    btnurl.textAlignment = UIControlContentHorizontalAlignmentRight;
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Download Invoice"];
//    [attributeString addAttribute:NSUnderlineStyleAttributeName
//                            value:[NSNumber numberWithInt:1]
//                            range:(NSRange){0,[attributeString length]}];
//    btnurl.attributedText = [attributeString copy];
//        btnurl.tag = 3;
    
    
//    cell.backgroundColor = [UIColor whiteColor];
    
   // NSString *value = [[months valueForKey:@"month"]objectAtIndex:indexPath.row];

   
        NSArray *value,*url;
    NSString *valueStr,*urlStr;
    for (int i=0; i<year.count; i++) {
//        if(indexPath.section==0)
//        {
//            return  cell;
//        }
        NSLog(@"%ld",(long)indexPath.section);
        NSLog(@"%ld",(long)indexPath.row);
        if (indexPath.section==i) {
            value = [[months valueForKey:@"month"]objectAtIndex:i];
            valueStr =[NSString stringWithFormat:@"%@",[value objectAtIndex:indexPath.row]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, cell.frame.size.height/5, 120, 30)];
            [label setFont:[UIFont systemFontOfSize:16]];
            //[cell.contentView addSubview:label];
            
            label.text = valueStr;
            
            url = [[months valueForKey:@"invoicelink"]objectAtIndex:i];
            urlStr = [NSString stringWithFormat:@"%@",[url objectAtIndex:indexPath.row]];
            
            
            if(![urlStr isEqualToString:@""])
            {
                //[cell addSubview:btnurl];
//                btnurl=nil;
                [cell setLabelText:valueStr :@"Download Invoice"];
                
            }else{
                [cell setLabelText:valueStr :@""];

            }
            
            break;
        }
        
    }
    
//    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main-bg.png"]];
    [tableView setBackgroundView:bg];
    
  return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    
    
    //    pdfurl = @"http://112.196.24.206/tutor_helper/imageGenerator/pdf/pdf0-17830400-1445583426.pdf";
    //    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pdfurl]];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    //    [webView loadRequest:request];
    //
    NSArray *url;
    NSString *urlStr;
    for (int i=0; i<year.count; i++) {
        
        NSLog(@"%ld",(long)indexPath.section);
        NSLog(@"%ld",(long)indexPath.row);
        if (indexPath.section==i) {
            
            
            url = [[months valueForKey:@"invoicelink"]objectAtIndex:i];
            urlStr = [NSString stringWithFormat:@"%@",[url objectAtIndex:indexPath.row]];
            
            
            break;
        }
    }
    
    if ([urlStr rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        
    }else{
        urlStr = [NSString stringWithFormat:@"http://%@",urlStr];
    }
    //  Get the PDF Data from the url in a NSData Object
    NSData *pdfData = [[NSData alloc]init];
    //    pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pdfurl]];
    
    // Store the Data locally as PDF File
    NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                  stringByAppendingPathComponent:@"Documents"
                                                                  ]];
    
    NSString *filePath = [resourceDocPath
                          stringByAppendingPathComponent:@"myPDF.pdf"];
    [pdfData writeToFile:filePath atomically:YES];
    
    
    // Now create Request for the file that was saved in your documents folder
    // NSURL *url = [NSURL fileURLWithPath:filePath];
    //NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    NSURL *url1 = [NSURL URLWithString:urlStr];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url1    ];
    
    opened_pdf = [[NSString alloc]init];
    opened_pdf = urlStr;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:ur ofType:@"pdf"];
    //    NSURL *targetURL = [NSURL fileURLWithPath:path];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    //    [webView loadRequest:request];
    
    [webView setUserInteractionEnabled:YES];
    [webView setDelegate:self];
    [webView loadRequest:requestObj];
    viewPOPUP.hidden = NO;
    [self.view bringSubviewToFront:viewPOPUP];
}
- (void)urlClicked:(UIControl *)sender
{
   
}
- (IBAction)btnCross:(id)sender {
    viewPOPUP.hidden = YES;
    
    
}
#pragma - mark UIWebView Delegate Methods
//--- check for the webview to enter text in text field
- (BOOL)isWebViewFirstResponder
{
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.activeElement.tagName"];
    if([[str lowercaseString]isEqualToString:@"input"]) {
        return YES;
    }
    return NO;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
   // NSString *presentURL = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    
    if([self isWebViewFirstResponder] &&
       navigationType != UIWebViewNavigationTypeFormSubmitted) {
        
        return NO;
    } else {
        
        return YES;
    }
    
    //return FALSE; //to stop loading
}
//------

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //--------custom tost-------
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"PDF saved in the document directory...";
    hud.margin = 10.f;
    hud.yOffset = 220.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
   
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}
- (IBAction)btnSharePDF:(id)sender
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    NSData *pdfData = [[NSData alloc]init];
        pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:opened_pdf]];
    if([pdfData isKindOfClass:[NSNull class]])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"No data found to share..." otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
        [sharingItems addObject:pdfData];
    
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
