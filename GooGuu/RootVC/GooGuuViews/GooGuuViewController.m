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
    self.from = @"GooGuuView";
    self.articleId = @"";
    self.key = @"";
    [MBProgressHUD showHUDAddedTo:self.cusTable animated:YES];
    [self getValueViewData:@"" from:self.from key:@""];
}

-(void)searchAction:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入关键字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setDelegate:self];
    self.searchAlert = alert;
    [self.searchAlert show];
}

-(void)addSearchBt{
    UIBarButtonItem *nextStepBarBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)] autorelease];
    self.navigationItem.rightBarButtonItem = nextStepBarBtn;
}

-(void)initComponents{
    
    [self addSearchBt];

    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain] autorelease];
    self.cusTable = tempTable;
    self.cusTable.delegate = self;
    self.cusTable.dataSource = self;
    
    [self.cusTable addInfiniteScrollingWithActionHandler:^{
        [MBProgressHUD showHUDAddedTo:self.cusTable animated:YES];
        [self getValueViewData:self.articleId from:self.from key:self.key];
    }];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.cusTable addSubview:self.refreshControl];
    
    [self.view addSubview:self.cusTable];
}

-(void)handleRefresh:(UIRefreshControl *)control {
    [MBProgressHUD showHUDAddedTo:self.cusTable animated:YES];
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    self.from = @"GooGuuView";
    self.articleId = @"";
    self.key = @"";
    [self getValueViewData:self.articleId from:self.from key:self.key];
}

-(void)getValueViewData:(NSString *)articleID from:(NSString *)url key:(NSString *)key{
    
    if ([Utiles isBlankString:[NSString stringWithFormat:@"%@",self.articleId]]) {
        self.articleId = @"";
    }
    if ([Utiles isBlankString:key]) {
        self.key = @"";
    }
    NSDictionary *params = nil;
    if ([url isEqualToString:@"GooGuuView"]) {
        params = @{
                   @"articleid":articleID
                   };
    } else {
        params = @{
                   @"articleid":self.articleId==nil?@"":self.articleId,
                   @"q":key
                   };
    }

    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        if (![Utiles isBlankString:[NSString stringWithFormat:@"%@",self.articleId]]) {
            for(id obj in self.viewDataArr){
                [temp addObject:obj];
            } 
        }
        for (id data in obj) {
            [temp addObject:data];
        }
        self.viewDataArr=temp;
        self.articleId=[[temp lastObject] objectForKey:@"articleid"];
        [self.cusTable reloadData];
        [self.cusTable.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView:self.cusTable animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma UITextView And UIAlert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [MBProgressHUD showHUDAddedTo:self.cusTable animated:YES];
        self.from = @"SearchGooGuuView";
        self.key = [alertView textFieldAtIndex:0].text;
        self.articleId = @"";
        [self getValueViewData:self.articleId from:self.from key:self.key];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
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
        cell.conciseTextView.textContainer.size = CGSizeMake(304,100);
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];

    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURL:[NSURL URLWithString:[model[@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }
    
    [cell.titleLabel setText:model[@"title"]];
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *temp = model[@"concise"];
    if([temp length] > 95){
        temp = [NSString stringWithFormat:@"%@......",[temp substringToIndex:80]];
    }
    cell.content = temp;
    
    //[cell.updateTimeLabel setText:model[@"updatetime"]];
    cell.updateTimeLabel.text=[Utiles intervalSinceNow:[model objectForKey:@"updatetime"]];

    return cell;
    
}

#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    id model = self.viewDataArr[indexPath.row];
    
    GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:ViewArticle] autorelease];
    articleVC.articleId = model[@"articleid"];
    articleVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
