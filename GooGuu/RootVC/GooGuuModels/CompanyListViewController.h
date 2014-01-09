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
#import "EGORefreshTableHeaderView.h"

@class ComFieldViewController;


@interface CompanyListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>{
    BOOL _isShowSearchBar;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;

}
@property MarketType type;
@property BOOL nibsRegistered;
@property (nonatomic,retain) NSString *comType;
@property (nonatomic,retain) UIImage *rowImage;

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UISearchBar *search;

@property (nonatomic,retain) NSMutableArray *comList;
@property (nonatomic) BOOL isShowSearchBar;
@property BOOL isSearchList;

@property (nonatomic,retain) NSMutableArray *concernStocksCodeArr;
@property (nonatomic,retain) ComFieldViewController *com;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;




@end
