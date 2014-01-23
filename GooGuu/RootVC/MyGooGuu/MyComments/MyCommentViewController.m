//
//  MyCommentViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-16.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "MyCommentViewController.h"
#import "SVPullToRefresh.h"

@interface MyCommentViewController ()

@end

@implementation MyCommentViewController


- (id)initWithAccount:(NSString *)account type:(UserCommentType)type
{
    self = [super init];
    if (self) {
        self.pageOffset = 1;
        self.type = type;
        self.username = account;
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        self.fansList = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.type == MyComment) {
        self.title = @"已发评论";
    } else if (self.type == TaComment) {
        self.title = @"Ta的评论";
    }
    [self initComponents];
    [self getFans:@""];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
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

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.username, @"username",strOffset,@"offset",nil];
    
    [Utiles getNetInfoWithPath:@"ClientComments" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        if (self.pageOffset>1) {
            for(id model in self.fansList){
                [temps addObject:model];
            }
        }
        
        for (id model in obj) {
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
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:ComPostCellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor tangerineColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    
    id model = self.fansList[indexPath.row];
    NSString *titlestr=@"";
    if (model[@"companyname"]!=nil) {
        titlestr=model[@"companyname"];
    }else if (model[@"title"]!=nil) {
        titlestr=model[@"title"];
    }
    cell.textLabel.text = titlestr;
    cell.detailTextLabel.text = model[@"content"];
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.postList[indexPath.row][@"headerpicurl"]]];
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
