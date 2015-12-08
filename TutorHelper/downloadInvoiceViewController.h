//
//  downloadInvoiceViewController.h
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 23/10/15.
//  Copyright © 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadInvoiceViewController : UIViewController
{
    NSMutableData *webdata;
    IBOutlet UITableView *tableView;
    NSArray *year,*months,*noOfmonths;
    IBOutlet UIView *viewPOPUP;
    IBOutlet UILabel *lblbackgroundPOPUP;
    IBOutlet UIWebView *webView;
    NSString *opened_pdf;
}
- (IBAction)btnCross:(id)sender;
- (IBAction)btnSharePDF:(id)sender;

- (IBAction)backBttn:(id)sender;

@end
