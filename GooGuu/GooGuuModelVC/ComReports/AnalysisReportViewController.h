//
//  AnalysisReportViewController.h
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票分析

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class CustomTableView;

@interface AnalysisReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSLayoutManagerDelegate>

@property  BOOL nibsRegistered;
@property (nonatomic,retain) id companyInfo;
@property (nonatomic,retain) NSMutableArray *analyReports;
@property (nonatomic,retain) UITableView *reportTable;

@end
