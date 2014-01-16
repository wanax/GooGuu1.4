//
//  CompanyPostListViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyPostListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSString *stockCode;
@property (nonatomic,retain) NSArray *postList;

@property (nonatomic,retain) UITableView *postTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
