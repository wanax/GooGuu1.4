//
//  CompanyListViewController.h
//  welcom_demo_1
//
//  股票添加列表
//
//  Created by Xcode on 13-5-9.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-09 | Wanax | 股票添加列表
//  2013-08-05 | Wanax | 估值模型页面

#import <UIKit/UIKit.h>

@interface CompanyListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property MarketType type;
@property (nonatomic,retain) NSString *comType;

@property (nonatomic,retain) NSMutableArray *comList;
@property (nonatomic,retain) NSMutableArray *attentionCodes;

@property (nonatomic, retain) UITableView *comsTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;


@end
