//
//  ArticleCommentViewController.h
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-16 | Wanax | 估股新闻二级评论列表页面

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

#define FINGERCHANGEDISTANCE 100.0

//此页面两个部分公用
typedef enum {
    
    News,//估股新闻展示分析报告
    StockCompany//股票公司展示分析报告
    
} AnalyArticleType;

@interface ArticleCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>{
    BOOL nibsRegistered;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
}

@property  AnalyArticleType type;
@property (nonatomic,retain) UITableView *cusTable;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) id commentArr;

@end
