//
//  PDFGenerateViewController.m
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 17/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "PDFGenerateViewController.h"
#import <CoreText/CoreText.h>
#import "PDFViewController.h"
@interface PDFGenerateViewController ()

@end

@implementation PDFGenerateViewController
NSString* fileName;
@synthesize data,tutor_id,tutor_name,parent_id,parent_name1;
PDFViewController *data_obj;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    fileName = [self getPDFFileName];
    
    [self drawPDF:fileName];
    
    [self showPDFFile];
    
    // Close the PDF context and write the contents out.
   
}
-(void)showPDFFile
{
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web setScalesPageToFit:YES];
    [web loadRequest:request];
    
    //[self.view addSubview:webView];
}
-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}
+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    
    [image drawInRect:rect];
    
}
-(NSString*)getPDFFileName
{
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}
-(void)drawPDF:(NSString*)fileName
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
   // [self drawText];
   // [self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];
    
   // [self drawLabels];
   // [self drawLogo];

    int xOri = 30;
    int yOri = 76;
    int rowno = 100;
    int columnno = 40;

    CGRect frame = CGRectMake(xOri, yOri+41, rowno, columnno);
    CGRect frame1 = CGRectMake(xOri, yOri, rowno, columnno);
    NSString *start_date = [NSString stringWithFormat:@"StartDate :  %@",_startdate];
    NSString *end_date = [NSString stringWithFormat:@"EndDate :  %@",_enddate];
    [self drawText:start_date inFrame:frame];
    [self drawText:end_date inFrame:frame1];
    
    int xOri_parent_name = 30;
    int yOri_parent_name = 200;
    int rowno_parent_name = 100;
    int columnno_parent_name = 40;
    CGRect frame_parent_name = CGRectMake(xOri_parent_name, yOri_parent_name, rowno_parent_name, columnno_parent_name);
    NSString *parent_name = [NSString stringWithFormat:@"Parent Name : %@",parent_name1];
    [self drawText:parent_name inFrame:frame_parent_name];
    
    int xOri_Gen_Date = 440;
    int yOri_Gen_Date = 76;
    int rowno_Gen_Date = 100;
    int columnno_Gen_Date = 40;
    CGRect frame_Gen_Date = CGRectMake(xOri_Gen_Date, yOri_Gen_Date, rowno_Gen_Date, columnno_Gen_Date);
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date22 = [NSDate date];
    NSString *_Gen_Date = [NSString stringWithFormat:@"Generation Date : %@",date22];
    [self drawText:_Gen_Date inFrame:frame_Gen_Date];

    int xOri_tutor_name = 440;
    int yOri_tutor_name = 115;
    int rowno_tutor_name = 100;
    int columnno_tutor_name = 40;
    CGRect frame_tutor_name = CGRectMake(xOri_tutor_name, yOri_tutor_name, rowno_tutor_name, columnno_tutor_name);
    if ([tutor_name isKindOfClass:[NSNull class]])
    {
        tutor_name = @" ";
    }
    NSString *_tutor_name = [NSString stringWithFormat:@"Tutor Name : %@",tutor_name];
    [self drawText:_tutor_name inFrame:frame_tutor_name];
    
    int xOri_tutor_id = 440;
    int yOri_tutor_id = 158;
    int rowno_tutor_id = 100;
    int columnno_tutor_id = 40;
    CGRect frame_tutor_id = CGRectMake(xOri_tutor_id, yOri_tutor_id, rowno_tutor_id, columnno_tutor_id);
    NSString *_tutor_id = [NSString stringWithFormat:@"Tutor ID :    %@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"]];
    [self drawText:_tutor_id inFrame:frame_tutor_id];
    
    int xOri_parent_id = 440;
    int yOri_parent_id = 200;
    int rowno_parent_id = 100;
    int columnno_parent_id = 40;
    CGRect frame_parent_id = CGRectMake(xOri_parent_id, yOri_parent_id, rowno_parent_id, columnno_parent_id);
    if (parent_id == (NSString *)[NSNull null])
    {
        parent_id = @" ";
    }
    NSString *_parent_id = [NSString stringWithFormat:@"Parent ID : %@",parent_id];
    [self drawText:_parent_id inFrame:frame_parent_id];
    
    
    int xOrigin = 30;
    int xOrigin1 = 40;
    int yOrigin = 200;
    int yOrigin1 = 215 ;
    
    int rowHeight = 50;
    int columnWidth = 105;
    
    int numberOfRows = data.count+1;
    int numberOfColumns = 5;
    
    [self drawTableAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    [self drawTableDataAt:CGPointMake(xOrigin1, yOrigin1) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
//    UIImage* logo = [UIImage imageNamed:@"40X40.png"];
//    CGRect frame = CGRectMake(20, 100, 300, 60);
//    
//    [PDFGenerateViewController drawImage:logo inRect:frame];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}
-(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    NSArray* headers = [NSArray arrayWithObjects:@"S. No.", @"Date", @"Payment Mode", @"Remarks", @"Fee paid",nil];
//    NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", @"Development1", @"$1000", @"$1000",@"", nil];
//    NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"2", @"Development2", @"$2000", @"$1000", nil];
//    NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"3", @"Developmen3", @"$3000", @"$1000", nil];
//    NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"4", @"Development4", @"$4000", @"$1000", nil];
    
    
   
    
    NSMutableArray* allInfo = [[NSMutableArray alloc]init];
    [allInfo addObject:headers];
    data_obj = [[PDFViewController alloc]init];
    
    for (int i=0; i<data.count; i++) {
        data_obj = [data objectAtIndex:i];
        NSString *Fee = [NSString stringWithFormat:@"$ %@",data_obj.fee_paid];
        NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", data_obj.last_update,data_obj.payment_mode, data_obj.remarks,Fee, nil];
        [allInfo addObject:invoiceInfo1];
    }
    
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSMutableArray* infoToDraw = [allInfo objectAtIndex:i];
        if (i>0) {
             int a = i;
            NSArray *arr = [NSArray arrayWithObjects:[infoToDraw objectAtIndex:0],[infoToDraw objectAtIndex:1],[infoToDraw objectAtIndex:2],[infoToDraw objectAtIndex:3],[infoToDraw objectAtIndex:4], nil];
            infoToDraw = [[NSMutableArray alloc]init];
            NSString *abc = [NSString stringWithFormat:@"%d",a];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults]setObject:abc forKey:@"thread"];
            [infoToDraw addObject:[user valueForKey:@"thread"]];
            [infoToDraw addObject:[arr objectAtIndex:1]];
            [infoToDraw addObject:[arr objectAtIndex:2]];
            [infoToDraw addObject:[arr objectAtIndex:3]];
            [infoToDraw addObject:[arr objectAtIndex:4]];
        }
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            CGRect frame;
            if(j==0)
            {
            frame = CGRectMake(newOriginX+10, newOriginY, columnWidth, rowHeight);
            }else if(j==1)
            {
            frame = CGRectMake(newOriginX-50, newOriginY, columnWidth, rowHeight);
            }else if(j==2)
            {
            frame = CGRectMake(newOriginX-50, newOriginY, columnWidth, rowHeight);
            }else if(j==3)
            {
            frame = CGRectMake(newOriginX-50, newOriginY, columnWidth+50, rowHeight);
            }else if(j==4){
            frame = CGRectMake(newOriginX+20, newOriginY, columnWidth, rowHeight);
            }
            
            if([[infoToDraw objectAtIndex:j] isEqualToString:@"S. No."])
            {
                frame = CGRectMake(newOriginX, newOriginY, columnWidth, rowHeight);
            }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Date"])
            {
               frame = CGRectMake(newOriginX-35, newOriginY, columnWidth, rowHeight);
            }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Payment Mode"])
            {
                frame = CGRectMake(newOriginX-54, newOriginY, columnWidth, rowHeight);
            }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Remarks"])
            {
                frame = CGRectMake(newOriginX-20, newOriginY, columnWidth+50, rowHeight);
            }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Fee paid"])
            {
                frame = CGRectMake(newOriginX+15, newOriginY, columnWidth, rowHeight);
            }
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
        }        
    }    
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnShare:(id)sender {
    [self shareText:fileName];
}

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CGPoint from = CGPointMake(50, 50);
    CGPoint to = CGPointMake(50 ,50);
    for (int i=0; i<5; i++) {
        [self drawLineFromPoint:from toPoint:to];
    }
    
    
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}
+(void)drawLogo
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"PDFViewController" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImage* logo = [UIImage imageNamed:@"Splash@2x.jpg"];
            [self drawImage:logo inRect:view.frame];
        }
    }
}
-(void)drawTableAt:(CGPoint)origin
     withRowHeight:(int)rowHeight
    andColumnWidth:(int)columnWidth
       andRowCount:(int)numberOfRows
    andColumnCount:(int)numberOfColumns

{
    for (int i = 0; i <= numberOfRows; i++)
    {
        int newOrigin = origin.y + (rowHeight*i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
    }
    for (int i = 0; i <= numberOfColumns; i++)
    {
        int newOrigin;
        if(i==1)
        {
             newOrigin = origin.x + (columnWidth*i)-57;
        }else if(i==0){
            newOrigin = origin.x + (columnWidth*i);
        }else if(i==2){
            newOrigin = origin.x + (columnWidth*i)-57;
        }else if(i==3){
            newOrigin = origin.x + (columnWidth*i)-57;
        }else if(i==4){
            newOrigin = origin.x + (columnWidth*i);
        }else if(i==5){
            newOrigin = origin.x + (columnWidth*i);
        }
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        
        [self drawLineFromPoint:from toPoint:to];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)shareText:(NSString *)text
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
   NSData * pdfData = [NSData dataWithContentsOfFile:text];
        [sharingItems addObject:pdfData];
    
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end

