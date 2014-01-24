//
//  GooGuuCommentViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "GooGuuCommentViewController.h"
#import "TopCommentCell.h"
#import "RegexKitLite.h"
#import "SVPullToRefresh.h"
#import "AddCommentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GooGuuCommentViewController ()

@end

@implementation GooGuuCommentViewController

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type
{
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"估友评论";
	[self initComponents];
    [self getComments];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    temp.showsVerticalScrollIndicator = NO;
    self.commentTable = temp;
    [self.view addSubview:self.commentTable];
    
    [self.commentTable addInfiniteScrollingWithActionHandler:^{
        [self addComments];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.commentTable addSubview:self.refreshControl];
    
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self  action:@selector(sendBtClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = sendButton;
}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getComments];
    
}

#pragma mark -
#pragma NetConection

-(void)addComments {
    NSString *url = @"";
    NSDictionary *params = nil;
    NSString *arId=[[self.commentList lastObject] objectForKey:@"cid"];
    if (arId==nil) {
        [self.commentTable.infiniteScrollingView stopAnimating];
        return;
    }
    if (self.type == CompanyComment) {
        url = @"CompanyCommentURL";
        
        params = @{
                   @"cid":arId,
                   @"stockcode":self.topical
                   };
    } else if (self.type == GGviewComment) {
        url = @"Commentary";
        params = @{
                   @"cid":arId,
                   @"articleid":self.topical
                   };
    }
    

    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];

            for(id model in self.commentList){
                [temps addObject:model];
            }
        for (id model in obj) {
            [temps addObject:model];
        }
        self.commentList = temps;
        [self.commentTable reloadData];
        [self.commentTable.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)getComments{
    NSString *url = @"";
    NSDictionary *params = nil;
    if (self.type == CompanyComment) {
        url = @"CompanyCommentURL";
        params = @{
                   @"stockcode":self.topical
                   };
    } else if (self.type == GGviewComment) {
        url = @"Commentary";
        params = @{
                   @"articleid":self.topical
                   };
    }
    
    
    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        for (id model in obj) {
            [temps addObject:model];
        }
        self.commentList = temps;
        [self.commentTable reloadData];
        [self.commentTable.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = [self.commentList[indexPath.row][@"content"] split:@"<br/>"];
    CGSize size = [Utiles getLabelSizeFromString:arr[0] font:[UIFont fontWithName:@"Heiti SC" size:12.0] width:275];
    
    if ([arr count] > 1) {
        return size.height + 120;
    } else {
        return size.height + 55;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TopCommentCellIdentifier = @"TopCommentCellIdentifier";
    
    TopCommentCell *cell = (TopCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    id model = self.commentList[indexPath.row];
    
    if (cell == nil) {
        cell = [[[TopCommentCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:TopCommentCellIdentifier] autorelease];
    }
    
    NSArray *arr = [model[@"content"] split:@"<br/>"];
    
    cell.content = arr[0];
    cell.userName = model[@"author"];
    //cell.artTitle = [NSString stringWithFormat:@"[%@]%@",model[@"classify"],model[@"title"]];
    cell.updateTime = [Utiles intervalSinceNow:model[@"replytime"]];
    cell.avaURL = model[@"headerpicurl"];
    
    //添加评论缩略图
    if ([arr count] > 1) {
        NSString *regexString  = @"http.*((.gif)|(.jpg)|(.bmp)|(.png)|(.GIF)|(.JPG)|(.PNG)|(.BMP))";
        NSArray  *matchArray  = [[arr JSONString] componentsMatchedByRegex:regexString];
        cell.thumbnailsURL = matchArray;
    }
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = self.commentList[indexPath.row];
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    delegate.comInfo=model;
    
    //GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:GooGuuView] autorelease];
    
    //articleVC.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma UIControl Action

-(void)sendBtClicked:(UIBarButtonItem *)bt {
    
    if ([Utiles isLogin]) {
        AddCommentViewController *addCommentViewController=[[[AddCommentViewController alloc] initWithTopical:self.topical type:self.type] autorelease];
        [self presentViewController:addCommentViewController animated:YES completion:nil];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
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
