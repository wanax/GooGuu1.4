//
//  TopArticlesViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "TopArticlesViewController.h"

@interface TopArticlesViewController ()

@end

@implementation TopArticlesViewController

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
    self.title = @"热门文章";
	[self initComponents];
    [self getArticlesInfo];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    self.articleTable = temp;
    [self.view addSubview:self.articleTable];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.articleTable addSubview:self.refreshControl];

}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getArticlesInfo];

}

#pragma mark -
#pragma NetConection

-(void)getArticlesInfo {
    
    [Utiles getNetInfoWithPath:@"GetTopArticles" andParams:nil besidesBlock:^(id obj) {

        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        for (id model in obj) {
            [temps addObject:model];
        }
        self.articleList = temps;
        [self.articleTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articleList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TopArticleCellIdentifier = @"TopArticleCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TopArticleCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:TopArticleCellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor tangerineColor];
    
    id model = self.articleList[indexPath.row];
    cell.textLabel.text = model[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"[%@]%@",model[@"classify"],[Utiles secondToDate:[model[@"updatetime"] doubleValue]]];
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
