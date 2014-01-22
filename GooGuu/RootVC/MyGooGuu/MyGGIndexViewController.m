//
//  MyGGIndexViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-19.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "MyGGIndexViewController.h"
#import "MyCollectsViewController.h"
#import "MyCommentViewController.h"
#import "RelationClientsViewController.h"
#import "ClientFansViewController.h"
#import "ClientAttentonsViewController.h"
#import "ClientPriMsgsViewController.h"
#import "ClientBlackListViewController.h"
#import "ConcernedViewController.h"
#import "CalendarViewController.h"
#import "ClientRelationComListVC.h"
#import "SettingCenterViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyGGIndexViewController ()

@end

@implementation MyGGIndexViewController

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
	[self initComponents];
    if([Utiles isLogin]) {
        [self getClientInfo];
    }
}

-(void)initComponents {
    
    self.title = @"我的估股";
    self.view.backgroundColor = [UIColor cloudsColor];
    self.clientTable.scrollEnabled = NO;
    
    UIBarButtonItem *settingButton = [[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self  action:@selector(setttingBtClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = settingButton;
}


#pragma mark -
#pragma Net

-(void)getClientInfo {
    
    NSDictionary *params = @{
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"state":@"1"
                             };
    [Utiles getNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id obj) {
        if ([obj[@"status"] equals:@"1"]) {
            id clientInfo = obj[@"data"];
            [self.clientAvatar setImageWithURL:[NSURL URLWithString:clientInfo[@"headerpicurl"]] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
            self.clientNameLabel.text = clientInfo[@"nickname"];
            [self.clientActionButton setTitle:@"注销" forState:UIControlStateNormal];
            [self.clientInfoSeg setTitle:[NSString stringWithFormat:@"关注(%@)",clientInfo[@"myattentioncount"]] forSegmentAtIndex:2];
            [self.clientInfoSeg setTitle:[NSString stringWithFormat:@"粉丝(%@)",clientInfo[@"fanscount"]] forSegmentAtIndex:3];
            self.userid = clientInfo[@"userid"];
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"用户信息获取失败" duration:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark -
#pragma UIControl Action

-(void)setttingBtClicked:(UIBarButtonItem *)bt {
    
    SettingCenterViewController *set=[[[SettingCenterViewController alloc] init] autorelease];
    set.title=@"功能设置";
    set.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:set animated:YES];
    
}

- (IBAction)clientInfoSegClicked:(UISegmentedControl *)sender {
    
    int index = sender.selectedSegmentIndex;
    //用户信息
    if (index == 0) {
        
    } else {
        
        RelationClientsViewController *clientsVC = nil;
        ////私信列表
        if (index == 1) {
            clientsVC = [[[ClientPriMsgsViewController alloc] initWithListType:ClientPriMsgs] autorelease];
        } else if (index == 2) {//关注列表
            clientsVC = [[[ClientAttentonsViewController alloc] initWithListType:ClientAttentions] autorelease];
        } else if (index == 3) {//粉丝列表
            clientsVC = [[[ClientFansViewController alloc] initWithListType:ClientFans] autorelease];
        }
        clientsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:clientsVC animated:YES];
    }
}

- (IBAction)clientActionBtClicked:(id)sender {
    
    if ([self.clientActionButton.titleLabel.text equals:@"登录"]) {
        [self getClientInfo];
    } else {
        
    }
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"投资综合";
    } else {
        return @"我的足迹";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CustomCellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    int row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"我的投资组合";
            cell.imageView.image = [UIImage imageNamed:@"user_stock_small_icon"];
        } else if (row == 1) {
            cell.textLabel.text = @"我的估值模型";
            cell.imageView.image = [UIImage imageNamed:@"user_model_small_icon"];
        } else if (row ==2) {
            cell.textLabel.text = @"投资日历";
            cell.imageView.image = [UIImage imageNamed:@"user_calender_small_icon"];
        }
    } else {
        if (row == 0) {
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"user_collect_small_icon"];
        } else if (row == 1) {
            cell.textLabel.text = @"我的评论";
            cell.imageView.image = [UIImage imageNamed:@"user_msg_small_icon"];
        } else if (row ==2) {
            cell.textLabel.text = @"黑名单";
            cell.imageView.image = [UIImage imageNamed:@"user_blacklist_small_icon"];
        }
    }
    
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 0) {
        //关注的模型
        if (row == 0) {
            ClientRelationComListVC *comVC = [[[ClientRelationComListVC alloc] initWithTopical:@"投资组合" type:@"AttentionData"] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
        } else if (row == 1) {//保存的模型
            ClientRelationComListVC *savedVC = [[[ClientRelationComListVC alloc] initWithTopical:@"我的模型" type:@"SavedData"] autorelease];
            savedVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:savedVC animated:YES];
        } else if (row == 2) {//投资日历
            CalendarViewController *calendarVC = [[[CalendarViewController alloc] init] autorelease];
            
            calendarVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:calendarVC animated:YES];
        }
        
    } else if (section == 1) {
        if (row == 0) {
            MyCollectsViewController *myCollectVC = [[[MyCollectsViewController alloc] init] autorelease];
            myCollectVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }else if (row == 1){
            MyCommentViewController *myCommentVC = [[[MyCommentViewController alloc] initWithAccount:self.userid type:MyComment] autorelease];
            myCommentVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCommentVC animated:YES];
        }else if (row == 2){
            ClientBlackListViewController *blackListVC = [[[ClientBlackListViewController alloc] initWithListType:ClientBlackList] autorelease];
            blackListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:blackListVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_part1View release];
    [_clientAvatar release];
    [_clientNameLabel release];
    [_clientActionButton release];
    [_clientInfoSeg release];
    [_clientTable release];
    [super dealloc];
}

@end
