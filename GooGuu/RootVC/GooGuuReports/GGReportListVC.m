//
//  GooNewsViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GGReportListVC.h"
#import "GooReportCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GooGuuArticleViewController.h"
#import "MHTabBarController.h"
#import "ArticleCommentViewController.h"
#import "SVPullToRefresh.h"
#import "ComFieldViewController.h"



@interface GGReportListVC ()

@end

@implementation GGReportListVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"业绩简报";

    [self addTable];
    [self addTableAction];
    [self getGooGuuNews];
}

-(void)addTable{
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain] autorelease];
    self.customTableView = tempTable;
    self.customTableView.dataSource=self;
    self.customTableView.delegate=self;
    [self.view addSubview:self.customTableView];
    
}

-(void)addTableAction{
    
    [self.customTableView addInfiniteScrollingWithActionHandler:^{
        [self addGooGuuNews];
    }];    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.customTableView addSubview:self.refreshControl];
}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getGooGuuNews];
}

#pragma mark -
#pragma mark Net Get JSON Data

-(void)addGooGuuNews{
    
    NSString *arId=[[self.arrList lastObject] objectForKey:@"articleid"];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:arId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"GooGuuNewsURL" andParams:params besidesBlock:^(id resObj){

        NSMutableArray *exNews=[resObj objectForKey:@"data"];
        NSMutableArray *temp=[NSMutableArray arrayWithArray:self.arrList];
        for(id obj in exNews){
            [temp addObject:obj];
        }
        self.arrList=temp;
        [self.customTableView reloadData];
        [self.customTableView.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

//网络获取数据
- (void)getGooGuuNews{
    [ProgressHUD show:nil];
    [Utiles getNetInfoWithPath:@"GooGuuNewsURL" andParams:nil besidesBlock:^(id news){
        
        self.arrList=[news objectForKey:@"data"];
        [self.customTableView reloadData];
        [ProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [ProgressHUD dismiss];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}


#pragma mark -
#pragma mark Table Data Source Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 197.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *GGReportCellIdentifier = @"GGReportCellIdentifier";
    
    GooReportCell *cell = (GooReportCell *)[tableView dequeueReusableCellWithIdentifier:GGReportCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GooReportCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
        cell.contentTextView.layoutManager.delegate = self;
    }
    
    int row=[indexPath row];
    id model=[self.arrList objectAtIndex:row];
    
    cell.title=[model objectForKey:@"title"];
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.titleLabel.numberOfLines=2;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *temp=[model objectForKey:@"concise"];
    if([temp length]>95){
        temp = [NSString stringWithFormat:@"%@.....",[temp substringToIndex:95]];
    }
    cell.contentTextView.text = temp;
    
    cell.timeDiferLabel.text=[Utiles intervalSinceNow:[model objectForKey:@"updatetime"]];
    
    if([model objectForKey:@"comanylogourl"]){
        [cell.comIconImg setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }

    return cell;

}


#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
}


#pragma mark -
#pragma mark General Methods

-(void)backToPresent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = self.arrList[indexPath.row];

    GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:GooGuuReport] autorelease];
    articleVC.articleId = model[@"articleid"];
    articleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [Utiles setConfigureInfoTo:@"readingmarks" forKey:model[@"title"] andContent:@"1"];
    SetConfigure(@"readingmarks", model[@"title"], @"1");
}


-(NSUInteger)supportedInterfaceOrientations{

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
