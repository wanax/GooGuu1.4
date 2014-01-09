//
//  MyGooguuViewController.h
//  估股
//
//  Created by Xcode on 13-6-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 用户关注/保存公司列表  

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"

@class CompanyFieldViewController;
@class ComFieldViewController;
@class ClientLoginViewController;
@class CustomTableView;

@interface ConcernedViewController : UINavigationController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    __strong UIActivityIndicatorView *_activityIndicatorView;
    BOOL _showToast;
}
@property BrowseSourceType browseType;
@property (nonatomic,retain) NSString *type;
@property BOOL nibsRegistered;
@property BOOL nibsRegistered2;
@property BOOL isEditing;
@property (nonatomic,retain) ClientLoginViewController *loginViewController;
@property (nonatomic,retain) UITableView *customTableView;

@property (nonatomic,retain) CompanyFieldViewController *companyFieldViewController;

@property (nonatomic,retain) ComFieldViewController *comFieldViewController;
@property (nonatomic,strong) NSMutableArray *comInfoList;



















@end
