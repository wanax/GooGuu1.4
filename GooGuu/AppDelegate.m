//
//  AppDelegate.m
//  GooGuu
//
//  Created by Xcode on 14-1-8.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import "MyGooguuViewController.h"
#import "FinPicKeyWordListViewController.h"
#import "GooGuuViewController.h"
#import "GooNewsViewController.h"
#import "UniverseViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initComponents];
    return YES;
}


#pragma mark -
#pragma mark BaiDu Statistics
-(void)beginBaiDuStatistics{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.logSendWifiOnly = YES;
    [statTracker startWithAppId:GetConfigure(@"FrameParamConfig", @"BaiDuStatisticsAppID", NO)];
}

#pragma mark -
#pragma mark Generate Components

-(void)initComponents{
    UITabBarItem *barItem=[[[UITabBarItem alloc] initWithTitle:@"最新简报" image:[UIImage imageNamed:@"googuuNewsBar"] tag:1] autorelease];
    UITabBarItem *barItem2=[[[UITabBarItem alloc] initWithTitle:@"我的估股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:2] autorelease];
    UITabBarItem *barItem3=[[[UITabBarItem alloc] initWithTitle:@"估值观点" image:[UIImage imageNamed:@"googuuViewBar"] tag:3] autorelease];
    UITabBarItem *barItem4=[[[UITabBarItem alloc] initWithTitle:@"金融图汇" image:[UIImage imageNamed:@"graphExchangeBar"] tag:4] autorelease];
    UITabBarItem *barItem5=[[[UITabBarItem alloc] initWithTitle:@"估值模型" image:[UIImage imageNamed:@"companyListBar"] tag:5] autorelease];
    //股票关注
    MyGooguuViewController *myGooGuu=[[[MyGooguuViewController alloc] init] autorelease];
    myGooGuu.tabBarItem=barItem2;
    UINavigationController *myGooGuuNavController=nil;
    //金融图汇
    FinPicKeyWordListViewController *picView=[[[FinPicKeyWordListViewController alloc] init] autorelease];
    picView.tabBarItem=barItem4;
    UINavigationController *picKeyWordNav=nil;
    //估值观点
    GooGuuViewController *toolsViewController=[[[GooGuuViewController alloc] init] autorelease];
    toolsViewController.tabBarItem=barItem3;
    UINavigationController *toolsNav=nil;
    //估股新闻
    GooNewsViewController *gooNewsViewController=[[[GooNewsViewController alloc] init] autorelease];
    gooNewsViewController.tabBarItem=barItem;
    UINavigationController *gooNewsNavController=nil;
    //股票列表
    UniverseViewController *universeViewController=[[[UniverseViewController alloc] init] autorelease];
    universeViewController.tabBarItem=barItem5;
    UINavigationController *universeNav=nil;
    
    myGooGuuNavController=[[[UINavigationController alloc] initWithRootViewController:myGooGuu] autorelease];
    gooNewsNavController=[[[UINavigationController alloc] initWithRootViewController:gooNewsViewController] autorelease];
    universeNav=[[[UINavigationController alloc] initWithRootViewController:universeViewController] autorelease];
    toolsNav=[[[[UINavigationController alloc] initWithRootViewController:toolsViewController] autorelease] autorelease];
    picKeyWordNav=[[[UINavigationController alloc] initWithRootViewController:picView] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:gooNewsNavController,toolsNav,universeNav,picKeyWordNav, myGooGuuNavController,nil];
    
    self.window.backgroundColor=[UIColor clearColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}


@end
