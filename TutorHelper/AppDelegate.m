//
//  AppDelegate.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AppDelegate.h"
#import "SlashScreen.h"
#import "LessonRequestViewController.h"
#import "MyLessonsViewController.h"
#import "CancelRequestsViewController.h"
#import "ConnectionListViewController.h"
#import "StudentRequestViewController.h"
#import "MyStudentsListViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    
    application.applicationIconBadgeNumber = 0;

    [self createCopyOfDatabaseIfNeeded];
    
    
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"UDID"];
    [[NSUserDefaults standardUserDefaults]setValue:deviceUDID forKey:@"UDID"];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
        
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
#endif
    
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //UINavigationController *nav;
    SlashScreen *splashVc;
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"parentDetailDict"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstTime"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            splashVc=[[SlashScreen alloc]initWithNibName:@"SlashScreen" bundle:[NSBundle mainBundle]];
        }
        else
        {
            splashVc=[[SlashScreen alloc]initWithNibName:@"SlashScreen" bundle:[NSBundle mainBundle]];
        }
    }
   nav.interactivePopGestureRecognizer.enabled = NO;

    nav=[[UINavigationController alloc]initWithRootViewController:splashVc];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
   
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [kappDelegate HideIndicator];
    NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
  
    nav = (UINavigationController *)self.window.rootViewController;

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"role"]isEqualToString:@"tutor"])
    {
        trigger=@"Tutor";
        
        if ([messageStr rangeOfString:@"requested a lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=1;
            [alert show];
            
            NSLog(@"lesson request");
        }
        else if ([messageStr rangeOfString:@"Accepted the request for lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=2;
            [alert show];
            
            NSLog(@"approved lesson");
            
        }
        else if ([messageStr rangeOfString:@"Rejected the request for lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"reject lesson");
        }
        else if ([messageStr rangeOfString:@"connection request has been approved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"approved connection request");
            
        }
        else if ([messageStr rangeOfString:@"connection request rejected" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"reject connection rejected");
            
        }
        else if ([messageStr rangeOfString:@"connection request" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"connection request");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([messageStr rangeOfString:@"have been added to your account" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"student request");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([messageStr rangeOfString:@"have been Approved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"student request Approved");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([messageStr rangeOfString:@"have been Rejected" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"student request Rejected");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([messageStr rangeOfString:@"have cancelled the request for lesson on" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            
            NSLog(@"have cancelled the request for lesson");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=3;
            [alert show];
        }
        
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"role"]isEqualToString:@"parent"])
    {
        trigger=@"Parent";

        if ([messageStr rangeOfString:@"requested to give a lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=4;
            [alert show];
            
            NSLog(@"lesson request");
        }
        else if ([messageStr rangeOfString:@"Accepted the request for lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=5;
            [alert show];
          
            NSLog(@"approved lesson");
        }
        else if ([messageStr rangeOfString:@"Rejected the request for lesson" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"reject lesson");
        }
        else if ([messageStr rangeOfString:@"connection request has been approved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"approved connection request");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([messageStr rangeOfString:@"connection request Rejected" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"reject connection rejected");
        }
        else if ([messageStr rangeOfString:@"connection request" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=6;
            
            [alert show];
            
       
            
            NSLog(@"connection request");
        }
        else if ([messageStr rangeOfString:@"have been added to your account" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=7;
            [alert show];
          
            NSLog(@"student request");
        }
        else if ([messageStr rangeOfString:@"have been Approved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=8;
            [alert show];
            NSLog(@"student request Approved");
        }
        else if ([messageStr rangeOfString:@"have been Rejected" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"student request Rejected");
        }
        
        else if ([messageStr rangeOfString:@"lesson cancellation request has been approved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=5;
            [alert show];
            
            NSLog(@"student request Rejected");
        }
        else if ([messageStr rangeOfString:@"lesson cancellation request has been rejected" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"string contains bla!");
        }
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)_deviceToken
{
    NSString*deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
        NSLog(@"Device Token: %@", deviceToken);
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:@"deviceToken"];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Defined Functions

- (void)createCopyOfDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    NSLog(@"db path %@", dbPath);
    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TutorHelper.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
            NSLog(@"DB copied.");
        }
    }else {
        NSLog(@"DB exists, no need to copy.");
    }
}

#pragma mark - Show Indicator

-(void)ShowIndicator
{
 
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (IS_IPHONE_5 )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 700)];
    }
    else if (IS_IPHONE_4_OR_LESS )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    }
    else if (IS_IPHONE_6)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 700)];
    }
    else if(IS_IPHONE_6P)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 800)];
    }
    
    DisableView.backgroundColor=[UIColor blackColor];
    DisableView.alpha=0.5;
    [self.window addSubview:DisableView];
    
    activityIndicatorObject.color=[UIColor grayColor];
    [DisableView addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
}

#pragma mark - Hide Indicator

-(void)HideIndicator
{
    [activityIndicatorObject stopAnimating];
    [DisableView removeFromSuperview];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        LessonRequestViewController*NextView = [[LessonRequestViewController alloc] initWithNibName:@"LessonRequestViewController" bundle:[NSBundle mainBundle]];
        NextView.trigger=trigger;
        [nav pushViewController:NextView animated:YES];

    }
    if (alertView.tag==2)
    {
        MyLessonsViewController*NextView = [[MyLessonsViewController alloc] initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
        NextView.trigger=trigger;
        [nav pushViewController:NextView animated:YES];

    }
    if (alertView.tag==3)
    {
        CancelRequestsViewController*NextView = [[CancelRequestsViewController alloc] initWithNibName:@"CancelRequestsViewController" bundle:[NSBundle mainBundle]];
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==4)
    {
        LessonRequestViewController*NextView = [[LessonRequestViewController alloc] initWithNibName:@"LessonRequestViewController" bundle:[NSBundle mainBundle]];
        NextView.trigger=trigger;
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==5)
    {
        MyLessonsViewController*NextView = [[MyLessonsViewController alloc] initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
        NextView.trigger=trigger;
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==6)
    {
        ConnectionListViewController*NextView = [[ConnectionListViewController alloc] initWithNibName:@"ConnectionListViewController" bundle:[NSBundle mainBundle]];
        NextView.trigger=trigger;
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==7)
    {
        StudentRequestViewController*NextView = [[StudentRequestViewController alloc] initWithNibName:@"StudentRequestViewController" bundle:[NSBundle mainBundle]];
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==8)
    {
        MyStudentsListViewController*NextView = [[MyStudentsListViewController alloc] initWithNibName:@"MyStudentsListViewController" bundle:[NSBundle mainBundle]];
        [nav pushViewController:NextView animated:YES];
    }
    if (alertView.tag==9){
        
    }
}



@end
