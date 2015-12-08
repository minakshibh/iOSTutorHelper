//
//  lessonDetailsOC.h
//  TutorHelper
//
//  Created by Krishna_Mac_1 on 6/16/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lessonDetailsOC : NSObject
@property (strong, nonatomic) NSString*end_date, *lesson_date, *lesson_days, *lesson_description, *lesson_duration, *lesson_end_time, *lesson_id, *lesson_is_active, *lesson_is_recurring, *lesson_schedule_status, *lesson_start_time, *lesson_topic, *lesson_tutor_id,*tutor_name,*noOfStudents;
@property (strong, nonatomic) NSMutableArray *studentArrayList;
@end
