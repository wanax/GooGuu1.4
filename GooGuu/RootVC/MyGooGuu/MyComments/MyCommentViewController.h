//
//  MyCommentViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property UserCommentType type;
@property NSInteger pageOffset;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSArray *fansList;

@property (nonatomic,retain) UITableView *fansTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

- (id)initWithAccount:(NSString *)account type:(UserCommentType)type;

@end
