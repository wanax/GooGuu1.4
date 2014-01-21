//
//  GooGuuViewController.h
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSLayoutManagerDelegate>

@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSArray *viewDataArr;

@property (nonatomic,retain) UITableView *cusTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
