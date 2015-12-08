//
//  PDFReportsViewController.h
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 21/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lessonDetailsOC.h"
@interface PDFReportsViewController : UIViewController
{
    IBOutlet UIWebView *webview;
    int process;
    NSArray *no_of_count;
}
- (IBAction)backBTN:(id)sender;
- (IBAction)sharePdf:(id)sender;
- (IBAction)btnBack:(id)sender;



NSInteger stringToInt(NSString *string);
+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;
+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;
@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) NSString *startdate,*enddate,*parent_name1,*tutor_name,*tutor_id,*parent_id,*session,*date;
@property(strong,nonatomic)lessonDetailsOC*lessondetailObj1;
-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
@end
