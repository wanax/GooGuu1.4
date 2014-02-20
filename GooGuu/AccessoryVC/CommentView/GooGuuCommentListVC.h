//
//  GooGuuCommentList.h
//  GooGuu
//
//  Created by Xcode on 14-1-24.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuCommentListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property GooGuuCommentType type;
@property (nonatomic,retain) NSString *topical;

//各种评论来源需要的参数
//公司评论-公司代码
@property (nonatomic,retain) NSString *stockCode;
//文章评论-文章ID
@property (nonatomic,retain) NSString *articleId;
//个人评论-用户名
@property (nonatomic,retain) NSString *userName;

@property (nonatomic,retain) UITableView *commentTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property (nonatomic,retain) NSArray *commentList;

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type;

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type stockCode:(NSString *)stockCode;
- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type articleId:(NSString *)articleId;
- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type userName:(NSString *)userName;





@end
