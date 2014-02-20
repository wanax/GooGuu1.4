//
//  CommonComListVC.h
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonComListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *comTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property CompanyListType type;
//查找好友的关注组合时需要用户名
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSString *topical;
@property (nonatomic,retain) NSMutableArray *attentionCodes;

- (id)initWithTopical:(NSString *)topical type:(CompanyListType)type;
- (id)initWithTopical:(NSString *)topical type:(CompanyListType)type userName:(NSString *)userName;

@end
