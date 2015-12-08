//
//  Lessons.h
//  TutorHelper
//
//  Created by Br@R on 14/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lessons : NSObject

@property (strong, nonatomic) NSString*LessonId, *TutorId, *ParentId, *ParentName, *ParentEmail, *maximumValueOfLastUpdated, *lessonTopic, *lessonDescription, *lesson_start_time, *lesson_end_time, *lesson_duration, *lesson_days, *LessonDate,*lesson_end_Date, *lesson_is_recurring, *isActive, *studentList,*lesson_created_date,*lesson_fee,*request_id,*request_status,*student_id,*studentName,*tutorName ,*no_of_students,*lesson_cancl_reason,*lesson_cancl_reqDate,*lesson_is_active;
@property(strong,nonatomic)NSArray*studentListArray;


@end
