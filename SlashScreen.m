//
//  SlashScreen.m
//  TutorHelper
//
//  Created by Br@R on 24/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SlashScreen.h"
#import "InstructionsViewController.h"
#import "SplashViewController.h"
#import "TutorFirstViewController.h"
#import "ParentDashboardViewController.h"

@interface SlashScreen ()

@end

@implementation SlashScreen

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.navigationController.navigationBar.hidden=YES;

    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentnextView
{
    NSString *defaults=[[NSUserDefaults standardUserDefaults ]valueForKey:@"firstTime"];
    
    if ([defaults isEqualToString:@"1"])
    {
        NSString*tutor_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"tutor_id"]];
         NSString*parent_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"pin"]];
        
        
        if (![tutor_id isEqualToString:@"(null)"])
        {
            if (tutor_id.length!=0 )
            {
                View=@"Tutor";
                getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:tutor_id delegate:self webdata:webData trigger:View];
                [self.view addSubview: getDetailView];
                
            }
            else {
                [self moveToSplashView];
            }
        }
        else if (![parent_id isEqualToString:@"(null)"])
        {
            if (parent_id.length!=0 )
            {
                View=@"Parent";
                getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:parent_id delegate:self webdata:webData trigger:@"Parent"];
                [self.view addSubview: getDetailView];

             
                
            }
            else {
                [self moveToSplashView];
            }
        }
        else
        {
            [self moveToSplashView];
        }

    }
    else{
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        InstructionsViewController *instructionsVc;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            CGSize result1 = [[UIScreen mainScreen] bounds].size;
            if(result1.height == 480)
            {
                instructionsVc=[[InstructionsViewController alloc]initWithNibName:@"InstructionsViewController" bundle:[NSBundle mainBundle]];
            }
            else
            {
                instructionsVc=[[InstructionsViewController alloc]initWithNibName:@"InstructionsViewController" bundle:[NSBundle mainBundle]];
            }
        }
        [self.navigationController pushViewController:instructionsVc animated:YES];
    }
}


- (void)ReceivedResponse
{
    
    if ([View isEqualToString:@"Parent"])
    {
        ParentDashboardViewController*ParentDashboardViewc=[[ParentDashboardViewController alloc]initWithNibName:@"ParentDashboardViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:ParentDashboardViewc animated:YES];
    }

    else{
        TutorFirstViewController *tutorFirstVc=[[TutorFirstViewController alloc]initWithNibName:@"TutorFirstViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:tutorFirstVc animated:YES];

    }
    
    
}

-(void )moveToSplashView
{
    SplashViewController *splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:splashVc animated:YES];
    
}

@end
