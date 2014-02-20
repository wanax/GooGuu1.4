//
//  ChatListViewController.h
//  GooGuu
//
//  Created by Xcode on 14-2-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFInputBar;

@interface ChatListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *chatTable;
@property (nonatomic,retain) YFInputBar *inputBar;

@property (nonatomic,retain) NSArray *chats;
@property (nonatomic,retain) NSString *toUser;
@property (nonatomic,retain) NSString *offset;

@end
