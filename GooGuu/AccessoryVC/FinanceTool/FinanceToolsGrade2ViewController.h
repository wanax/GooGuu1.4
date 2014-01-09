//
//  FinanceToolsGrade2ViewController.h
//  googuu
//
//  Created by Xcode on 13-10-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  2013-10-15 | Wanax | 金融工具二级页面 针对某些需要二次选择的页面

#import <UIKit/UIKit.h>

@interface FinanceToolsGrade2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *typeNames;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSArray *paramArr;

@property (nonatomic,retain) UITableView *customTabel;

@end
