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

@synthesize hkListViewController;
@synthesize szListViewController;
@synthesize usListViewController;
@synthesize shListViewController;
@synthesize tabBarController;

- (void)dealloc
{
    SAFE_RELEASE(tabBarController);
    SAFE_RELEASE(hkListViewController);
    SAFE_RELEASE(szListViewController);
    SAFE_RELEASE(shListViewController);
    SAFE_RELEASE(usListViewController);
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
    
    hkListViewController = [[CompanyListViewController alloc] init];
    usListViewController = [[CompanyListViewController alloc] init];
    szListViewController = [[CompanyListViewController alloc] init];
    shListViewController = [[CompanyListViewController alloc] init];

    hkListViewController.comType=@"港股";
    usListViewController.comType=@"美股";
    szListViewController.comType=@"深市";
    shListViewController.comType=@"沪市";
    
    hkListViewController.title=@"港股";
    usListViewController.title=@"美股";
    szListViewController.title=@"深市";
    shListViewController.title=@"沪市";
    
    hkListViewController.type=HK;
    usListViewController.type=NANY;
    szListViewController.type=SZSE;
    shListViewController.type=SHSE;
    
    hkListViewController.isSearchList=NO;
    usListViewController.isSearchList=NO;
    szListViewController.isSearchList=NO;
    shListViewController.isSearchList=NO;
  
	NSArray *viewControllers = [NSArray arrayWithObjects:hkListViewController, usListViewController,szListViewController,shListViewController, nil];
	tabBarController = [[MHTabBarController alloc] init];
    
	tabBarController.viewControllers = viewControllers;
    
    [self.view addSubview:tabBarController.view];
    [self addChildViewController:tabBarController];
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
