//
//  GooGuuViewController.h
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSArray *viewDataArr;
@property (retain, nonatomic) NSString *from;
@property (retain, nonatomic) NSString *key;

@property (nonatomic,retain) UITableView *cusTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;
@property (retain, nonatomic) UIAlertView *searchAlert;

@end
