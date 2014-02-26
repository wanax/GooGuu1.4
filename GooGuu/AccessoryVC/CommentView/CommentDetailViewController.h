//
//  CommentDetailViewController.h
//  GooGuu
//
//  Created by Xcode on 14-2-25.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhotoBrowser.h"

@interface CommentDetailViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDataSource, CXPhotoBrowserDelegate>{
    CXBrowserNavBarView *navBarView;
}

@property (retain, nonatomic) NSString  *commentId;
@property BOOL isFirstLoad;

@property (nonatomic,retain) NSArray *imageUrlList;

@property (nonatomic,retain) UIWebView *commentWeb;
@property (nonatomic,retain) UILabel *imageTitleLabel;
@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

- (id)initWithCommentId:(NSString *)id;

@end
