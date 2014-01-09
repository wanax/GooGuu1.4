//
//  SettingCenterViewController.h
//  UIDemo
//
//  Created by Xcode on 13-6-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-21 | Wanax | 设置中心 

#import <UIKit/UIKit.h>

@class CustomTableView;

@interface SettingCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *customTabel;












@end
