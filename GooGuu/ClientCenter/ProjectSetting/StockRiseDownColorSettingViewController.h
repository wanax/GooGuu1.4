//
//  StockRiseDownColorSettingViewController.h
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 股票涨跌颜色设置页面 

#import <UIKit/UIKit.h>

@interface StockRiseDownColorSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *customTable;

@end
