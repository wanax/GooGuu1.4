//
//  TaIndexViewController.m
//  GooGuu
//
//  Created by Xcode on 14-2-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "TaIndexViewController.h"
#import "UILabel+VerticalAlign.h"
#import "RelationClientsViewController.h"
#import "ClientAttentonsViewController.h"
#import "ClientFansViewController.h"
#import "CommonComListVC.h"
#import "GooGuuCommentListVC.h"
#import "ChatListViewController.h"
#import "RegexKitLite.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TaIndexViewController ()

@end

@implementation TaIndexViewController

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
	self.view .backgroundColor = [UIColor cloudsColor];
    [self getUserInfo];
}

#pragma mark -
#pragma Net Action

-(void)getUserInfo {
    
    [ProgressHUD show:nil];
    NSDictionary *params = @{
                             @"username":self.userName,
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"state":@"1"
                             };
    [Utiles getNetInfoWithPath:@"TargetUserInfo" andParams:params besidesBlock:^(id obj) {
        
        [ProgressHUD dismiss];
        if ([obj[@"status"] isEqualToString:@"1"]) {
            id info = obj[@"data"];

            if (![Utiles isBlankString:info[@"userheaderimg"]]) {
                [self.avatarImg setImageWithURL:info[@"userheaderimg"] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
            } else {
                [self.avatarImg setImage:[UIImage imageNamed:@"defaultAvatar"]];
            }
            NSString *reg = @"(\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b)|(\\d{8,13})";
            if ([info[@"realname"] isMatchedByRegex:reg]) {
                NSString *temp = info[@"realname"];
                NSString *temp1 = [temp substringToIndex:3];
                NSString *temp2 = [temp substringFromIndex:[temp length]-3];
                self.userNameLabel.text = [NSString stringWithFormat:@"%@***%@",temp1,temp2];
            } else {
                self.userNameLabel.text = info[@"realname"];
            }
            //用户seg信息设置
            if (![info[@"whetherToBlacklist"] boolValue]) {
                if ([info[@"whetherToAttens"] boolValue] && [info[@"whetherAttenMe"] boolValue]) {
                    [self.taInfoSegment setTitle:@"相互关注" forSegmentAtIndex:0];
                } else if ([info[@"whetherToAttens"] boolValue]) {
                    [self.taInfoSegment setTitle:@"已关注" forSegmentAtIndex:0];
                } else if (![info[@"whetherToAttens"] boolValue]) {
                    [self.taInfoSegment setTitle:@"关注" forSegmentAtIndex:0];
                }
            } else {
                [self.taInfoSegment setTitle:@"已拖黑" forSegmentAtIndex:0];
            }
            [self.taInfoSegment setTitle:[NSString stringWithFormat:@"Ta的关注(%@)",info[@"attencount"]] forSegmentAtIndex:1];
            [self.taInfoSegment setTitle:[NSString stringWithFormat:@"Ta的粉丝(%@)",info[@"fanscount"]] forSegmentAtIndex:2];
            
            [self setInfoType:@"atrade" label:self.tradeLabel userInfo:info dicName:@"TradeList"];
            [self setInfoType:@"savor" label:self.favLabel userInfo:info dicName:@"InterestList"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)setInfoType:(NSString *)type label:(UILabel *)label userInfo:(id)userInfo dicName:(NSString *)name{
    NSDictionary *dic=[Utiles getConfigureInfoFrom:name andKey:nil inUserDomain:NO];
    NSString *str=@"";
    if(![Utiles isBlankString:[userInfo objectForKey:type]]){
        NSArray *tradeArr=[[userInfo objectForKey:type] componentsSeparatedByString:@","];
        
        for(id obj in tradeArr){
            str=[str stringByAppendingFormat:@"%@,",dic[obj]];
        }
        str=[str substringToIndex:([str length]-1)];
        [label setText:str];
        [label alignTop];
    }else{
        [label setText:@""];
    }
}

#pragma mark -
#pragma UI Action

- (IBAction)chatButtonClicked:(id)sender {
    
    ChatListViewController *chatListVC = [[[ChatListViewController alloc] init] autorelease];
    chatListVC.toUser = self.userName;
    [self.navigationController pushViewController:chatListVC animated:YES];
}

- (IBAction)userInfoSegChanged:(id)sender {
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int index = seg.selectedSegmentIndex;
    //用户关系
    if (index == 0) {
        
        if ([Utiles isLogin]) {
            
            NSString *title = [seg titleForSegmentAtIndex:0];
            if ([title isEqualToString:@"相互关注"]) {
                [self attentionAction:@"DelAttentionUser" block:^(id obj) {
                    if ([obj[@"status"] isEqualToString:@"1"]) {
                        [seg setTitle:@"关注" forSegmentAtIndex:0];
                    } else {
                        [ProgressHUD showError:obj[@"msg"]];
                    }
                }];
            } else if ([title isEqualToString:@"已关注"]) {
                [self attentionAction:@"DelAttentionUser" block:^(id obj) {
                    if ([obj[@"status"] isEqualToString:@"1"]) {
                        [seg setTitle:@"关注" forSegmentAtIndex:0];
                    } else {
                        [ProgressHUD showError:obj[@"msg"]];
                    }
                }];
            } else if ([title isEqualToString:@"关注"]) {
                [self attentionAction:@"AddAttentionUser" block:^(id obj) {
                    if ([obj[@"status"] isEqualToString:@"1"]) {
                        [seg setTitle:@"已关注" forSegmentAtIndex:0];
                    } else {
                        [ProgressHUD showError:obj[@"msg"]];
                    }
                }];
            }
            
        } else {
            [ProgressHUD showError:@"请先登录"];
        }
    } else {
        
        RelationClientsViewController *clientsVC = nil;
        //关注列表
        if (index == 1) {
            clientsVC = [[[ClientAttentonsViewController alloc] initWithType:@"FriendList" andUserName:self.userName] autorelease];
        } else if (index == 2) {//粉丝列表
            clientsVC = [[[ClientFansViewController alloc] initWithType:@"FriendList" andUserName:self.userName] autorelease];
        }
        clientsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:clientsVC animated:YES];
    }
    
}

-(void)attentionAction:(NSString *)url block:(void(^)(id obj))block {

    NSDictionary *params = @{
                             @"username":self.userName,
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu"
                             };
    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        block(obj);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    if (row == 0) {
        cell.textLabel.text = @"Ta的投资组合";
        cell.imageView.image = [UIImage imageNamed:@"finpic_small_icon"];
    } else if (row == 1) {
        cell.textLabel.text = @"Ta的评论";
        cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
    }
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;

    //投资组合
    if (row == 0) {
        CommonComListVC *comsListVC = [[[CommonComListVC alloc] initWithTopical:@"Ta的投资组合" type:FriendAttentionCom userName:self.userName] autorelease];
        [self.navigationController pushViewController:comsListVC animated:YES];
    } else if (row == 1) {//用户评论
        GooGuuCommentListVC *commentListVC = [[[GooGuuCommentListVC alloc] initWithTopical:@"Ta的评论" type:TargetUserComment userName:self.userName] autorelease];
        [self.navigationController pushViewController:commentListVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotate{
    
    return NO;
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
