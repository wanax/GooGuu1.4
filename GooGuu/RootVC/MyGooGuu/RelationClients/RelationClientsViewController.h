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
//为哪种类型用户查找用户关系表（我的/Ta的）
@property (nonatomic,retain) NSString *forWho;
@property (nonatomic,retain) NSString *userName;

@property (nonatomic,retain) UITableView *clientTable;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

-(id)initWithListType:(RelationClientType)type;
-(id)initWithType:(NSString *)type andUserName:(NSString *)username;

@end
