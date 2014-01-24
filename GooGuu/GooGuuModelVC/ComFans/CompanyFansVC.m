//
//  CompanyFansVC.m
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "CompanyFansVC.h"
#import "SVPullToRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyFansVC ()

@end

@implementation CompanyFansVC


- (id)initWithStockCode:(NSString *)stockcode type:(CompanyFans)type
{
    self = [super init];
    if (self) {
        self.stockCode = stockcode;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.type == ComAttentionClients) {
        self.title = @"关注该公司的估友";
    } else if (self.type == ComSaveClients) {
        self.title = @"保存过模型的估友";
    }
    self.pageOffset = 1;
    [self initComponents];
    NSString *stringInt = [NSString stringWithFormat:@"%d",self.pageOffset];
    [self getFans:stringInt];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    temp.showsVerticalScrollIndicator = NO;
    self.fansTable = temp;
    [self.view addSubview:self.fansTable];
    
    [self.fansTable addInfiniteScrollingWithActionHandler:^{
        NSString *stringInt = [NSString stringWithFormat:@"%d",self.pageOffset];
        [self getFans:stringInt];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.fansTable addSubview:self.refreshControl];
    
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
    [self getFans:stringInt];
    
}

#pragma mark -
#pragma NetConection

-(void)getFans:(NSString *)strOffset {
    
    NSString *url = @"";
    if (self.type == ComAttentionClients) {
        url = @"ComAttentionClients";
    } else if (self.type == ComSaveClients) {
        url = @"ComSavedClients";
    }
    
    NSDictionary *params = @{
                             @"stockcode":self.stockCode,
                             @"offset":strOffset
                             };
        
    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {

        id clients = obj[@"data"];
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
            
        if (self.pageOffset > 1) {
            for(id model in self.fansList){
                [temps addObject:model];
            }
        }
        for (id model in clients) {
            [temps addObject:model];
        }
        self.fansList = temps;
        self.pageOffset++;
        [self.fansTable reloadData];
        [self.fansTable.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fansList count];
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
    
    id model = self.fansList[indexPath.row];
    cell.textLabel.text = model[@"realname"];
    //cell.detailTextLabel.text = model[@"headerpicurl"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model[@"headerpicurl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.postList[indexPath.row][@"headerpicurl"]]];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
