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

@synthesize browseType;

@synthesize viewController1;
@synthesize viewController2;
@synthesize viewController3;
@synthesize viewController4;
@synthesize tabBarController;



- (void)dealloc
{
    [tabBarController release];tabBarController=nil;
    [viewController1 release];viewController1=nil;
    [viewController2 release];viewController2=nil;
    [viewController3 release];viewController3=nil;
    [viewController4 release];viewController4=nil;
    
    [super dealloc];
}


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

	// Do any additional setup after loading the view.
    viewController1 = [[IntroductionViewController alloc] init];
    UINavigationController *introNav=[[UINavigationController alloc] initWithRootViewController:viewController1];
    viewController2 = [[ModelViewController alloc] init];
    viewController3 = [[AnalysisReportViewController alloc] init];
    UINavigationController *analyNav=[[UINavigationController alloc] initWithRootViewController:viewController3];
    viewController4 = [[GuestCommentViewController alloc] init];
    
    viewController1.title=@"公司图解";
    viewController2.title=@"估值模型";
    viewController3.title=@"公司简报";
    viewController4.title=@"用户评论";
    viewController2.browseType=self.browseType;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:viewController2, introNav,viewController3,viewController4, nil];
	tabBarController = [[MHTabBarController alloc] init];
    
	tabBarController.viewControllers = viewControllers;
    
    [self.view addSubview:tabBarController.view];
    [self addChildViewController:tabBarController];
    [analyNav release];
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
