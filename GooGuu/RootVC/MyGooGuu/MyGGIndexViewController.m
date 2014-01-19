//
//  MyGGIndexViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-19.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "MyGGIndexViewController.h"
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
    [self getClientInfo];
}

-(void)initComponents {
    self.title = @"我的估股";
    self.view.backgroundColor = [UIColor cloudsColor];
    self.clientTable.scrollEnabled = NO;
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
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"用户信息获取失败" duration:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (IBAction)clientInfoSegClicked:(id)sender {
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
            cell.imageView.image = [UIImage imageNamed:@"post_small_icon"];
        } else if (row == 1) {
            cell.textLabel.text = @"我的估值模型";
            cell.imageView.image = [UIImage imageNamed:@"dahon_small_icon"];
        } else if (row ==2) {
            cell.textLabel.text = @"投资日历";
            cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
        }
    } else {
        if (row == 0) {
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"post_small_icon"];
        } else if (row == 1) {
            cell.textLabel.text = @"我的评论";
            cell.imageView.image = [UIImage imageNamed:@"dahon_small_icon"];
        } else if (row ==2) {
            cell.textLabel.text = @"黑名单";
            cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
        }
    }
    
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
