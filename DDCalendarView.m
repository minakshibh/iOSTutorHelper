
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DDCalendarView.h"
#import "TutorFirstViewController.h"
TutorFirstViewController*tutorFirstViewObj;


NSMutableArray *Dayarray;

@implementation DDCalendarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate trigger:(NSString*)trigger
{
	if ((self = [super initWithFrame:frame])) {
        MonthValueFromDatabaseDict=[[NSMutableDictionary alloc] init];
        Dayarray=[[NSMutableArray alloc] init];
        
        triggerView=trigger;
       // [self getDateListFromDatabase];
        NSString *userId;
        if (![trigger isEqualToString:@"Parent"])
        {
            userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        }else{
            userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"]];
        }
        [self getDateListFromDatabase:userId];
        
            
//        
//        [Dayarray addObject:@"13-10-2015"];
//        [Dayarray addObject:@"15-11-2015"];
//        [Dayarray addObject:@"12-04-2015"];
//        [Dayarray addObject:@"10-04-2015"];

        heartRecordArray=[[NSMutableArray alloc] init];
        
        [self getHeartRecords];
        
        coountDaysNextMonth=0;
        
		self.delegate = theDelegate;
		
		//Initialise vars
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
        loweBarWidth=calendarWidth/4.0f;
        
		
		//View properties
        UIColor *bgPatternImage= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
            
        
		self.backgroundColor = bgPatternImage;
		[bgPatternImage release];
		
		//Set up the calendar header
		UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[prevBtn setImage:[UIImage imageNamed:@"calendar-left-arrow.png"] forState:UIControlStateNormal];
        prevBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
            
        
		[prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[nextBtn setImage:[UIImage imageNamed:@"calendar-right-arrow.png"] forState:UIControlStateNormal];
      
        nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 0, cellWidth, cellHeight);
        
		[nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect monthLabelFrame = CGRectMake(cellWidth, 0, calendarWidth - 2*cellWidth, cellHeight);
        
        CGRect backLabelFrame;

        backLabelFrame = CGRectMake(0, 0, calendarWidth , cellHeight);

        
        UILabel*backLbl=[[UILabel alloc] initWithFrame:backLabelFrame];
        backLbl.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];

		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		//monthLabel.font = [UIFont fontWithName:calendarFontName size:20];
        // monthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = [UIColor whiteColor];
        
        // SETTING CUSTOM FONTS //
        UIFont *font= [UIFont fontWithName:@"mvboli" size:21];
        monthLabel.font=font;
        
     //   monthLabel.shadowColor = [UIColor blackColor];
        //   monthLabel.shadowOffset = CGSizeMake(1, 1);
        ////
        
	       float xOfLabel=0;
        UIImageView *oneLessonImage;
        
        
        UILabel*lowerBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,calendarHeight, calendarWidth , cellHeight)];
        lowerBarLabel.backgroundColor = [UIColor whiteColor];
        lowerBarLabel.textColor = [UIColor redColor];
        NSLog(@"frame.origin.x : %f",frame.origin.x);
        if ([trigger isEqualToString:@"Parent"])
        {
            oneLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(2,calendarHeight+12,13,13)];
        }
        else{
            oneLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(2,calendarHeight+7,13,13)];
        }
        

        UILabel*oneLessnLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight, loweBarWidth , cellHeight)];
        oneLessnLabel.textAlignment = NSTextAlignmentCenter;
        
        xOfLabel=xOfLabel+loweBarWidth;
        UIImageView *twoLessonImage ;
        
        if ([trigger isEqualToString:@"Parent"])
        {
            twoLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight+12,13,13)];        }
        else{
            twoLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight+7,13,13)];        }


        UILabel*twoLessnLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight, loweBarWidth , cellHeight)];
        twoLessnLabel.textAlignment = NSTextAlignmentCenter;
        xOfLabel=xOfLabel+loweBarWidth;

        UILabel*threeLessnLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight, loweBarWidth , cellHeight)];
        
        threeLessnLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *threeLessonImage;
        if ([trigger isEqualToString:@"Parent"])
        {
            threeLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight+12,13,13)];
        }
        else{
            threeLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight+7,13,13)];
        }
        
        xOfLabel=xOfLabel+loweBarWidth;
        
        UIImageView *fourLessonImage;
        if ([trigger isEqualToString:@"Parent"])
        {
            fourLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel-5,calendarHeight+12,13,13)];
        }
        else{
            fourLessonImage =[[UIImageView alloc] initWithFrame:CGRectMake(xOfLabel-7,calendarHeight+7,13,13)];
        }
        
        UILabel*fourLessnLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel,calendarHeight, loweBarWidth , cellHeight)];
        fourLessnLabel.textAlignment = NSTextAlignmentCenter;
        
        UIFont *labelfont= [UIFont fontWithName:@"Helvetica-Bold" size:9];
        oneLessnLabel.font=labelfont;
        twoLessnLabel.font=labelfont;
        threeLessnLabel.font=labelfont;
        fourLessnLabel.font=labelfont;
        
        oneLessnLabel.text=@"1 Lessons";
        twoLessnLabel.text=@"2 Lessons";
        threeLessnLabel.text=@"3 Lessons";
        fourLessnLabel.text=@">=4 Lessons";

        oneLessonImage.image=[UIImage imageNamed:@"circle_1.png"];
        twoLessonImage.image=[UIImage imageNamed:@"circle_2.png"];
        threeLessonImage.image=[UIImage imageNamed:@"circle_3.png"];
        fourLessonImage.image=[UIImage imageNamed:@"circle_4.png"];
  
        
//        [oneLessnLabel setTextColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
//        [twoLessnLabel setTextColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
//        [threeLessnLabel setTextColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
//        [fourLessnLabel setTextColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
        
        
        [oneLessnLabel setTextColor:[UIColor blackColor]];
        [twoLessnLabel setTextColor:[UIColor blackColor]];
        [threeLessnLabel setTextColor:[UIColor blackColor]];
        [fourLessnLabel setTextColor:[UIColor blackColor]];


		//Add the calendar header to view
        [self addSubview:backLbl];
		[self addSubview: prevBtn];
		[self addSubview: nextBtn];
		[self addSubview: monthLabel];
		[self addSubview:lowerBarLabel];
        [self addSubview:oneLessnLabel];
        [self addSubview:twoLessnLabel];
        [self addSubview:threeLessnLabel];
        [self addSubview:fourLessnLabel];
        [self addSubview:oneLessonImage];
        [self addSubview:twoLessonImage];
        [self addSubview:threeLessonImage];
        [self addSubview:fourLessonImage];
        
        
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight, cellWidth-6, cellHeight);
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
            
            // SETTING CUSTOM FONTS //
          //  UIFont *font= [UIFont fontWithName:@"mvboli" size:8];
           // dayLabel.font=[UIFont fontWithName:@"mvboli" size:8];
            
            dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
            [dayLabel setTextColor:[UIColor darkGrayColor]];

			[self addSubview:dayLabel];
			[dayLabel release];
		}
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
        [self getdataFromSqlite];
        
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
    }
    return self;
}

- (void)drawDayButtons
{
    int getCount;
	dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
	for (int i = 0; i < 6; i++)
    {
		for(int j = 0; j < 7; j++) {
             if (![triggerView isEqualToString:@"Parent"])
             {
             }
			CGRect buttonFrame ;
            if (![triggerView isEqualToString:@"Parent"])
            {
                if (IS_IPHONE_4_OR_LESS)
                {
                    buttonFrame = CGRectMake(j*cellWidth+5, (i+2)*cellHeight-1, cellWidth-15, cellHeight-1);

                }
                else if (IS_IPHONE_5)
                {
                    buttonFrame = CGRectMake(j*cellWidth+5, (i+2)*cellHeight-1, cellWidth-15, cellHeight-1);
 
                }
                else if (IS_IPHONE_6)
                {
                    buttonFrame = CGRectMake(j*cellWidth+5, (i+2)*cellHeight-1, cellWidth-14, cellHeight);

                }
                else{
                    buttonFrame = CGRectMake(j*cellWidth+7, (i+2)*cellHeight-1, cellWidth-17, cellHeight);

                }

                
            }
            else{
                 buttonFrame = CGRectMake(j*cellWidth+3, (i+2)*cellHeight-10, cellWidth-10, cellHeight-7);
            }
            
			DayButton *dayButton = [[DayButton alloc] buttonWithFrame:buttonFrame];
			dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:13];
            dayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
			dayButton.delegate = self;
            getCount=[dayButtons count];
            
			[dayButtons addObject:dayButton];
			[self addSubview:[dayButtons lastObject]];
		}
	}
}


- (void)updateCalendarForMonth:(int)month forYear:(int)year {
    [self  getDateListFromDatabase:[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"]];
    char *months[12] = {"January", "Febrary", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
    monthLabel.text = [NSString stringWithFormat:@"%s %d", months[month - 1], year];
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    [dateParts release];
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    int weekdayOfFirst = [weekdayComponents weekday];
    
    //Map first day of month to a week starting on Monday
    //as the weekday component defaults to 1->Sun, 2->Mon...
    if(weekdayOfFirst == 1) {
        weekdayOfFirst = 7;
    } else {
        --weekdayOfFirst;
    }
    
    int numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"dd"];
   
    int monthStr = [[formatter stringFromDate:[NSDate date]]intValue];
    int yearStr = [[formatter1 stringFromDate:[NSDate date]]intValue];
    int dateStr = [[formatter2 stringFromDate:[NSDate date]]intValue];

    int day = 1;
    for (int i = 0; i < 6; i++) {
        for(int j = 0; j < 7; j++) {
            int buttonNumber = i * 7 + j;
            
            DayButton *button = [dayButtons objectAtIndex:buttonNumber];
            [button setBackgroundImage:nil forState:UIControlStateNormal];

            button.enabled = NO; //Disable buttons by default
            [button setTitle:nil forState:UIControlStateNormal]; //Set title label text to nil by default
            [button setButtonDate:nil];
            
            if(buttonNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                [button setTitle:[NSString stringWithFormat:@"%d", day]
                        forState:UIControlStateNormal];
                
               // button.titleEdgeInsets = UIEdgeInsetsMake(200, 15, 0, 0);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                
                NSDateComponents *dateParts = [[NSDateComponents alloc] init];
                [dateParts setMonth:month];
                [dateParts setYear:year];
                [dateParts setDay:day];
                NSDate *buttonDate = [calendar dateFromComponents:dateParts];
                [dateParts release];
                if (year ==yearStr && month==monthStr && day== dateStr)
                {
//                    [button setBackgroundImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }

                for (int j=0; j<Dayarray.count; j++)
                {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *selectedDate = [[NSDate alloc] init];
                    
                    NSDictionary*dateDict=[Dayarray  objectAtIndex:j ];
                    NSString*dateString=[dateDict  valueForKey:@"lessonDate"];
                    
                   // NSDictionary*dateDict= [self getDateDetailFromDatabase:dateString];
                    
                    NSString*lessonsStr=[dateDict valueForKey:@"lessons"];
                    
                    NSString*halfDayStr=[dateDict valueForKey:@"halfDay"];
                    
                    NSString*fulldayStr=[dateDict valueForKey:@"fullday"];
                    
                    selectedDate=[dateFormatter dateFromString:dateString];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setDateFormat:@"MM"];
                    
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    
                    [formatter1 setDateFormat:@"yyyy"];
                    
                    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                    
                    [formatter2 setDateFormat:@"dd"];
                    
                    int yearValue = [[formatter1 stringFromDate:selectedDate]intValue];
                    
                    int monthValue = [[formatter stringFromDate:selectedDate]intValue];
                    
                    int dateValue = [[formatter2 stringFromDate:selectedDate]intValue];
                    
                    
                    
                    if (year ==yearValue && month==monthValue && day== dateValue)
                        
                    {
                        if ([lessonsStr intValue]==1)
                        {
                            if ([halfDayStr isEqualToString:@"TRUE"] ||[halfDayStr isEqualToString:@"true"]) {
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_1_half.png"] forState:UIControlStateNormal];
                            }
                            else if ([fulldayStr isEqualToString:@"TRUE"]||[fulldayStr isEqualToString:@"true"]){
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_1_full.png"] forState:UIControlStateNormal];
                            }
                            else{
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                            }
   
                        }
                        
                        else if ([lessonsStr intValue]==2)
                        {
                            if ([halfDayStr isEqualToString:@"TRUE"]||[halfDayStr isEqualToString:@"true"]) {
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_2_half.png"] forState:UIControlStateNormal];
                            }
                            else if ([fulldayStr isEqualToString:@"TRUE"]||[fulldayStr isEqualToString:@"true"]){
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_2_full.png"] forState:UIControlStateNormal];
                            }
                            else{
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                            }
                        }
                        else if ([lessonsStr intValue]==3)
                        {
                            if ([halfDayStr isEqualToString:@"TRUE"]||[halfDayStr isEqualToString:@"true"]) {
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_3_half.png"] forState:UIControlStateNormal];
                            }
                            else if ([fulldayStr isEqualToString:@"TRUE"]||[fulldayStr isEqualToString:@"true"]){
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_3_full.png"] forState:UIControlStateNormal];
                            }
                            else{
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_3.png"] forState:UIControlStateNormal];
                            }
                        }
                        else
                        {
                            if ([halfDayStr isEqualToString:@"TRUE"] || [halfDayStr isEqualToString:@"true"]) {
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_4_half.png"] forState:UIControlStateNormal];
                            }
                           else if ([fulldayStr isEqualToString:@"TRUE"]||[fulldayStr isEqualToString:@"true"]){
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_4_full.png"] forState:UIControlStateNormal];
                            }
                            else{
                                [button setBackgroundImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
                            }
                        }
                    }
                }
                
                [button setButtonDate:buttonDate];
                button.enabled = YES;
                ++day;
            }
        }
    }
}


- (void)prevBtnPressed:(id)sender {
    if(currentMonth == 1) {
        currentMonth = 12;
        --currentYear;
    } else {
        --currentMonth;
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    
    if ([self.delegate respondsToSelector:@selector(prevButtonPressed)]) {
        [self.delegate prevButtonPressed];
    }
}

- (void)nextBtnPressed:(id)sender {
    if(currentMonth == 12) {
        currentMonth = 1;
        ++currentYear;
    }else
    {
        ++currentMonth;
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    
    if ([self.delegate respondsToSelector:@selector(nextButtonPressed)]) {
        [self.delegate nextButtonPressed];
    }
}




- (void)dayButtonPressed:(id)sender
{
	DayButton *dayButton = (DayButton *) sender;
	[self.delegate dayButtonPressed:dayButton];
    
}

#pragma mark - Get Data from database to show in textfilds

-(void)getdataFromSqlite
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM PeriodsDetails";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            [PeriodsDetailsDict removeAllObjects];
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                // [PeriodsDetailsArray addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"date"];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 2)] forKey:@"AvgPeriodDuration"];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 3)] forKey:@"AvgPeriodCycle"];
//                
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}
#pragma mark - Update Date, Perioda duration, Cycles to database

-(void)UpdateRecordsToDataBase
{
//    sqlite3_stmt *updateStmt=nil;
//    NSString *docsDir;
//    NSArray *dirPaths;
//    
//    // Get the documents directory
//    dirPaths = NSSearchPathForDirectoriesInDomains(
//                                                   NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];
//    _databasePath = [[NSString alloc]
//                     initWithString: [docsDir stringByAppendingPathComponent:
//                                      @"PeriodsTracker.db"]];
//    const char *dbpath = [_databasePath UTF8String];
//    if(sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
//    {
//        const char *sql = "update MonthTable Set month = ?,year = ? Where id=1";
//        if(sqlite3_prepare_v2(_contactDB, sql, -1, &updateStmt, NULL)==SQLITE_OK)
//        {
//            sqlite3_bind_text(updateStmt, 1, [[NSString stringWithFormat:@"%ld",(long)currentMonth] UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(updateStmt, 2, [[NSString stringWithFormat:@"%ld",(long)currentYear] UTF8String], -1, SQLITE_TRANSIENT);
//            
//        }
//    }
//    char* errmsg;
//    sqlite3_exec(_contactDB, "COMMIT", NULL, NULL, &errmsg);
//    
//    if(SQLITE_DONE != sqlite3_step(updateStmt)){
//       // NSLog(@"Error while updating. %s", sqlite3_errmsg(_contactDB));
//    }
//    else
//    {
//        
//    }
//    sqlite3_finalize(updateStmt);
//    sqlite3_close(_contactDB);
    
}
#pragma mark - Get Month Value

-(void)GetMonthValue
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM MonthTable";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                [MonthValueFromDatabaseDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"month"];
//                [MonthValueFromDatabaseDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 2)] forKey:@"year"];
//                
//                
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}

#pragma mark - Get Ovolution days form database

-(void)getOvolutionDays
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM Ovolution";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            [OvolutionDict removeAllObjects];
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                // [PeriodsDetailsArray addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];
//                [OvolutionDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"days"];
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}


#pragma mark - Get Heart Records From Database

-(void)getHeartRecords
{

}
#pragma mark - Touch view delegates
-(void )getDateListFromDatabase:(NSString*) userId{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    documentsDir = [docPaths objectAtIndex:0];
    
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
    
    
    
    

  //  NSString *queryString = [NSString stringWithFormat:@"Select * FROM LessonList "];
     NSString *queryString = [NSString stringWithFormat:@"Select * FROM LessonList where userId=\"%@\"",userId];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    NSDictionary*dict=[[NSDictionary alloc]init];
    
    while([results next])
        
    {
        NSString*lessonsStr=[results stringForColumn:@"NumberOfLessons"];
        
        NSString*halfDayStr=[results stringForColumn:@"halfdayBlockOut"];
        
        NSString*fulldayStr=[results stringForColumn:@"fulldayBlockOut"];
        
        NSString*date=[results stringForColumn:@"lessonDate"];
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:lessonsStr,@"lessons",halfDayStr,@"halfDay",fulldayStr,@"fullday", date,@"lessonDate",nil];

        [Dayarray addObject:dict];
    }
    
    [database close];
    
}




- (void)dealloc {
	[calendar release];
	[dayButtons release];
    [super dealloc];
}


@end
