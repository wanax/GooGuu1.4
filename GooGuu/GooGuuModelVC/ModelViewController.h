//
//  ModelViewController.h
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票模型

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class ChartViewController;
@class DiscountRateViewController;
@class MHTabBarController;

@interface ModelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITextFieldDelegate>{

    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
    int _count;
}


@property (nonatomic,retain) id jsonForChart;
@property (nonatomic,retain) id comInfo;
@property BrowseSourceType browseType;
@property (nonatomic,retain) id savedStockList;
@property BOOL isAttention;

@property (nonatomic,retain) UITapGestureRecognizer *tapHide;

@property (nonatomic,retain) UITextField *inputField;
@property (nonatomic,retain) UIButton *attentionBt;
@property (nonatomic,retain) DiscountRateViewController *disViewController;
@property (nonatomic,retain) ChartViewController *chartViewController;
@property (nonatomic,retain) UITableView *savedTable;
@property (nonatomic,retain) MHTabBarController *tabController;

@end
