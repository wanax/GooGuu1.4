//
//  FinanceToolsViewController.h
//  UIDemo
//
//  Created by Xcode on 13-6-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-18 | Wanax | 金融工具
//  2013-08-05 | Wanax | 未使用
//  2013-10-15 | Wanax | 金融工具首页

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface FinanceToolsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *customTabel;


@end
