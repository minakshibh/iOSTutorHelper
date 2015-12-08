//
//  DDCalendarView.h
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@protocol GetDetailCommonViewDelegate <NSObject>

@optional
- (void)ReceivedResponse ;

@end

@interface GetDetailCommonView : UIView  {
    id <GetDetailCommonViewDelegate> GetDetaildelegate;

    NSMutableData*webdata;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    int webservice;
    NSString*triggerValue, * tutorIdStr;
    


}

@property(nonatomic, assign) id <GetDetailCommonViewDelegate> GetDetaildelegate;

- (id)initWithFrame:(CGRect)frame tutorId:(NSString *)tutorId delegate:(id)theDelegate webdata:(NSMutableData*)webdata trigger:(NSString *)trigger;


@end




