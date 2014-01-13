//
//  WishesComListViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-13.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "WishesComListViewController.h"
#import "WishesPieViewController.h"

@interface WishesComListViewController ()

@end

@implementation WishesComListViewController

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
    self.title = @"心愿榜";
	[self initComponents];
    [self getComListInfo];
}

-(void)watchBtClicked:(UIBarButtonItem *)bt {
    WishesPieViewController *pieChart = [[[WishesPieViewController alloc] initWithComList:self.comList] autorelease];
    [self.navigationController pushViewController:pieChart animated:YES];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    self.comTable = temp;
    [self.view addSubview:self.comTable];
    
    UIBarButtonItem *watchBt=[[UIBarButtonItem alloc] initWithTitle:@"浏览心愿榜" style:UIBarButtonItemStyleBordered target:self action:@selector(watchBtClicked:)];
    
    [self.navigationItem setRightBarButtonItem:watchBt animated:YES];
}

#pragma mark -
#pragma NetConection

-(void)getComListInfo {
    
    [Utiles getNetInfoWithPath:@"GetVoteResult" andParams:nil besidesBlock:^(id obj) {
        
        id coms = obj[@"items"];
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        for (id obj in coms) {
            [temps addObject:obj];
        }
        self.comList = temps;
        [self.comTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma Table DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"点击投票查看结果";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleValue1
                 reuseIdentifier:TableSampleIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
    cell.textLabel.text = self.comList[indexPath.row][@"companyname"];
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Utiles isLogin]) {
        id model = self.comList[indexPath.row];
        NSDictionary *params = @{
                                 @"itemid":model[@"id"],
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu",
                                 @"state":@"1"
                                 };
        [Utiles postNetInfoWithPath:@"Votes" andParams:params besidesBlock:^(id obj) {
            
            if ([obj[@"status"] isEqualToString:@"1"]) {
                WishesPieViewController *pieChart = [[[WishesPieViewController alloc] initWithComList:self.comList] autorelease];
                [self.navigationController pushViewController:pieChart animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            } else {
                [Utiles showToastView:self.view withTitle:nil andContent:obj[@"msg"] duration:1.0];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.0];
    }
    
    
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
