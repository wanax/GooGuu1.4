//
//  GooNewsViewController.h
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-14 | Wanax | 估股新闻栏目

#import <UIKit/UIKit.h>

@interface GGReportListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,NSLayoutManagerDelegate>

@property (nonatomic,retain) NSMutableArray *arrList;
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,retain) id companyInfo;

@property (nonatomic,retain) UITableView *customTableView;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
