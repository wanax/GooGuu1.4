//
//  TopComsViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopComsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *comTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property TopPoints type;
@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSString *topical;
@property (nonatomic,retain) NSMutableArray *attentionCodes;

- (id)initWithTopical:(NSString *)topical type:(TopPoints)type;

@end
