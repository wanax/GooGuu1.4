//
//  ContainerViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ContainerViewController.h"
#import "GuestCommentViewController.h"
#import "IntroductionViewController.h"
#import "ModelViewController.h"
#import "AnalysisReportViewController.h"
#import "MHTabBarController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    IntroductionViewController *temp1 = [[[IntroductionViewController alloc] init] autorelease];
    self.viewController1 = temp1;
    UINavigationController *introNav=[[[UINavigationController alloc] initWithRootViewController:self.viewController1] autorelease];
    ModelViewController *temp2 = [[[ModelViewController alloc] init] autorelease];
    self.viewController2 = temp2;
    AnalysisReportViewController *temp3 = [[[AnalysisReportViewController alloc] init] autorelease];
    self.viewController3 = temp3;
    GuestCommentViewController *temp4 = [[[GuestCommentViewController alloc] init] autorelease];
    self.viewController4 = temp4;
    
    self.viewController1.title=@"公司图解";
    self.viewController2.title=@"估值模型";
    self.viewController3.title=@"公司简报";
    self.viewController4.title=@"用户评论";
    self.viewController2.browseType=self.browseType;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:self.viewController2, introNav,self.viewController3,self.viewController4, nil];
    MHTabBarController *tempMH = [[[MHTabBarController alloc] init] autorelease];
	self.tabBarController = tempMH;
    
	self.tabBarController.viewControllers = viewControllers;
    
    [self.view addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
  
    return [self.tabBarController selectedViewController].supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate{

    return self.tabBarController.selectedViewController.shouldAutorotate;
}
























@end
