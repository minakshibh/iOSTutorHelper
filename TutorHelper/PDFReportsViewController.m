//
//  PDFReportsViewController.m
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 21/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "PDFReportsViewController.h"
#import <CoreText/CoreText.h>
@interface PDFReportsViewController ()

@end

@implementation PDFReportsViewController
NSString* fileName;
@synthesize data,tutor_id,tutor_name,parent_id,parent_name1;


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
    [webview setScalesPageToFit:YES];
    [webview loadRequest:request];
    
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
     no_of_count = _lessondetailObj1.studentArrayList;
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    
    NSArray *session_date = [self.session componentsSeparatedByString:@","];
    int a = session_date.count/9 +1;
    
    // Mark the beginning of a new page.
    if(session_date.count>0)
    {
      UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 770+43*session_date.count), nil);
    }else
    {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    }
//    
//    for (int i=0; i<a; i++) {
//         UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
//    }
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
    
    
    
    int xOri_parent_name = 30;
    int yOri_parent_name = 85;
    int rowno_parent_name = 100;
    int columnno_parent_name = 50;
    CGRect frame_parent_name = CGRectMake(xOri_parent_name, yOri_parent_name, rowno_parent_name, columnno_parent_name);
    NSString *parent_name = [NSString stringWithFormat:@"%@",_lessondetailObj1.lesson_description];
    [self drawText:parent_name inFrame:frame_parent_name];
    
    int xOri_tutor_name = 440;
    int yOri_tutor_name = 115;
    int rowno_tutor_name = 100;
    int columnno_tutor_name = 40;
    CGRect frame_tutor_name = CGRectMake(xOri_tutor_name, yOri_tutor_name, rowno_tutor_name, columnno_tutor_name);
    
    
    NSArray *date11 = [_lessondetailObj1.lesson_start_time componentsSeparatedByString:@":"];
    NSString *date11_str;
    if(date11.count>0)
    { date11_str = [NSString stringWithFormat:@"%@:%@",[date11 objectAtIndex:0],[date11 objectAtIndex:1]];}
    
    NSArray *date222 = [_lessondetailObj1.lesson_end_time componentsSeparatedByString:@":"];
    NSString *date222_str;
    if(date222.count>0)
    { date222_str = [NSString stringWithFormat:@"%@:%@",[date222 objectAtIndex:0],[date222 objectAtIndex:1]];}
    NSString *_tutor_name = [NSString stringWithFormat:@"Time : %@-%@",date11_str,date222_str];
    [self drawText:_tutor_name inFrame:frame_tutor_name];
    
    
    int xOri_tutor_id = 440;
    int yOri_tutor_id = 158;
    int rowno_tutor_id = 100;
    int columnno_tutor_id = 40;
    CGRect frame_tutor_id = CGRectMake(xOri_tutor_id, yOri_tutor_id, rowno_tutor_id, columnno_tutor_id);
    NSString *_tutor_id = [NSString stringWithFormat:@"No of students : %lu",(unsigned long)_lessondetailObj1.studentArrayList.count];
    [self drawText:_tutor_id inFrame:frame_tutor_id];

    int xOri_tutor_id1 = 30;
    int yOri_tutor_id1 = 204;
    int rowno_tutor_id1 = 195;
    int columnno_tutor_id1 = 60;
    CGRect frame_tutor_id1 = CGRectMake(xOri_tutor_id1, yOri_tutor_id1, rowno_tutor_id1, columnno_tutor_id1);
    NSString *_tutor_id1 = [NSString stringWithFormat:@"Lesson Days: %@",_lessondetailObj1.lesson_days];
    [self drawText:_tutor_id1 inFrame:frame_tutor_id1];
    
    
    int xOri = 30;
    int yOri = 112;
    int rowno = 100;
    int columnno = 40;
    
    CGRect frame = CGRectMake(xOri, yOri+38, rowno, columnno);
    CGRect frame1 = CGRectMake(xOri, yOri, rowno, columnno);
    NSString *start_date = [NSString stringWithFormat:@"StartDate :  %@",_lessondetailObj1.lesson_date];
    NSString *end_date = [NSString stringWithFormat:@"EndDate :  %@",_lessondetailObj1.end_date];
    [self drawText:end_date inFrame:frame];
    [self drawText:start_date inFrame:frame1];
    
       
    NSArray *no_of_rows = [self.session componentsSeparatedByString:@","];
    
    
    CGRect frame_tutor_name4 = CGRectMake(280, 150, 150, 150);
    NSString *_tutor_name4 = [NSString stringWithFormat:@"Report"];
    
    [self drawText:_tutor_name4 inFrame:frame_tutor_name4];
    

    //-------process one-------
   
    
    process =1;
    int xOrigin_pro1 = 30;
    int xOrigin1_pro1 = 40;
    int yOrigin_pro1 = 200;
    int yOrigin1_pro1 = 215  ;
    
    int rowHeight_pro1 = 50;
    int columnWidth_pro1 = 105;
    
    int numberOfRows_pro1 = no_of_count.count+1;
    int numberOfColumns_pro1 = 5;
    
    [self drawTableAt:CGPointMake(xOrigin_pro1, yOrigin_pro1) withRowHeight:rowHeight_pro1 andColumnWidth:columnWidth_pro1 andRowCount:numberOfRows_pro1 andColumnCount:numberOfColumns_pro1];
    
    [self drawTableDataAt:CGPointMake(xOrigin1_pro1, yOrigin1_pro1) withRowHeight:rowHeight_pro1 andColumnWidth:columnWidth_pro1 andRowCount:numberOfRows_pro1 andColumnCount:numberOfColumns_pro1];
    
    
    
    
    
    //-------process two-------
    process =2;
    int xOrigin = 30;
    int xOrigin1 = 40;
    
    int yOrigin;
    int yOrigin1;
    if(no_of_count.count==0)
    {
         yOrigin = 290;
         yOrigin1 = 305;
        
        CGRect frame_tutor_name = CGRectMake(30, 420, 150, 150);
        NSString *_tutor_name = [NSString stringWithFormat:@"Session Details :"];
        [self drawText:_tutor_name inFrame:frame_tutor_name];
    }else if(no_of_count.count==1)
    {
     yOrigin = 360;
     yOrigin1 = 375 ;
        CGRect frame_tutor_name = CGRectMake(30, 490, 150, 150);
        NSString *_tutor_name = [NSString stringWithFormat:@"Session Details :"];
        [self drawText:_tutor_name inFrame:frame_tutor_name];

    }else if(no_of_count.count == 2)
    {
        yOrigin = 200+93*no_of_count.count+15;
        yOrigin1 = 215+94*no_of_count.count+15;
        
        CGRect frame_tutor_name = CGRectMake(30, 285+115*no_of_count.count+15, 150, 150);
        NSString *_tutor_name = [NSString stringWithFormat:@"Session Details :"];
        [self drawText:_tutor_name inFrame:frame_tutor_name];
    }else if(no_of_count.count > 2)
    {
        yOrigin = 200+93*no_of_count.count+15;
        yOrigin1 = 215+94*no_of_count.count+15;
        
        CGRect frame_tutor_name = CGRectMake(30, 265+115*no_of_count.count+15, 150, 150);
        NSString *_tutor_name = [NSString stringWithFormat:@"Session Details :"];
        [self drawText:_tutor_name inFrame:frame_tutor_name];
    }
    
    int rowHeight = 50;
    int columnWidth = 105;
    
    int numberOfRows = no_of_rows.count+1;
    int numberOfColumns = 3;
    
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
    NSArray* headers ;
    if (process == 1) {
    headers = [NSArray arrayWithObjects:@"S. No.", @"Student Name", @"Student ID",@"Tutor Name",@"Tutor ID",nil];
    }else {
     headers = [NSArray arrayWithObjects:@"S. No.", @"Session Date", @"/hr",nil];
    }
    NSArray *array = [self.session componentsSeparatedByString:@","];
    NSMutableArray* allInfo = [[NSMutableArray alloc]init];
    
    [allInfo addObject:headers];
    
    
    if (process ==1) {
        for (int i=0; i<no_of_count.count; i++){
          
            NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", [[no_of_count valueForKey:@"student_name"] objectAtIndex:i],[[no_of_count valueForKey:@"student_id"] objectAtIndex:i],_lessondetailObj1.tutor_name,[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"], nil];
            [allInfo addObject:invoiceInfo1];
        }
    }else {
        NSString* price;
        if(no_of_count.count == 0)
        {
            price = @"0";
        }else{
            int b=0,c=0;
            for (int i=0; i<no_of_count.count; i++) {
                NSString *abc = [[no_of_count valueForKey:@"student_fee"]objectAtIndex:i];
                
                if ([abc isKindOfClass:[NSNull class]])
                {
                    abc = @" ";
                }
                int a = [abc intValue];
                
                b = a;
                c=c+b;
            }
            
            price=[NSString stringWithFormat:@"%d",c];
  
        }
        
        
      for (int i=0; i<array.count; i++){
            NSString *Fee = [NSString stringWithFormat:@"$ %@/hr",price];
            NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", [array objectAtIndex:i],Fee, nil];
                [allInfo addObject:invoiceInfo1];
        }
    }
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        
        NSMutableArray* infoToDraw = [allInfo objectAtIndex:i];
        if (i>0) {
            int a = i;
            NSArray *arr;
            if(process ==1)
            {
                arr= [NSArray arrayWithObjects:[infoToDraw objectAtIndex:0],[infoToDraw objectAtIndex:1],[infoToDraw objectAtIndex:2],[infoToDraw objectAtIndex:3],[infoToDraw objectAtIndex:4], nil];

            }else{
            arr= [NSArray arrayWithObjects:[infoToDraw objectAtIndex:0],[infoToDraw objectAtIndex:1],[infoToDraw objectAtIndex:2], nil];
            }
            infoToDraw = [[NSMutableArray alloc]init];
            NSString *abc = [NSString stringWithFormat:@"%d",a];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults]setObject:abc forKey:@"thread"];
            [infoToDraw addObject:[user valueForKey:@"thread"]];
            
            if(process==1)
            {
                [infoToDraw addObject:[arr objectAtIndex:1]];
                [infoToDraw addObject:[arr objectAtIndex:2]];
                [infoToDraw addObject:[arr objectAtIndex:3]];
                [infoToDraw addObject:[arr objectAtIndex:4]];
            }else{
            [infoToDraw addObject:[arr objectAtIndex:1]];
            [infoToDraw addObject:[arr objectAtIndex:2]];
            }
        }
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            CGRect frame;
            if(process==1)
            {
                if(j==0)
                {
                    frame = CGRectMake(newOriginX+10, newOriginY, columnWidth, rowHeight);
                }else if(j==1)
                {
                    frame = CGRectMake(newOriginX-30, newOriginY, columnWidth, rowHeight);
                }else if(j==2)
                {
                    frame = CGRectMake(newOriginX +10, newOriginY, columnWidth, rowHeight);
                }else if(j==3)
                {
                    frame = CGRectMake(newOriginX +10, newOriginY, columnWidth, rowHeight);
                }else if(j==4)
                {
                    frame = CGRectMake(newOriginX +10, newOriginY, columnWidth, rowHeight);
                }
                
                if([[infoToDraw objectAtIndex:j] isEqualToString:@"S. No."])
                {
                    frame = CGRectMake(newOriginX, newOriginY, columnWidth, rowHeight);
                }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Student Name"])
                {
                    frame = CGRectMake(newOriginX-35, newOriginY, columnWidth, rowHeight);
                }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Student ID"])
                {
                    frame = CGRectMake(newOriginX-5, newOriginY, columnWidth, rowHeight);
                }

            }else {
                if(j==0)
                {
                    frame = CGRectMake(newOriginX+10, newOriginY, columnWidth, rowHeight);
                }else if(j==1)
                {
                    frame = CGRectMake(newOriginX-30, newOriginY, columnWidth, rowHeight);
                }else if(j==2)
                {
                    frame = CGRectMake(newOriginX +10, newOriginY, columnWidth, rowHeight);
                }
                
                if([[infoToDraw objectAtIndex:j] isEqualToString:@"S. No."])
                {
                    frame = CGRectMake(newOriginX, newOriginY, columnWidth, rowHeight);
                }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"Session Date"])
                {
                    frame = CGRectMake(newOriginX-35, newOriginY, columnWidth, rowHeight);
                }else if([[infoToDraw objectAtIndex:j] isEqualToString:@"/hr"])
                {
                    frame = CGRectMake(newOriginX+15, newOriginY, columnWidth, rowHeight);
                }
            }
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
        }
    }
}
NSInteger stringToInt(NSString *string) {
    return [string integerValue];
}
+(void)drawLabels
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"PDFViewController" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
            [self drawText:label.text inFrame:label.frame];
        }
    }
}
- (IBAction)backBTN:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sharePdf:(id)sender {
    
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
    if(process!=1)
    {   for (int i=0; i<3; i++) {
            [self drawLineFromPoint:from toPoint:to];
        }
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
        if(process ==1)
        {
            if(i==1)
            {
                newOrigin = origin.x + (columnWidth*i)-57;
            }else if(i==0){
                newOrigin = origin.x + (columnWidth*i);
            }else if(i==2){
                newOrigin = origin.x + (columnWidth*i)-27;
            }else if(i==3){
                newOrigin = origin.x + (columnWidth*i)-10;
            }else if(i==4){
                newOrigin = origin.x + (columnWidth*i);
            }else if(i==5){
                newOrigin = origin.x + (columnWidth*i);
            }
        }else{
            if(i==1)
            {
                newOrigin = origin.x + (columnWidth*i)-57;
            }else if(i==0){
                newOrigin = origin.x + (columnWidth*i);
            }else if(i==2){
                newOrigin = origin.x + (columnWidth*i)-27;
            }else if(i==3){
                newOrigin = origin.x + (columnWidth*i);
            }
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
   // NSMutableArray *sharingItems = [NSMutableArray new];
    
    NSData * pdfData = [NSData dataWithContentsOfFile:text];
    //NSData *pdfData = [NSData dataWithContentsOfFile:pdfFilePath];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Report", pdfData] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
