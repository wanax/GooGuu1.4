//
//  TopCommentsViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCommentsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *commentTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property (nonatomic,retain) NSArray *commentList;

@end
