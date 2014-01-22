//
//  TestTableViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-21.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@end
