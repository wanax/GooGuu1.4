//
//  ContainerViewController.h
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-11 | Wanax | 公司详细页面容器

#import <UIKit/UIKit.h>

@class ModelViewController;
@class IntroductionViewController;
@class AnalysisReportViewController;
@class GuestCommentViewController;
@class MHTabBarController;


@interface ContainerViewController : UIViewController

@property BrowseSourceType browseType;

@property (strong, nonatomic) IntroductionViewController *viewController1;
@property (strong, nonatomic) ModelViewController *viewController2;
@property (strong, nonatomic) AnalysisReportViewController *viewController3;
@property (strong, nonatomic) GuestCommentViewController *viewController4;
@property (nonatomic,retain) MHTabBarController* tabBarController;

@end
