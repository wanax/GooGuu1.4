//
//  StockContainerViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "StockContainerViewController.h"
#import "MHTabBarController.h"
#import "CompanyListViewController.h"
#import "CommonlyMacros.h"

@interface StockContainerViewController ()

@end

@implementation StockContainerViewController


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
    
    CompanyListViewController *temp1 = [[[CompanyListViewController alloc] init] autorelease];
    self.hkListViewController = temp1;
    CompanyListViewController *temp2 = [[[CompanyListViewController alloc] init] autorelease];
    self.usListViewController = temp2;
    CompanyListViewController *temp3 = [[[CompanyListViewController alloc] init] autorelease];
    self.szListViewController = temp3;
    //CompanyListViewController *temp4 = [[[CompanyListViewController alloc] init] autorelease];
    //self.shListViewController = temp4;

    self.hkListViewController.comType=@"港股";
    self.usListViewController.comType=@"美股";
    self.szListViewController.comType=@"A股";
    //self.shListViewController.comType=@"沪市";
    
    self.hkListViewController.title=@"港股";
    self.usListViewController.title=@"美股";
    self.szListViewController.title=@"A股";
    //self.shListViewController.title=@"沪市";
    
    self.hkListViewController.type=HK;
    self.usListViewController.type=NANY;
    self.szListViewController.type=SHSZSE;
    //self.shListViewController.type=SHSE;
    
    self.hkListViewController.isSearchList=NO;
    self.usListViewController.isSearchList=NO;
    self.szListViewController.isSearchList=NO;
    //self.shListViewController.isSearchList=NO;
  
	NSArray *viewControllers = [NSArray arrayWithObjects:self.hkListViewController, self.usListViewController,self.szListViewController,self.shListViewController, nil];
    MHTabBarController *tempMh = [[[MHTabBarController alloc] init] autorelease];
	self.tabBarController = tempMh;
    
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

    return [[self.tabBarController selectedViewController] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [[self.tabBarController selectedViewController] shouldAutorotate];
}

















@end
