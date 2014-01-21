//
//  ClientRelationComListVC.h
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientRelationComListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSString *sourceType;
@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSString *topical;
@property (nonatomic,retain) NSMutableArray *attentionCodes;

@property (nonatomic,retain) UITableView *comTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

- (id)initWithTopical:(NSString *)topical type:(NSString *)type;

@end
