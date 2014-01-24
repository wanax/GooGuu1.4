//
//  GooGuuCommentViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-24.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property GooGuuCommentType type;
@property (nonatomic,retain) NSString *topical;
@property (nonatomic,retain) UITableView *commentTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property (nonatomic,retain) NSArray *commentList;

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type;
@end
