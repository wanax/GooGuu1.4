//
//  GooGuuIndexViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuIndexViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>

@property (nonatomic,retain) UITableView *indexTable;

@property (nonatomic,retain) id dailyComInfo;
@property (nonatomic,retain) NSString *imageUrl;

@end
