//
//  GuestCommentViewController.h
//  welcom_demo_1
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-用户评论

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

#define FINGERCHANGEDISTANCE 100.0

@interface GuestCommentViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic,retain) id commentList;

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchBar *search;

@property (nonatomic) BOOL nibsRegistered;

-(void)resetSearch;
//重置搜索，即恢复到没有输入关键字的状态
-(void)handleSearchForTerm:(NSString *)searchTerm;
//处理搜索，即把不包含searchTerm的值从可变数组中删除
@end
