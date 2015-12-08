//
//  PDFGenerateViewController.h
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 17/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFGenerateViewController : UIViewController
{
    
    IBOutlet UIWebView *web;
}
- (IBAction)btnBack:(id)sender;


- (IBAction)btnShare:(id)sender;

//+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;
//+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;
@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) NSString *startdate,*enddate,*parent_name1,*tutor_name,*tutor_id,*parent_id;
@end
