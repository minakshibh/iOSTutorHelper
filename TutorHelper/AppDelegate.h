//
//  AppDelegate.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIActivityIndicatorView *activityIndicatorObject;
    UIView  *DisableView;
    NSString *trigger;

    UINavigationController *nav;

}
@property (strong, nonatomic) UIWindow *window;
-(void)ShowIndicator;
-(void)HideIndicator;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
;
@end

