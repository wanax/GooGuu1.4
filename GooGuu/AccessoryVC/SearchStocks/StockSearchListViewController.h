//
//  StockSearchListViewController.h
//  googuu
//
//  Created by Xcode on 13-8-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockSearchListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>

@property BOOL nibsRegistered;

@property (nonatomic,retain) id comList;

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *searchTable;













@end
