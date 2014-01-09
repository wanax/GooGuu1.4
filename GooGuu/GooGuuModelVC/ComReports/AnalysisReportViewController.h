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

@interface AnalysisReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}
@property  BOOL nibsRegistered;
@property (nonatomic,retain) NSMutableArray *analyReportList;
@property (nonatomic,retain) UITableView *customTableView;
@property (nonatomic,retain) NSDictionary *readingMarksDic;

@end
