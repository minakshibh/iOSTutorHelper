//
//  tutorList.h
//  TutorHelper
//
//  Created by Br@R on 23/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tutorList : NSObject
@property (strong, nonatomic) NSString*TutorId,*Name,*Email,*ContactNumber,*AlternateContact,*Address,*StudentId,*Fee,*studentCount,*notes;
@property (strong,nonatomic) NSMutableArray*tutorList,*feeDetailList,*StudentList;
@end

