//
//  SplashViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SplashViewController.h"
#import "ParentLoginViewController.h"
#import "TutorRegistrationViewController.h"
#import "TutorLoginViewController.h"
#import "TutorFirstViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.navigationController.navigationBar.hidden=YES;

  //  [[NSUserDefaults standardUserDefaults] setValue:@"SettingsView" forKey:@"ViewType"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tutorRegisteration:(id)sender {
    TutorRegistrationViewController*tutorRegVc=[[TutorRegistrationViewController alloc]initWithNibName:@"TutorRegistrationViewController" bundle:[NSBundle mainBundle]];
    tutorRegVc.trigger=@"add";
    [self.navigationController pushViewController:tutorRegVc animated:YES];
}

- (IBAction)tutorLoginActionBtn:(id)sender {
    
    TutorLoginViewController*tutorLoginVc=[[TutorLoginViewController alloc]initWithNibName:@"TutorLoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:tutorLoginVc animated:YES];
}

- (IBAction)ParentLoginAvtionBtn:(id)sender {
    ParentLoginViewController*parentLoginVc=[[ParentLoginViewController alloc]initWithNibName:@"ParentLoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:parentLoginVc animated:YES];
}

@end
