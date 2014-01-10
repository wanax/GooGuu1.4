//
//  TestViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuContainerViewController.h"
#import "MHTabBarController.h"
#import "ConcernedViewController.h"
#import "CalendarViewController.h"
#import "CommonlyMacros.h"

@interface GooGuuContainerViewController ()

@end

@implementation GooGuuContainerViewController


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
    ConcernedViewController *tempVC = [[[ConcernedViewController alloc] init] autorelease];
    self.concernedViewController = tempVC;
    self.concernedViewController.type=@"AttentionData";
    self.concernedViewController.browseType=MyConcernedType;
    
    ConcernedViewController *tempVC2 = [[[ConcernedViewController alloc] init] autorelease];
    self.saveModelViewControler = tempVC2;
    self.saveModelViewControler.type=@"SavedData";
    self.saveModelViewControler.browseType=MySavedType;
    
    CalendarViewController *tempCal = [[[CalendarViewController alloc] init] autorelease];
    self.calendarViewController = tempCal;
    self.calendarViewController.view.frame=CGRectMake(0,100,SCREEN_WIDTH,600);
    self.concernedViewController.title=@"自选股";
    self.saveModelViewControler.title=@"我的模型";
    self.calendarViewController.title=@"投资日历";

    
    
	NSArray *viewControllers = [NSArray arrayWithObjects:self.concernedViewController, self.saveModelViewControler,self.calendarViewController, nil];
    MHTabBarController *tempTab = [[[MHTabBarController alloc] init] autorelease];
	self.tabBarController = tempTab;
	self.tabBarController.viewControllers = viewControllers;
    
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    
}



-(NSUInteger)supportedInterfaceOrientations{
    //NSLog(@"%s",__FUNCTION__);
    return [self.tabBarController selectedViewController].supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate{
    //NSLog(@"%s",__FUNCTION__);
    return [self.tabBarController selectedViewController].shouldAutorotate;
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
