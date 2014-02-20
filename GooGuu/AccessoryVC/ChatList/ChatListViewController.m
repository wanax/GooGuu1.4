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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initCommponents];
    [self getChatsInfo:self.offset];
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
    
}

-(void)getChatsInfo:(NSString *)pageNum {
    
    if([Utiles isBlankString:self.offset]) {
        pageNum = @"";
    }
    NSDictionary *params = @{
                             @"touser":self.toUser,
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"offset":pageNum
                             };
    [Utiles getNetInfoWithPath:@"ChatList" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        if (self.chats) {
            for (id obj in self.chats) {
                [temp addObject:obj];
            }
        }
        id data = obj[@"data"];
        for (id obj in data) {
            [temp addObject:obj];
        }
        
        NSComparator cmptr = ^(id obj1, id obj2){
            if ([Utiles dateToSecond:obj1[@"sendTime"] format:@"yyyy-MM-dd HH:mm:ss"] > [Utiles dateToSecond:obj2[@"sendTime"] format:@"yyyy-MM-dd HH:mm:ss"]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        self.chats = [temp sortedArrayUsingComparator:cmptr];
        [self.chatTable reloadData];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.chats count]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

#pragma mark -
#pragma Input Bar

-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    NSDictionary *params = @{
                             @"touser":self.toUser,
                             @"msg":str,
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu"
                             };
    [Utiles postNetInfoWithPath:@"SendPriMsg" andParams:params besidesBlock:^(id obj) {
        [self getChatsInfo:self.offset];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
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
