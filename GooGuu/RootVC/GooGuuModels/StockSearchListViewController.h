//
//  StockSearchListViewController.h
//  googuu
//
//  Created by Xcode on 13-8-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface StockSearchListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>{
    BOOL _isShowSearchBar;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}

@property BOOL nibsRegistered;

@property (nonatomic,retain) id comList;

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *searchTable;













@end
