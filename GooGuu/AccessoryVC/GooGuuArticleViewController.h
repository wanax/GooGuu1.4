//
//  GooGuuArticleViewController.h
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-10 | Wanax | 估股新闻二级详细咨询页面

#import <UIKit/UIKit.h>
#import "CXPhotoBrowser.h"

#define FINGERCHANGEDISTANCE 100.0

@interface GooGuuArticleViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDataSource, CXPhotoBrowserDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    CXBrowserNavBarView *navBarView;
}

@property GooGuuArticleType sourceType;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSArray *imageUrlList;
@property (nonatomic,retain) id articleInfo;
@property (nonatomic,retain) NSString *articleContent;

@property (nonatomic,retain) UIWebView *articleWeb;
@property (nonatomic,retain) UILabel *imageTitleLabel;
@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

- (id)initWithModel:(id)model andType:(GooGuuArticleType)type;

@end
