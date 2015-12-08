
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GetDetailCommonView.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"



@implementation GetDetailCommonView
@synthesize GetDetaildelegate;

- (id)initWithFrame:(CGRect)frame tutorId:(NSString *)tutorId delegate:(id)theDelegate webdata:(NSMutableData *)webdata trigger:(NSString *)trigger{
    
	if ((self = [super initWithFrame:frame]))
    {
        triggerValue=trigger;
        tutorIdStr=tutorId;
        
		self.GetDetaildelegate = theDelegate;
        
        self.backgroundColor= [UIColor colorWithRed:16.0/255.0f green:22.0f/255.0f blue:38.0f/255.0f alpha:1];
   
        if ([triggerValue isEqualToString:@"Parent"])
        {
            [self registerDevice];
        }
        
        else if ([triggerValue isEqualToString:@"lessons"]) {
            [self  GetBasicDetailsService];
        }
        else if([triggerValue isEqualToString:@"Tutor"])
        {
            [self registerDevice];
        }
        else{
            [self fetchParentList];
        }
        
    }
    return self;
}


-(void)fetchParentList{
    NSString*_postData ;
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"greatest_last_updated"];
    tutorIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"last_updated_date=%@&tutor_id=%@",lastUpdatedStr,tutorIdStr ];
    }
    else{
        _postData = [NSString stringWithFormat:@"last_updated_date= &tutor_id=%@",tutorIdStr ];
    }
    
    _postData = [NSString stringWithFormat:@"last_updated_date=&tutor_id=%@",tutorIdStr ];
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    webservice=1;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-parent.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}
#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webdata =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data>>%@",data);
    webdata=[[NSMutableData alloc]initWithData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];

    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webdata length]);
    if ([webdata length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webdata encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
  
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            if (webservice==1)
            {
                NSString*lastUpdated=[userDetailDict valueForKey:@"greatest_last_updated"];
                  if (![lastUpdated isKindOfClass:[NSNull class]])
                  {
                      [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"greatest_last_updated"];
                  }
              
                NSArray*parentList=[userDetailDict valueForKey:@"parent_list"];
                [self saveDataToDataBase:parentList];
                if (![triggerValue isEqualToString:@"parentList"])
                {
                    [self GetBasicDetailsService];
                }
                else{
                      [self.GetDetaildelegate ReceivedResponse];
                }
            }
            else if (webservice==2)
            {
                
                NSString*activalessons=[userDetailDict valueForKey:@"no of active students"];
                NSString*fee_collected=[userDetailDict valueForKey:@"fee_collected"];
                NSString*fee_due=[userDetailDict valueForKey:@"fee_due"];
                NSArray*lessonList=[userDetailDict valueForKey:@"lesson_list"];
                
                if ([fee_collected isKindOfClass:[NSNull class]])
                {
                   fee_collected=@"0";
                }
                if ([fee_due isKindOfClass:[NSNull class]])
                {
                    fee_due=@"0";
                }
                
                
                
                [self saveLessonsDataTodtaaBase:activalessons :fee_collected :fee_due :lessonList ];
                [self.GetDetaildelegate ReceivedResponse];
                webservice=0;
            }
            else if (webservice==3)
            {
                NSString*greatest_last_updated =[userDetailDict valueForKey:@"greatest_last_updated"];
                
                if (![greatest_last_updated isKindOfClass:[NSNull class]])
                {
                    [[NSUserDefaults standardUserDefaults ]setValue:greatest_last_updated forKey:@"student_greatest_last_updated"];
                }
                NSArray*studentList =[userDetailDict valueForKey:@"student_list"];
                if (studentList.count>0)
                {
                    [self saveStudentDataToDataBase:studentList];
                }
             //   [self getStudentDetailFromDataBase];
                
                [self.GetDetaildelegate ReceivedResponse];

                webservice=0;
            }
            
            else if (webservice==4)
            {
                webservice=0;
                
                if ([triggerValue isEqualToString:@"Parent"])
                {
                    [self fetchStudentList];
                }
                else if ([triggerValue isEqualToString:@"Tutor"])
                {
                    [self fetchParentList];
                }
            }
        }
    }
}
-(void) saveLessonsDataTodtaaBase :(NSString*)activLesson :(NSString*)feesCollectd :(NSString*)feesDue :(NSArray*)lessonList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TutorProfile"];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *tutorIdarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [tutorIdarray addObject:[results stringForColumn:@"tutorID"]];
    }
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];

    if ([tutorIdarray containsObject:tutorId])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TutorProfile SET feesCollected = \"%@\", fees_due = \"%@\", activeLessons =\"%@\"  where tutorID =\"%@\"",feesCollectd,feesDue,activLesson,tutorId];
        [database executeUpdate:updateSQL];
    }
    else{
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO TutorProfile (tutorID, feesCollected, fees_due, activeLessons) VALUES (\"%@\", \"%@\",\"%@\",\"%@\")",tutorId,feesCollectd,feesDue,activLesson];
        [database executeUpdate:insert];
    }
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from LessonList "];
    [database executeUpdate:deleteQuery];
    NSString *deleteQuery1 = [NSString stringWithFormat:@"DELETE from LessonSlots "];
    [database executeUpdate:deleteQuery1];

    
    for (int i=0; i<lessonList.count; i++)
    {
        NSDictionary*tempDict=[lessonList objectAtIndex:i];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonList (userId, NumberOfLessons, fulldayBlockOut, halfdayBlockOut, lessonDate) VALUES(\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",tutorId,[tempDict valueForKey:@"no._of_lessons"],[tempDict valueForKey:@"block_out_time_for_fullday"],[tempDict valueForKey:@"block_out_time_for_halfday"],[tempDict valueForKey:@"lesson_date"]];
            [database executeUpdate:insert];
       NSArray *lessonSlots = [tempDict valueForKey:@"timing"];
        for (int k = 0; k < lessonSlots.count; k++) {
            NSDictionary*tempLessonSlotsDict=[lessonSlots objectAtIndex:k];
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO LessonSlots (userId,lesson_id, lesson_date, lesson_description, lesson_end_timing, lesson_start_timing) VALUES(\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",tutorId,[tempLessonSlotsDict valueForKey:@"ID"],[tempDict valueForKey:@"lesson_date"],[tempLessonSlotsDict valueForKey:@"description"],[tempLessonSlotsDict valueForKey:@"end_timing"],[tempLessonSlotsDict valueForKey:@"start_timing"]];
            [database executeUpdate:insert];
        }
       
    }
    
    [database close];
}
//-(void)calcuateAlarmTime: (NSString*)lessonDate{
//    NSDate *todaysDate;
//    todaysDate = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"YYYY-MM-dd"];
//    NSString *currentDate = [ dateFormat stringFromDate:todaysDate];
//    todaysDate = [dateFormat dateFromString:currentDate];
//    
//    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSString *timeFrom = [NSString stringWithFormat:@"%@",lessonDate];
//    NSArray* dateFromArray = [timeFrom componentsSeparatedByString: @" "];
//    NSString *dateToSelect =[NSString stringWithFormat:@"%@",[dateFromArray objectAtIndex:0]];
//    NSArray *dateComponentsArray = [dateToSelect componentsSeparatedByString:@"-"];
//    int yearValue = [[dateComponentsArray objectAtIndex:0]intValue];
//    
//    int monthValue = [[dateComponentsArray objectAtIndex:1]intValue];
//    
//    int dateValue = [[dateComponentsArray objectAtIndex:2]intValue];
//    
//    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
//    [dateParts setMonth:monthValue];
//    [dateParts setYear:yearValue];
//    [dateParts setDay:dateValue];
//    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
//    if ([todaysDate compare:dateOnFirst] == NSOrderedAscending) {
//        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//        [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *serviceTime = [dateFormat1 dateFromString:lessonDate];
//        NSString *serviceDateTime = [dateFormat1 stringFromDate:serviceTime];
//        [self scheduleNotificationForDate:serviceDateTime];
//    }
//}
//-(void) scheduleNotificationForDate: (NSString*)lessondate{
//    
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    if (localNotif == nil)
//        return;
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//        NSDate *sDate = [dateFormat dateFromString:lessondate];
//        NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ABCDEF", @"SHED_ID", nil];
//        localNotif.userInfo = userDict;
//        localNotif.fireDate = sDate;
//        localNotif.timeZone = [NSTimeZone defaultTimeZone];
//        localNotif.repeatInterval = NSWeekCalendarUnit;
//        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
//        localNotif.alertBody = @"Hello testing";
//        localNotif.soundName =UILocalNotificationDefaultSoundName;
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        NSLog(@"notification started");
//
//}
-(void) GetBasicDetailsService{
    NSString*_postData ;
    webservice=2;
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    
    if (tutorId.length>0)
    {
        _postData = [NSString stringWithFormat:@"tutor_id=%@",tutorId ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webdata==nil)
            {
                webdata = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webdata=nil;
                webdata = [NSMutableData data] ;
            }
            NSLog(@"server connection made");
        }
        else
        {
            NSLog(@"connection is NULL");
        }
    }
    else{
        [self.GetDetaildelegate ReceivedResponse];
    }
}

-(void)registerDevice
{
    NSString*_postData ;
    webservice=4;
    
    NSString*userId;
    if ([triggerValue isEqualToString:@"Parent"])
    {
        userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    }
    else
    {
        userId=tutorIdStr;
    }
    
    
    NSString*deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    NSString*UDID=[[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];

    _postData = [NSString stringWithFormat:@"trigger=ios&role=%@&reg_id=%@&user_id=%@&ud_id=%@",triggerValue,deviceToken,userId,UDID ];
        
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/insert-device.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webdata==nil)
            {
                webdata = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webdata=nil;
                webdata = [NSMutableData data] ;
            }
            NSLog(@"server connection made");
        }
        else
        {
            NSLog(@"connection is NULL");
        }
}



-(void)saveDataToDataBase :(NSArray*)parentList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE  from ParentList"];
    [database executeUpdate:deleteQuery];

    NSString *queryString = [NSString stringWithFormat:@"Select * FROM ParentList"];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *parentIdarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [parentIdarray addObject:[results stringForColumn:@"id"]];
    }
    for (int i=0; i<parentList.count; i++)
    {
        NSDictionary*tempDict=[parentList objectAtIndex:i];
        NSString*parentId=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"parent_id"]];
     
        if ([parentIdarray containsObject:parentId])
        {
            NSString*no_studns=[tempDict valueForKey:@"no._of_students"];
            NSString*oustandBlnc=[tempDict valueForKey:@"outstanding_balance"];
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            NSString*activeStudents=[tempDict valueForKey:@"no._of_active_students"];

            if ([no_studns isKindOfClass:[NSNull class]])
            {
                no_studns=@"0";
            }
            if ([oustandBlnc isKindOfClass:[NSNull class]])
            {
                oustandBlnc=@"0";
            }
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            
            if ([activeStudents isKindOfClass:[NSNull class]])
            {
                activeStudents=@"0";
            }
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ParentList SET id = \"%@\" , name = \"%@\", email = \"%@\", contactNumber =\"%@\", altrContactNumber = \"%@\" ,address = \"%@\" ,numberOfStudents=\"%@\" ,lessons=\"%@\"  ,outstandingBalance=\"%@\",notes=\"%@\" ,activeStudents =\"%@\" where id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_number"],[tempDict valueForKey:@"alt_c_number"],[tempDict valueForKey:@"address"],no_studns,[tempDict valueForKey:@"no._of_lessons"],notesStr,oustandBlnc,activeStudents,[tempDict valueForKey:@"parent_id"] ];
            [database executeUpdate:updateSQL];
        }
        else{
            
            NSString*no_studns=[tempDict valueForKey:@"no._of_students"];
            NSString*oustandBlnc=[tempDict valueForKey:@"outstanding_balance"];
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            NSString*activeStudents=[tempDict valueForKey:@"no._of_active_students"];
            NSString*lessonsNumbr=[tempDict valueForKey:@"no._of_lessons"];

            if ([no_studns isKindOfClass:[NSNull class]])
            {
                no_studns=@"0";
            }
            if ([oustandBlnc isKindOfClass:[NSNull class]])
            {
                oustandBlnc=@"0";
            }
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            if ([activeStudents isKindOfClass:[NSNull class]])
            {
                activeStudents=@"0";
            }
            if ([lessonsNumbr isKindOfClass:[NSNull class]])
            {
                lessonsNumbr=@"0";
            }


            NSString *insert = [NSString stringWithFormat:@"INSERT INTO ParentList (id, name, email, contactNumber, altrContactNumber, address,numberOfStudents,lessons,outstandingBalance,notes,activeStudents) VALUES (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_number"],[tempDict valueForKey:@"alt_c_number"],[tempDict valueForKey:@"address"],no_studns,lessonsNumbr,oustandBlnc,notesStr,activeStudents];
            
            [database executeUpdate:insert];
        }
    }
    [database close];
}


-(void)fetchStudentList{
    webservice=3;
    [kappDelegate ShowIndicator];
    
    NSString*  parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    
    
    NSString* last_updated_date=[[NSUserDefaults standardUserDefaults ]valueForKey:@"student_greatest_last_updated"];
    if (last_updated_date == nil)
    {
        last_updated_date=@"";
    }
    last_updated_date=@"";
    
   NSString* _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=-1&last_updated_date=%@",parentId,last_updated_date];
    
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-student.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }

}

-(void)saveStudentDataToDataBase :(NSArray*)studentList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString*tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from StudentList "];
    [database executeUpdate:deleteQuery];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM StudentList "];
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *student_idarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [student_idarray addObject:[results stringForColumn:@"student_id"]];
    }
    for (int i=0; i<studentList.count; i++)
    {
        NSDictionary*tempDict=[studentList objectAtIndex:i];
        NSString*student_id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"student_id"]];
        NSString*  parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];

        if ([student_idarray containsObject:student_id])
        {
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE StudentList SET parent_id = \"%@\" , name = \"%@\", email = \"%@\", contact_info =\"%@\", gender = \"%@\" ,address = \"%@\" ,fee =\"%@\", isActiveInMonth = \"%@\" ,notes=\"%@\" where student_id = %@" ,[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],notesStr,[tempDict valueForKey:@"student_id"] ];
            [database executeUpdate:updateSQL];
        }
        else{
            NSString*notesStr=[tempDict valueForKey:@"notes"];
            if ([notesStr isKindOfClass:[NSNull class]])
            {
                notesStr=@"";
            }
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO StudentList (parent_id, name, email, contact_info, gender, address,fee,isActiveInMonth,student_id,notes,TUTORID,PARENTID) VALUES (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[tempDict valueForKey:@"parent_id"],[tempDict valueForKey:@"name"],[tempDict valueForKey:@"email"],[tempDict valueForKey:@"contact_info"],[tempDict valueForKey:@"gender"],[tempDict valueForKey:@"address"],[tempDict valueForKey:@"fee"],[tempDict valueForKey:@"isActiveInMonth"],[tempDict valueForKey:@"student_id"],notesStr,tutorId,parentId];
            [database executeUpdate:insert];
        }
    }
    [database close];
}



@end





