//
//  ComGGViewsVC.h
//  GooGuu
//
//  Created by Xcode on 14-1-21.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComGGViewsVC : UIViewController<UITableViewDelegate,UITableViewDataSource,NSLayoutManagerDelegate>

@property (nonatomic,retain) NSString *stockCode;
@property (nonatomic,retain) NSArray *viewDataArr;

@property (nonatomic,retain) UITableView *cusTable;

- (id)initWithStockCode:(NSString *)code;

@end
