//
//  GooGuuViewController.m
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuViewController.h"
#import "ValueViewCell.h"
#import "UIImageView+WebCache.h"
#import "GooGuuArticleViewController.h"
#import "ArticleCommentViewController.h"
#import "MHTabBarController.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"

@interface GooGuuViewController ()

@end

@implementation GooGuuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDataArr=[[NSArray alloc] init];
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.cusTable reloadData];
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"估值观点"];
    
	[self initComponents];
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"googuuviewreadingmarks" andKey:nil inUserDomain:YES];
    [self getValueViewData:@"" code:@""];
}

-(void)initComponents{

    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT-92) style:UITableViewStylePlain];
    [self.view setBackgroundColor:[Utiles colorWithHexString:GetConfigure(@"colorconfigure", @"NormalCellColor", NO)]];
    self.cusTable.delegate=self;
    self.cusTable.dataSource=self;
    self.cusTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.cusTable addInfiniteScrollingWithActionHandler:^{
        [self getValueViewData:self.articleId code:@""];
    }];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.cusTable.bounds.size.height, self.view.frame.size.width, self.cusTable.bounds.size.height)];
        
        view.delegate = self;
        [self.cusTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [self.view addSubview:self.cusTable];
    
}
-(void)getValueViewData:(NSString *)articleID code:(NSString *)stockCode{
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:articleID,@"articleid",stockCode,@"stockcode", nil];
    [Utiles getNetInfoWithPath:@"GooGuuView" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.viewDataArr){
            [temp addObject:obj];
        }
        for (id data in obj) {
            [temp addObject:data];
        }
        self.viewDataArr=temp;
        self.articleId=[[temp lastObject] objectForKey:@"articleid"];
        [self.cusTable reloadData];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.cusTable];
        [self.cusTable.infiniteScrollingView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark Table DataSource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 216.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewDataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueViewCellIdentifier = @"ValueViewCellIdentifier";
    ValueViewCell *cell = (ValueViewCell*)[tableView dequeueReusableCellWithIdentifier:ValueViewCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueViewCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];

    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[model objectForKey:@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                    if(image){
                        cell.titleImgView.image=image;
                    }
                }
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                    
                }];
    }
    
    [cell.titleLabel setText:[model objectForKey:@"title"]];
    cell.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.titleLabel.numberOfLines=0;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self setReadingMark:cell andTitle:[model objectForKey:@"title"]];
    
    cell.conciseWebView.backgroundColor = [UIColor clearColor];
    cell.conciseWebView.opaque = NO;
    cell.conciseWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [(UIScrollView *)[[cell.conciseWebView subviews] objectAtIndex:0] setBounces:NO];
    
    NSString *webviewText = @"<style>body{margin:0px;background-color:transparent;font:16px/22px Custom-Font-Name}</style>";
    
    NSString *temp=[model objectForKey:@"concise"];
    if([temp length]>80){
        temp=[temp substringToIndex:80];
    }
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@......", temp];
    
    [cell.conciseWebView loadHTMLString:htmlString baseURL:nil];
    
    
    [cell.updateTimeLabel setText:[model objectForKey:@"updatetime"]];
    [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
    cell.backLabel.layer.cornerRadius = 5;
    cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
    cell.backLabel.layer.borderWidth = 0;
    
    [cell.contentView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    
    UIButton *cellBt=[[[UIButton alloc] initWithFrame:CGRectMake(0,0,320,135)] autorelease];
    cellBt.tag=indexPath.row;
    [cellBt addTarget:self action:@selector(cellBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cellBt];
    
    return cell;
    
}

#pragma mark -
#pragma mark General Methods

-(void)cellBtClicked:(UIButton *)bt{
    NSInteger row=bt.tag;
    NSString *artId=[NSString stringWithFormat:@"%@",[[self.viewDataArr objectAtIndex:row] objectForKey:@"articleid"]];
    GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
    articleViewController.articleTitle=[[self.viewDataArr objectAtIndex:row] objectForKey:@"title"];
    articleViewController.articleId=artId;
    articleViewController.sourceType=GooGuuView;
    articleViewController.title=@"研究报告";
    ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
    articleCommentViewController.articleId=artId;
    articleCommentViewController.title=@"评论";
    articleCommentViewController.type=News;
    MHTabBarController *container=[[MHTabBarController alloc] init];
    NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
    container.viewControllers=controllers;
    
    UIViewController *contentVC = [[[UIViewController alloc] init] autorelease];
    [contentVC addChildViewController:container];
    [contentVC.view addSubview:container.view];
    contentVC.view.frame = CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT-44);
    
    UIViewController *test = [[[UIViewController alloc] init] autorelease];
    test.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    [test.view addSubview:contentVC.view];
    [test addChildViewController:contentVC];
    
    [Utiles setConfigureInfoTo:@"googuuviewreadingmarks" forKey:[[self.viewDataArr objectAtIndex:row] objectForKey:@"title"] andContent:@"1"];
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"googuuviewreadingmarks" andKey:nil inUserDomain:YES];
    
    test.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:test animated:YES];
}

-(void)setReadingMark:(ValueViewCell *)cell andTitle:(NSString *)title{
    
    if(self.readingMarksDic){
        if ([[self.readingMarksDic allKeys] containsObject:title]) {
            cell.readMarkImg.image=[UIImage imageNamed:@"read2"];
        }else{
            cell.readMarkImg.image=[UIImage imageNamed:@"unread2"];
        }
    }else{
        cell.readMarkImg.image=[UIImage imageNamed:@"unread2"];
    }
    
}

#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *artId=[NSString stringWithFormat:@"%@",[[self.viewDataArr objectAtIndex:indexPath.row] objectForKey:@"articleid"]];
    GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
    articleViewController.articleTitle=[[self.viewDataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    articleViewController.articleId=artId;
    articleViewController.sourceType=GooGuuView;
    articleViewController.title=@"研究报告";
    ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
    articleCommentViewController.articleId=artId;
    articleCommentViewController.title=@"评论";
    articleCommentViewController.type=News;
    MHTabBarController *container=[[MHTabBarController alloc] init];
    NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
    container.viewControllers=controllers;
    
    [Utiles setConfigureInfoTo:@"googuuviewreadingmarks" forKey:[[self.viewDataArr objectAtIndex:indexPath.row] objectForKey:@"title"] andContent:@"1"];
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"googuuviewreadingmarks" andKey:nil inUserDomain:YES];
    
    container.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:container animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getValueViewData:@"" code:@""];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [_activityIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
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
