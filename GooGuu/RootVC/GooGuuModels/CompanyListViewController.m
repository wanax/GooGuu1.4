//
//  CompanyListViewController.h
//  welcom_demo_1
//
//  股票添加列表
//
//  Created by Xcode on 13-5-9.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-09 | Wanax | 股票添加列表

#import "CompanyListViewController.h"
#import "MHTabBarController.h"
#import "ComFieldViewController.h"
#import "SVPullToRefresh.h"
#import "IndicatorComView.h"
#import "StockSearchListViewController.h"
#import "CompanyCell.h"


@interface CompanyListViewController ()

@end

#define FINGERCHANGEDISTANCE 100.0

@implementation CompanyListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"估值模型";
    [self initViewComponents];
    [self getCompanyList];

    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];

}
-(void)initViewComponents{

    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,SCREEN_HEIGHT-30)] autorelease];
    self.comsTable = temp;
    self.comsTable.dataSource=self;
    self.comsTable.delegate=self;
    [self.view addSubview:self.comsTable];
    
    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.comsTable addSubview:self.refreshControl];
    
    [self.comsTable addInfiniteScrollingWithActionHandler:^{
        [self addCompany];
    }];
    
    IndicatorComView *indicator = [[[IndicatorComView alloc] init] autorelease];
    [self.view addSubview:indicator];

}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getCompanyList];
    
}


#pragma mark -
#pragma mark Net Get JSON Data

-(void)addCompany{

    NSString *updateTime=[[self.comList lastObject] objectForKey:@"updatetime"];   
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.type],@"market",updateTime,@"updatetime", nil];
    
    [Utiles getNetInfoWithPath:@"QueryAllCompany" andParams:params besidesBlock:^(id resObj){        
        NSMutableArray *temp=[NSMutableArray arrayWithArray:self.comList];
        for(id obj in resObj){
            [temp addObject:obj];
        }
        self.comList=temp;
        [self.comsTable reloadData];
        [self.comsTable.infiniteScrollingView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma mark Init Methods

-(void)getCompanyList{

    [ProgressHUD show:nil];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.type],@"market", nil];
    [Utiles getNetInfoWithPath:@"QueryAllCompany" andParams:params besidesBlock:^(id resObj){
        
        self.comList=resObj;
        [self.comsTable reloadData];
        [ProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [ProgressHUD dismiss];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
    NSDictionary *params2 = @{
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"state":@"1"
                             };
    
    [Utiles getNetInfoWithPath:@"AttentionData" andParams:params2 besidesBlock:^(id obj) {
        
        NSMutableArray *codes = [[[NSMutableArray alloc] init] autorelease];
        id data = obj[@"data"];
        for (id model in data) {
            [codes addObject:model[@"stockcode"]];
        }
        self.attentionCodes = codes;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(BOOL)isAttention:(NSString *)stockCode {
    return [self.attentionCodes containsObject:stockCode];
}

-(void)attentionBtClicked:(UIButton *)bt {
    
    NSDictionary *params = @{
                             @"stockcode":self.comList[bt.tag][@"stockcode"],
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"state":@"1"
                             };
    
    if ([bt.titleLabel.text isEqualToString:@"添加关注"]) {
        
        [Utiles postNetInfoWithPath:@"AddAttention" andParams:params besidesBlock:^(id obj) {
            
            if ([obj[@"status"] isEqualToString:@"1"]) {
                
                [bt setTitle:@"取消关注" forState:UIControlStateNormal];
                [self.attentionCodes addObject:self.comList[bt.tag][@"stockcode"]];
                
            } else {
                [Utiles showToastView:self.view withTitle:nil andContent:obj[@"msg"] duration:1.0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    } else {
        
        [Utiles postNetInfoWithPath:@"DeleteAttention" andParams:params besidesBlock:^(id obj) {
            
            if ([obj[@"status"] isEqualToString:@"1"]) {
                
                [bt setTitle:@"添加关注" forState:UIControlStateNormal];
                [self.attentionCodes removeObject:self.comList[bt.tag][@"stockcode"]];
                
            } else {
                [Utiles showToastView:self.view withTitle:nil andContent:obj[@"msg"] duration:1.0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    
    CGPoint change=[tap translationInView:self.view];
    if(fabs(change.x)>FINGERCHANGEDISTANCE-1){
        if([self.comType isEqualToString:@"港股"]){
            if(change.x<-FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
            }
        }else if([self.comType isEqualToString:@"美股"]){
            if(change.x<-FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
            }else if(change.x>FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
            }
        }else if([self.comType isEqualToString:@"A股"]){
            if(change.x>FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
            }
        }
    }
  
}

#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CompanyCellIdentifier = @"CompanyCellIdentifier";
    
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:
                         CompanyCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CompanyCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
        [cell.attentionBt addTarget:self action:@selector(attentionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    id model = self.comList[indexPath.row];
    float marketPrice = [model[@"marketprice"] floatValue];
    float percent = 0;
    cell.comNameLabel.text = model[@"companyname"];
    cell.marketPriLable.text = [NSString stringWithFormat:@"%.2f",marketPrice];
    cell.attentionBt.tag = indexPath.row;
    if ([self isAttention:model[@"stockcode"]]) {
        [cell.attentionBt setTitle:@"取消关注" forState:UIControlStateNormal];
    } else {
        [cell.attentionBt setTitle:@"添加关注" forState:UIControlStateNormal];
    }
    
    float ggPrice = [model[@"googuuprice"] floatValue];
    cell.marketLabel.text = [NSString stringWithFormat:@"%@.%@",model[@"stockcode"],model[@"market"]];
    cell.googuuPriLable.text = [NSString stringWithFormat:@"%.2f",ggPrice];
    percent = (ggPrice - marketPrice) / marketPrice;
    
    cell.percentLable.text = [NSString stringWithFormat:@"%.0f%%",percent*100];
    if (percent > 0) {
        cell.indicatorImg.image = [UIImage imageNamed:@"stockUpArrow"];
    } else {
        cell.indicatorImg.image = [UIImage imageNamed:@"stockDownArrow"];
    }
    return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}






@end
