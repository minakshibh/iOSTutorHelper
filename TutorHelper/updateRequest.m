//
//  updateRequest.m
//  dash
//
//  Created by Krishna_Mac_1 on 6/8/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "updateRequest.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "paymentViewController.h"

@implementation updateRequest

- (NSString *)makePayment: (NSString *)parentId delegate: (id)theDelegate tutor_Id: (NSString*)tutorid payment_Mode: (NSString *)paymentMode amount: (NSString *) amount remarks:(NSString*)remarks{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    paymentModeStr = [NSString stringWithFormat:@"%@",paymentMode];
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&payment_mode=%@&amount=%@&remarks=%@",parentId,tutorid,paymentMode,amount,remarks];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/pay-fee.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    return nil;
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
    NSLog(@"responseString:%@",userDetailDict);
    NSString *message = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
    if ([message isEqualToString:@"success"]) {
        
        if ([paymentModeStr isEqualToString:@"AddCredit"]) {
            message =@"Your credits are added Successfully.";
        }else{
            message =@"Your payment is done Successfully.";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
            paymentViewController *startServiceVC = [[paymentViewController alloc]initWithNibName:@"paymentViewController" bundle:nil];
            [startServiceVC  recivedResponce];
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tutor Helper" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(NSString*)statusValue{
    return @"True";
}

//-(void )updateRequestWithImage : (NSString *)status delegate: (id)theDelegate service_id: (NSString*)service_id startPic: (NSData *)startPic endPic: (NSData *) endpic{
//    
//    
//    NSString*detailarList;
//    [kappDelegate ShowIndicator];
//    statusRecived = [NSString stringWithFormat:@"%@",status];
//    webservice=1;
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
//    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
//    NSDictionary *_params = @{@"user_id" : userId,
//                              @"status" : status,
//                              @"service_id" : @"87",
//                              };
//    
//    NSString *fileName = [NSString stringWithFormat:@"startPic%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    [manager setResponseSerializer:responseSerializer];
//    
//    // BASIC AUTH (if you need):
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    // BASIC AUTH END
//    
//    NSString *URLString = [NSString stringWithFormat:@"%@/update-request-status.php",Kwebservices];
//    
//    /// !!! only jpg, have to cover png as well
//    // image size ca. 50 KB
//    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:startPic name:@"start_pic" fileName:fileName mimeType:@"image"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success %@", responseObject);
//        [kappDelegate HideIndicator];
//        if (![responseObject isKindOfClass:[NSNull class]])
//        {
//            NSString *messageStr=[responseObject valueForKey:@"message"];
//            int result=[[responseObject valueForKey:@"result" ]intValue];
//            UIAlertView *alert;
//            if (result ==1)
//            {
//                alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }
//            else if(result==0)
//            {
//                
//                if ([statusRecived isEqualToString:@"StartService"]) {
//                    startServiceViewController *startServiceVC = [[startServiceViewController alloc]initWithNibName:@"startServiceViewController" bundle:nil];
//                    [startServiceVC  recivedResponce];
//                }
//                
//                
//            }
//        }
//        
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure %@, %@", error, operation.responseString);
//    }];
//}

@end
