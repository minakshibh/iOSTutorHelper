//
//  updateRequest.h
//  dash
//
//  Created by Krishna_Mac_1 on 6/8/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFHTTPRequestOperationManager.h"
@protocol updateRequestStatus <NSObject>

@optional
- (void)ReceivedResponse ;

@end

@interface updateRequest : NSObject
{
    id <updateRequestStatus> updateRequestdelegate;
    NSMutableData* webData;
    int webservice;
    NSString*triggerValue;
    NSString *statusRecived;
    NSString *paymentModeStr;
    
}

@property(nonatomic, assign) id <updateRequestStatus> updateRequestdelegate;

- (NSString *)makePayment: (NSString *)parentId delegate: (id)theDelegate tutor_Id: (NSString*)tutorid payment_Mode: (NSString *)paymentMode amount: (NSString *) amount remarks:(NSString*)remarks;

-(NSString *)statusValue;
@end
