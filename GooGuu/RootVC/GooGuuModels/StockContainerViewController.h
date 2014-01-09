//
//  StockContainerViewController.h
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-11 | Wanax | 估值模型栏目tab BUG调整页面

#import <UIKit/UIKit.h>

@class CompanyListViewController;
@class MHTabBarController;

@interface StockContainerViewController : UIViewController

@property (nonatomic,retain) CompanyListViewController *hkListViewController;
@property (nonatomic,retain) CompanyListViewController *szListViewController;
@property (nonatomic,retain) CompanyListViewController *shListViewController;
@property (nonatomic,retain) CompanyListViewController *usListViewController;
@property (nonatomic,retain) MHTabBarController *tabBarController;

@end
