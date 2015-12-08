//
//  StudentList.h
//  TutorHelper
//
//  Created by Br@R on 17/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentList : NSObject
@property (strong, nonatomic) NSString *parentName,*payment,*NumberOfStudent ,*emailAddress,*ContactNum,*address,*studentId,*parentId,*gender,*fees,*isActiveInMonth;
@property (strong, nonatomic) NSArray*studentArray;
@property (strong, nonatomic) NSString *studentName,*studentEmail,*studentContact,*notes ;

@end
