//
//  RelationClientsViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelationClientsViewController : UIViewController

@property RelationClientType type;
@property NSInteger pageOffset;
@property (nonatomic,retain) NSArray *clientList;

@property (nonatomic,retain) UITableView *clientTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

-(id)initWithListType:(RelationClientType)type;

@end
