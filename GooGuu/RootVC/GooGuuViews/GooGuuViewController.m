//
//  GooGuuViewController.m
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuViewController.h"
#import "ValueViewCell.h"
#import "GooGuuArticleViewController.h"
#import "ArticleCommentViewController.h"
#import "MHTabBarController.h"
#import "SVPullToRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GooGuuViewController ()

@end

@implementation GooGuuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        self.viewDataArr = arr;
    }
    return self;
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

    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain] autorelease];
    self.cusTable = tempTable;
    self.cusTable.delegate = self;
    self.cusTable.dataSource = self;
    
    [self.cusTable addInfiniteScrollingWithActionHandler:^{
        [self getValueViewData:self.articleId code:@""];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.cusTable addSubview:self.refreshControl];
    
    [self.view addSubview:self.cusTable];
}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getValueViewData:@"" code:@""];
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

        [self.cusTable.infiniteScrollingView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark Table DataSource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 193.0;
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
        cell.conciseTextView.layoutManager.delegate = self;
        cell.conciseTextView.textContainer.size = CGSizeMake(304,100);
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];

    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURL:[NSURL URLWithString:[model[@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }
    
    [cell.titleLabel setText:model[@"title"]];
    cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    cell.titleLabel.numberOfLines=2;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    //设置文字过长时的显示格式截去尾部
    cell.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self setReadingMark:cell andTitle:model[@"title"]];
    
    NSString *temp = model[@"concise"];
    if([temp length] > 95){
        temp = [NSString stringWithFormat:@"%@......",[temp substringToIndex:80]];
    }

    cell.conciseTextView.text = temp;
    
    [cell.updateTimeLabel setText:model[@"updatetime"]];

    return cell;
    
}

#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
}

#pragma mark -
#pragma mark General Methods

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

    id model = self.viewDataArr[indexPath.row];
    
    GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:GooGuuView] autorelease];
    articleVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SetConfigure(@"googuuviewreadingmarks", model[@"title"], @"1");
    self.readingMarksDic=GetConfigure(@"googuuviewreadingmarks", nil, YES);
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
