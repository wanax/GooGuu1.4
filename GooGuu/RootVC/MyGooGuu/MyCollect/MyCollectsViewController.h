//
//  MyCollectsViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property NSInteger pageOffset;
@property (nonatomic,retain) NSArray *collectList;

@property (nonatomic,retain) UITableView *collectTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
