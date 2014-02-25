//
//  ChatListViewController.m
//  GooGuu
//
//  Created by Xcode on 14-2-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatCell.h"
#import "YFInputBar.h"

@interface ChatListViewController ()<YFInputBarDelegate>

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.chats = temp;
        self.pageNum = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initCommponents];
    [self getChatsInfo:self.pageNum isRefresh:YES];
}

-(void)initCommponents {
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-35)] autorelease];
    tempTable.delegate = self;
    tempTable.dataSource = self;
    tempTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTable = tempTable;
    [self.view addSubview:self.chatTable];
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputBack)] autorelease];
    [self.chatTable addGestureRecognizer:tap];
    
    YFInputBar *inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds)-44, 320, 44)];
    
    inputBar.backgroundColor = [UIColor grayColor];

    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    self.inputBar = inputBar;
    
    [self.view addSubview:inputBar];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.chatTable addSubview:self.refreshControl];
    
}

-(void)handleRefresh:(UIRefreshControl *)control {
    [ProgressHUD show:nil];
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getChatsInfo:++self.pageNum isRefresh:NO];
    
}

-(void)getChatsInfo:(int)pn isRefresh:(BOOL)isRefresh{
    
    if ([Utiles isLogin]) {
        NSDictionary *params = @{
                                 @"touser":self.toUser,
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu",
                                 @"offset":@(pn)
                                 };
        [Utiles getNetInfoWithPath:@"ChatList" andParams:params besidesBlock:^(id obj) {
            
            if (isRefresh) {
                [self.chats removeAllObjects];
            }
            id data = obj[@"data"];
            for (id obj in data) {
                [self.chats addObject:obj];
            }
            
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([Utiles dateToSecond:obj1[@"sendTime"] format:@"yyyy-MM-dd HH:mm:ss"] > [Utiles dateToSecond:obj2[@"sendTime"] format:@"yyyy-MM-dd HH:mm:ss"]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            
            [self.chats sortUsingComparator:cmptr];
            
            [self.chatTable reloadData];
            if ([self.chats count] > 0 && isRefresh) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.chats count]-1 inSection:0];
                [self.chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            [ProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

#pragma mark -
#pragma Input Bar

-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    if ([Utiles isLogin]) {
        NSDictionary *params = @{
                                 @"touser":self.toUser,
                                 @"msg":str,
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu"
                                 };
        [Utiles postNetInfoWithPath:@"SendPriMsg" andParams:params besidesBlock:^(id obj) {
            self.pageNum = 1;
            [self getChatsInfo:self.pageNum isRefresh:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

-(void)inputBack {
    [self.inputBar resignFirstResponder];
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = [Utiles getLabelSizeFromString:self.chats[indexPath.row][@"cotent"] font:[UIFont fontWithName:@"Heiti SC" size:12.0] width:200];
    
    float height = 0.0;
    if (size.height < 40) {
        height = 60;
    } else {
        height = size.height+40;
    }
    
    return height;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chats count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ChatCellIdentifier = @"ChatCellIdentifier";
    
    ChatCell *cell = (ChatCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (cell == nil) {
        cell = [[[ChatCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:ChatCellIdentifier] autorelease];
    }

    cell.chatInfo = self.chats[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma Table Method Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 {"msg":"获取成功","data":[{"sendTime":"2014-02-14 10:39:41","realname":"mxchenry****com","cotent":"what up","userheaderimg":"http://images.googuu.net/pics/userheader/87_90.png","id":172,"username":"mxchenry@163.com","status":0},{"sendTime":"2014-02-14 09:41:54","realname":"135****7012","cotent":"where are you from","userheaderimg":"http://www.googuu.net/images/pages/home/user_head.png","id":171,"username":"13538067012","status":1},{"sendTime":"2014-02-14 09:41:38","realname":"135****7012","cotent":"hi","userheaderimg":"http://www.googuu.net/images/pages/home/user_head.png","id":170,"username":"13538067012","status":1}],"status":"1"}
 */







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
