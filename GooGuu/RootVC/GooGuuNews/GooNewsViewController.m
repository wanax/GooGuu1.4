//
//  GooNewsViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooNewsViewController.h"
#import "GooNewsCell.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "GooGuuArticleViewController.h"
#import "MHTabBarController.h"
#import "ArticleCommentViewController.h"
#import "DailyStockCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"
#import "ComFieldViewController.h"
#import "HelpViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DailyStock2Cell.h"
#import "WishesComListViewController.h"



@interface GooNewsViewController ()

@end

@implementation GooNewsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    ////[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidAppear:(BOOL)animated{
    ////[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.customTableView reloadData];
}
-(void)helpAction:(id)sender{
    
    HelpViewController *help=[[HelpViewController alloc] init];
    help.type=UserHelp;
    help.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:help animated:YES];
    SAFE_RELEASE(help);
    
}
-(void)addHelpBt{
    
    UIButton *wanSay = [[[UIButton alloc] initWithFrame:CGRectMake(200, 10.0, 30, 30)] autorelease];
    [wanSay setImage:[UIImage imageNamed:@"helpBt"] forState:UIControlStateNormal];
    [wanSay addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:wanSay] autorelease];
    [self.navigationItem setRightBarButtonItem:nextStepBarBtn animated:YES];
  
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addHelpBt];
    
    self.navigationController.navigationBar.tintColor=[Utiles colorWithHexString:@"#C86125"];
    self.title=@"最新简报";
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"readingmarks" andKey:nil inUserDomain:YES];

    [self addTable];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getGooGuuNews];    
    [self addTableAction];
    
}

-(void)addTable{
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT-92) style:UITableViewStylePlain] autorelease];
    self.customTableView = tempTable;
    [self.customTableView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    self.customTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.customTableView.dataSource=self;
    self.customTableView.delegate=self;
    [self.view addSubview:self.customTableView];
    
}

-(void)addTableAction{
    
    [self.customTableView addInfiniteScrollingWithActionHandler:^{
        [self addGooGuuNews];
    }];    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.customTableView.bounds.size.height, self.view.frame.size.width, self.customTableView.bounds.size.height)];
        
        view.delegate = self;
        [self.customTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
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
 
    [Utiles getNetInfoWithPath:@"GooGuuNewsURL" andParams:nil besidesBlock:^(id news){
        
        self.arrList=[news objectForKey:@"data"];
        [self.customTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
    [Utiles getNetInfoWithPath:@"DailyStock" andParams:nil besidesBlock:^(id obj){
        
        self.imageUrl=[NSString stringWithFormat:@"%@",[obj objectForKey:@"imageurl"]];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"stockcode"],@"stockcode", nil];
        [Utiles getNetInfoWithPath:@"QueryCompany" andParams:params besidesBlock:^(id resObj){
            
            self.companyInfo=resObj;
            [self.customTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"%@",error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [self.customTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
    }];
    
    
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return @"每日一股";
    }else if (section == 1){
        return @"最新简报";
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UILabel *backLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 20)] autorelease];
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    UILabel *mark=nil;

    if (section==0) {
        label.frame = CGRectMake(20, 2, 300, 20);
        mark=[[[UILabel alloc] initWithFrame:CGRectMake(10,2,6,20)] autorelease];
    } else {
        label.frame = CGRectMake(20, 2, 300, 20);
        mark=[[[UILabel alloc] initWithFrame:CGRectMake(10,2,6,20)] autorelease];
    }
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont fontWithName:@"Heiti SC" size:13.0f];
    label.text = sectionTitle;
    
    [mark setBackgroundColor:[UIColor orangeColor]];
    
    // Create header view and add label as a subview
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)] autorelease];
    [view addSubview:backLabel];
    [view addSubview:label];
    [view addSubview:mark];
    
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 164.0;
    }else{
        return 195.0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return 1;
    }else if(section==1){
        return [self.arrList count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int section=indexPath.section;
    UITableViewCell *returnCell=nil;
    
    if(section==0){
        
        static NSString *DailyStockCellIdentifier = @"DailyStock2CellIdentifier";
        DailyStock2Cell *cell = (DailyStock2Cell*)[tableView dequeueReusableCellWithIdentifier:DailyStockCellIdentifier];//复用cell
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DailyStock2Cell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        if(self.imageUrl){
            [cell.comImg setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.imageUrl]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]
                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                       if(image){
                           cell.comImg.image=image;
                       }           
                   }
                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                       
                   }];
        }
        static NSNumberFormatter *formatter;
        if(formatter==nil){
            formatter=[[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"##0.##"];
        }
        
        [cell.indicatorLable setBackgroundColor:[UIColor blackColor]];
        [cell.indicatorLable setAlpha:0.6];
        [cell.indicatorLable setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [cell.indicatorLable setTextColor:[UIColor whiteColor]];
  
        NSNumber *marketPrice=[self.companyInfo objectForKey:@"marketprice"];
        NSNumber *ggPrice=[self.companyInfo objectForKey:@"googuuprice"];
        float outLook=([ggPrice floatValue]-[marketPrice floatValue])/[marketPrice floatValue];
        
        cell.indicatorLable.text=[NSString stringWithFormat:@" %@(%@.%@) 潜在空间:%@",[self.companyInfo objectForKey:@"companyname"],[self.companyInfo objectForKey:@"stockcode"],[self.companyInfo objectForKey:@"marketname"],[NSString stringWithFormat:@"%.2f%%",outLook*100]];
        if(!self.companyInfo){
            cell.indicatorLable.text=@"";
        }
        
        [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
        cell.backLabel.layer.cornerRadius = 5;
        cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
        cell.backLabel.layer.borderWidth = 0;
        
        SAFE_RELEASE(formatter);
        returnCell= cell;
        
    }else if(section==1){
        static NSString *GooNewsCellIdentifier = @"GooNewsCellIdentifier";
        static BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"GooNewsCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GooNewsCellIdentifier];
            nibsRegistered = YES;
        }
        
        GooNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:GooNewsCellIdentifier];
        if (cell == nil) {
            cell = [[[GooNewsCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier: GooNewsCellIdentifier] autorelease];
        }
        
        int row=[indexPath row];
        id model=[self.arrList objectAtIndex:row];

        cell.title=[model objectForKey:@"title"];
        cell.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.titleLabel.numberOfLines=0;
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [self setReadingMark:cell andTitle:[model objectForKey:@"title"]];
        cell.contentWebView.backgroundColor = [UIColor clearColor];
        cell.contentWebView.opaque = NO;
        cell.contentWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        cell.contentWebView.tag=indexPath.row;
        cell.contentWebView.userInteractionEnabled=YES;
        
        [(UIScrollView *)[[cell.contentWebView subviews] objectAtIndex:0] setBounces:NO];
        
        UIButton *cellBt=[[[UIButton alloc] initWithFrame:CGRectMake(0,0,320,135)] autorelease];
        cellBt.tag=indexPath.row;
        [cellBt addTarget:self action:@selector(cellBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cellBt];
        
        NSString *webviewText = @"<style>body{margin:0px;background-color:transparent;font:16px/22px Custom-Font-Name}</style>";
        
        NSString *temp=[model objectForKey:@"concise"];
        if([temp length]>95){
            temp=[temp substringToIndex:95];
        }
        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@......", temp];
        [cell.contentWebView loadHTMLString:htmlString baseURL:nil];
        cell.timeDiferLabel.text=[Utiles intervalSinceNow:[model objectForKey:@"updatetime"]];
        
        if([model objectForKey:@"comanylogourl"]){
            [cell.comIconImg setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]
                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                        if(image){
                            cell.comIconImg.image=image;
                        }
                    }
                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                        
                    }];
        }
        
        [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
        cell.backLabel.layer.cornerRadius = 5;
        cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
        cell.backLabel.layer.borderWidth = 0;

        returnCell= cell;
    }
    
    [returnCell setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    return returnCell;

}

#pragma mark -
#pragma mark General Methods

-(void)backToPresent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cellBtClicked:(UIButton *)bt{
    NSInteger row=bt.tag;
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    delegate.comInfo=[self.arrList objectAtIndex:row];
    NSString *artId=[NSString stringWithFormat:@"%@",[[self.arrList objectAtIndex:row] objectForKey:@"articleid"]];
    GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
    articleViewController.articleTitle=[[self.arrList objectAtIndex:row] objectForKey:@"title"];
    articleViewController.articleId=artId;
    articleViewController.title=@"研究报告";
    ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
    articleCommentViewController.articleId=artId;
    articleCommentViewController.title=@"评论";
    articleCommentViewController.type=News;
    MHTabBarController *tempMH = [[[MHTabBarController alloc] init] autorelease];
    self.container = tempMH;
    NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
    self.container.viewControllers=controllers;
    
    UIViewController *contentVC = [[[UIViewController alloc] init] autorelease];
    [contentVC addChildViewController:self.container];
    [contentVC.view addSubview:self.container.view];
    contentVC.view.frame = CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT-44);
    
    UIViewController *test = [[[UIViewController alloc] init] autorelease];
    test.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    [test.view addSubview:contentVC.view];
    [test addChildViewController:contentVC];
    
    [Utiles setConfigureInfoTo:@"readingmarks" forKey:[[self.arrList objectAtIndex:row] objectForKey:@"title"] andContent:@"1"];
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"readingmarks" andKey:nil inUserDomain:YES];
    test.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:test animated:YES];
    
    SAFE_RELEASE(articleViewController);
    SAFE_RELEASE(articleCommentViewController);
}

-(void)setReadingMark:(GooNewsCell *)cell andTitle:(NSString *)title{
    
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
    if(indexPath.section==0){
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        delegate.comInfo=self.companyInfo;
        ComFieldViewController *com = [[ComFieldViewController alloc] init];
        com.browseType=ValuationModelType;
        com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
        //[self presentViewController:com animated:YES completion:nil];
        
        WishesComListViewController *wishesList = [[[WishesComListViewController alloc] init] autorelease];
        wishesList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wishesList animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if(indexPath.section==1){
        
    }
    
}



#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getGooGuuNews];  
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
