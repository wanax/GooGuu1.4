//
//  GooGuuViewController.h
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface GooGuuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}

@property (nonatomic,retain) UITableView *cusTable;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSArray *viewDataArr;
@property (nonatomic,retain) NSDictionary *readingMarksDic;

- (void)doneLoadingTableViewData;

@end
