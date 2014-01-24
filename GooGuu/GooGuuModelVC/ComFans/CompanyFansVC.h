//
//  CompanyFansVCr.h
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyFansVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property CompanyFans type;
@property NSInteger pageOffset;
@property (nonatomic,retain) NSString *stockCode;
@property (nonatomic,retain) NSArray *fansList;

@property (nonatomic,retain) UITableView *fansTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

- (id)initWithStockCode:(NSString *)stockcode type:(CompanyFans)type;

@end
