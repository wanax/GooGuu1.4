//
//  WishesComListViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-13.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishesComListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *comTable;

@property (nonatomic,retain) NSArray *comList;

@end
