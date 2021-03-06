//
//  ClientFansViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ClientFansViewController.h"
#import "SVPullToRefresh.h"
#import "TaIndexViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ClientFansViewController ()

@end

@implementation ClientFansViewController

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

-(id)initWithType:(NSString *)type andUserName:(NSString *)username {
    self = [super init];
    if (self) {
        self.pageOffset = 1;
        self.forWho = type;
        self.userName = username;
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        self.clientList = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的粉丝";
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
    NSString *url = @"";
    NSDictionary *params = nil;
    
    if ([self.forWho isEqualToString:@"FriendList"]) {
        params = @{
                   @"username":self.userName,
                   @"offset":strOffset,
                   @"from":@"googuu"
                   };
        url = @"FriendFans";
    } else {
        if ([Utiles isLogin]) {
            params = @{
                       @"token":[Utiles getUserToken],
                       @"offset":strOffset,
                       @"from":@"googuu"
                       };
            url = @"ClientFans";
        } else {
            [ProgressHUD showError:@"请先登录"];
        }
    }
    
    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        
        [ProgressHUD dismiss];
        id clients;
        if ([self.forWho isEqual:@"FriendList"]) {
            clients = obj;
        } else {
            clients = obj[@"data"];
        }
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
    
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.clientList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ComPostCellIdentifier = @"ComPostCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ComPostCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:ComPostCellIdentifier] autorelease];
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

    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaIndexViewController *taIndexVC = [[[TaIndexViewController alloc] init] autorelease];
    taIndexVC.userName = self.clientList[indexPath.row][@"username"];
    [self.navigationController pushViewController:taIndexVC animated:YES];
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
