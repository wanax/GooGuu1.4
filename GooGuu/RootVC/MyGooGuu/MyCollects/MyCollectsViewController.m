//
//  MyCollectViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "MyCollectsViewController.h"
#import "SVPullToRefresh.h"
#import "GooGuuArticleViewController.h"

@interface MyCollectsViewController ()

@end

@implementation MyCollectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pageOffset=1;
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        self.collectList = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收藏";
    [self initComponents];
    [self getMyCollectList:@""];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    //temp.showsVerticalScrollIndicator = NO;
    self.collectTable = temp;
    [self.view addSubview:self.collectTable];
    
    [self.collectTable addInfiniteScrollingWithActionHandler:^{
        NSString *stringInt = [NSString stringWithFormat:@"%d",self.pageOffset];
        [self getMyCollectList:stringInt];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.collectTable addSubview:self.refreshControl];
    
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
    [self getMyCollectList:stringInt];
    
}

#pragma mark -
#pragma NetConection

-(void)getMyCollectList:(NSString *)strOffset {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utiles getUserToken], @"token",strOffset,@"offset",@"googuu",@"from",
                            nil];
    
    [Utiles getNetInfoWithPath:@"ClientCollects" andParams:params besidesBlock:^(id obj) {
        
        id clients = obj[@"data"];
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        if (self.pageOffset>1) {
            for(id model in self.collectList){
                [temps addObject:model];
            }
        }
        
        for (id model in clients) {
            [temps addObject:model];
        }
        self.collectList = temps;
        self.pageOffset++;
        [self.collectTable reloadData];
        [self.collectTable.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.collectList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ComPostCellIdentifier = @"ComPostCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ComPostCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleValue1
                 reuseIdentifier:ComPostCellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor tangerineColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    
    id model = self.collectList[indexPath.row];
    cell.textLabel.text = model[@"title"];
    cell.detailTextLabel.text = model[@"author"];
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = self.collectList[indexPath.row];
    GooGuuArticleViewController *articleVC = nil;
    if ([model[@"classify"] isEqualToString:@"研究报告"]) {
        articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:HotReport] autorelease];
    } else {
        articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:HotView] autorelease];
    }
    articleVC.articleId = model[@"ctxId"];
    articleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleVC animated:YES];
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
