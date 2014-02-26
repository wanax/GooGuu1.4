//
//  ClientPriMsgsViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ClientPriMsgsViewController.h"
#import "SVPullToRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatListViewController.h"

@interface ClientPriMsgsViewController ()

@end

@implementation ClientPriMsgsViewController

- (id)initWithListType:(RelationClientType)type
{
    self = [super init];
    if (self) {
        self.pageOffset = 1;
        self.type = type;
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        self.clientList = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"私信";
    [self initComponents];
    [self getClients:@""];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    self.clientTable = temp;
    [self.view addSubview:self.clientTable];
    
    
    [self.clientTable addInfiniteScrollingWithActionHandler:^{
        NSString *stringInt = [NSString stringWithFormat:@"%d",self.pageOffset];
        [self getClients:stringInt];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.clientTable addSubview:self.refreshControl];
    
}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    self.pageOffset = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    NSString *stringInt = [NSString stringWithFormat:@"%d",self.pageOffset];
    [self getClients:stringInt];
}

#pragma mark -
#pragma NetConection

-(void)getClients:(NSString *)strOffset {
    
    [ProgressHUD show:nil];
    if ([Utiles isLogin]) {
        NSDictionary *params = @{
                                 @"token":[Utiles getUserToken],
                                 @"offset":strOffset,
                                 @"from":@"googuu"
                                 };
        
        [Utiles getNetInfoWithPath:@"ClientPrivateMsgs" andParams:params besidesBlock:^(id obj) {
            
            [ProgressHUD dismiss];
            id clients = obj[@"data"];
            NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
            if (self.pageOffset > 1) {
                for(id model in self.clientList){
                    [temps addObject:model];
                }
            }
            for (id model in clients) {
                [temps addObject:model];
            }
            self.clientList = temps;
            self.pageOffset++;
            [self.clientTable reloadData];
            [self.clientTable.infiniteScrollingView stopAnimating];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

#pragma mark -
#pragma UI Action

-(void)blackListButtonClicked:(UIButton *)bt {
    
    if ([Utiles isLogin]) {
        NSString *url = @"";
        NSDictionary *params = @{
                                 @"username":self.clientList[bt.tag][@"username"],
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu"
                                 };
        if ([bt.titleLabel.text isEqualToString:@"加入黑名单"]) {
            url = @"AddToBlackList";
        } else {
            url = @"RemoveFromBlackList";
        }
        [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
            if ([obj[@"status"] isEqualToString:@"1"]) {
                if ([bt.titleLabel.text isEqualToString:@"加入黑名单"]) {
                    [bt setTitle:@"移出黑名单" forState:UIControlStateNormal];
                } else {
                    [bt setTitle:@"加入黑名单" forState:UIControlStateNormal];
                }
            } else {
                [ProgressHUD showError:@"移除失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.clientList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ComPostCellIdentifier = @"ComPostCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ComPostCellIdentifier];
    UIButton *button = nil;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleValue1
                 reuseIdentifier:ComPostCellIdentifier] autorelease];

        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250,10,70,30);
        [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:12.0f]];
        [button setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor ] forState:UIControlStateHighlighted];
        [button setTitle:@"加入黑名单" forState:UIControlStateNormal];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(blackListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor tangerineColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    
    id model = self.clientList[indexPath.row];
    
    NSString *reg = @"(\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b)|(\\d{8,13})";
    if ([model[@"realname"] isMatchedByRegex:reg]) {
        NSString *temp = model[@"realname"];
        NSString *temp1 = [temp substringToIndex:3];
        NSString *temp2 = [temp substringFromIndex:[temp length]-3];
        cell.textLabel.text = [NSString stringWithFormat:@"%@***%@",temp1,temp2];
    } else {
        cell.textLabel.text = model[@"realname"];
    }
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:model[@"userheaderimg"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    
    BOOL isBlack = [model[@"whetherToBlacklist"] boolValue];
    if (isBlack) {
        [button setTitle:@"移出黑名单" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"加入黑名单" forState:UIControlStateNormal];
    }
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatListViewController *chatTableVC = [[[ChatListViewController alloc] init] autorelease];
    chatTableVC.toUser = self.clientList[indexPath.row][@"username"];
    [self.navigationController pushViewController:chatTableVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
