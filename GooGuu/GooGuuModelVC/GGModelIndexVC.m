//
//  GGModelIndexVC.m
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "GGModelIndexVC.h"
#import "CompanyPostListViewController.h"
#import "DahonValuationViewController.h"
#import "CompanyFansVC.h"
#import "GGReportListVC.h"
#import "ComGGViewsVC.h"
#import "ChartViewController.h"
#import "FinancalModelChartViewController.h"
#import "FinanceDataViewController.h"
#import "AnalysisReportViewController.h"
#import "ExpectedSpaceViewController.h"
#import "GooGuuCommentListVC.h"
#import "WebChartViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GGModelIndexVC ()

@end

@implementation GGModelIndexVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self expectStock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
}

-(void)favBtClicked:(UIBarButtonItem *)bt {
    
    if ([Utiles isLogin]) {
        NSString *url = @"";
        if ([bt.title isEqualToString:@"收藏"]) {
            url = @"AddAttention";
        } else {
            url = @"DeleteAttention";
        }
        NSDictionary *params = @{
                                 @"stockcode":self.companyInfo[@"stockcode"],
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu",
                                 @"state":@"1"
                                 };
        [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
            
            if ([obj[@"status"] isEqualToString:@"1"]) {
                if ([bt.title isEqualToString:@"收藏"]) {
                    bt.title = @"取消收藏";
                } else {
                    bt.title = @"收藏";
                }
            } else {
                [Utiles showToastView:self.view withTitle:nil andContent:obj[@"msg"] duration:1.5];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
    
}

-(void)initComponents {
    
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self  action:@selector(backUp:)] autorelease];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem *favButton = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self  action:@selector(favBtClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = favButton;
    
    if ([Utiles isLogin]) {
        NSDictionary *params2 = @{
                                  @"token":[Utiles getUserToken],
                                  @"from":@"googuu",
                                  @"state":@"1"
                                  };
        [Utiles getNetInfoWithPath:@"AttentionData" andParams:params2 besidesBlock:^(id obj) {
            
            NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
            id data = obj[@"data"];
            for (id model in data) {
                [temp addObject:model[@"stockcode"]];
            }
            if ([temp containsObject:self.companyInfo[@"stockcode"]]) {
                favButton.title = @"取消收藏";
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:18.0]};
    self.title = self.companyInfo[@"companyname"];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    //IMG
    if (![Utiles isBlankString:self.companyInfo[@"comanylogourl"]]) {
        [self.comIconImg setImageWithURL:[NSURL URLWithString:self.companyInfo[@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    } else {
        [self.comIconImg setImage:[UIImage imageNamed:@"defaultPic"]];
    }
    //LABEL
    float marketPri = [self.companyInfo[@"marketprice"] floatValue];
    float ggPri = [self.companyInfo[@"googuuprice"] floatValue];
    self.marketPriLabel.text = [NSString stringWithFormat:@"%.2f",marketPri];
    self.googuuPriLabel.text = [NSString stringWithFormat:@"%.2f",ggPri];
    
    float percent = (ggPri - marketPri) / marketPri;
    self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%",percent*100];
    if (percent > 0) {
        self.updownIndicator.image = [UIImage imageNamed:@"stockUpArrow"];
    } else {
        self.updownIndicator.image = [UIImage imageNamed:@"stockDownArrow"];
    }
    //SEGMENT
    [self.comInfoSeg setTitle:[NSString stringWithFormat:@"关注人数(%@)",self.companyInfo[@"attentioncount"]] forSegmentAtIndex:1];
    [self.comInfoSeg setTitle:[NSString stringWithFormat:@"模型调整(%@)",self.companyInfo[@"usersavecount"]] forSegmentAtIndex:2];
    
    [self expectStock];
    
    //BUTTON
    self.ggReportButton.layer.cornerRadius = 4.0;
    self.ggValueModelButton.layer.cornerRadius = 4.0;
    self.ggFinDataButton.layer.cornerRadius = 4.0;
    self.ggViewButton.layer.cornerRadius = 4.0;
    if (![self.companyInfo[@"hasmodel"] boolValue]) {
        [self.ggValueModelButton setTitle:@"请求估值" forState:UIControlStateNormal];
    }
}

#pragma mark Expect

-(void)expectStock {
    
    NSDictionary *params = @{
                             @"stockcode":self.companyInfo[@"stockcode"]
                             };
    [Utiles getNetInfoWithPath:@"ExpectedSpaceResulet" andParams:params besidesBlock:^(id obj) {
        [self.comExpectSeg setTitle:[NSString stringWithFormat:@"看多(%@)",obj[@"up"]] forSegmentAtIndex:0];
        [self.comExpectSeg setTitle:[NSString stringWithFormat:@"看空(%@)",obj[@"down"]] forSegmentAtIndex:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -
#pragma Segment Delegate

- (IBAction)comInfoSegClicked:(UISegmentedControl *)sender {
    //公司简介
    if (sender.selectedSegmentIndex == 0) {
        
        NSDictionary *params = @{
                                 @"stockcode":self.companyInfo[@"stockcode"]
                                 };

        [Utiles getNetInfoWithPath:@"CompanyBrief" andParams:params besidesBlock:^(id obj) {

            NSString *cont = @"";
            if ([Utiles isBlankString:[obj JSONString]]) {
                cont = @"暂无数据";
            } else {
                cont = obj[@"introduction"];
            }
            UIAlertView *comInfoAlert = [[[UIAlertView alloc] initWithTitle:@"公司简介" message:cont delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [comInfoAlert show];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];

    } else if (sender.selectedSegmentIndex == 1) {//关注用户

        CompanyFansVC *attentionClientVC = [[[CompanyFansVC alloc] initWithStockCode:self.companyInfo[@"stockcode"] type:ComAttentionClients] autorelease];
        [self.navigationController pushViewController:attentionClientVC animated:YES];

    } else if (sender.selectedSegmentIndex == 2){//保存用户
        
        CompanyFansVC *saveClientsVC = [[[CompanyFansVC alloc] initWithStockCode:self.companyInfo[@"stockcode"] type:ComSaveClients] autorelease];
        [self.navigationController pushViewController:saveClientsVC animated:YES];

    }
}

- (IBAction)comExpectSegClicked:(UISegmentedControl *)sender {
    
    if ([Utiles isLogin]) {
        NSDictionary *params = @{
                                 @"stockcode":self.companyInfo[@"stockcode"],
                                 @"flag":@(sender.selectedSegmentIndex+1),
                                 @"from":@"googuu",
                                 @"token":[Utiles getUserToken],
                                 @"state":@"1"
                                 };
        [Utiles postNetInfoWithPath:@"ExpectedSpaceVote" andParams:params besidesBlock:^(id obj) {
            
            if ([obj[@"status"] isEqualToString:@"1"]) {
                [ProgressHUD showSuccess:@"投票成功"];
            } else {
                [ProgressHUD showError:obj[@"msg"]];
            }
            [self performSelector:@selector(goIntoExpVC) withObject:nil afterDelay:2.0];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

-(void)goIntoExpVC {
    ExpectedSpaceViewController *expectVC = [[[ExpectedSpaceViewController alloc] init] autorelease];
    expectVC.stockCode = self.companyInfo[@"stockcode"];
    [self presentViewController:expectVC animated:YES completion:nil];
}

#pragma mark -
#pragma Button Action

//估值模型
- (IBAction)ggReportBtClicked:(id)sender {
    
    if ([self.companyInfo[@"hasmodel"] boolValue]) {
        ChartViewController *modelChartVC = [[[ChartViewController alloc] init] autorelease];
        modelChartVC.comInfo = self.companyInfo;
        [self presentViewController:modelChartVC animated:YES completion:nil];
    } else {
        [self requestValution];
    }
}

//可比公司
- (IBAction)ggModelBtClicked:(id)sender {
    
    WebChartViewController *chartVC = [[[WebChartViewController alloc] initWithCode:self.companyInfo[@"stockcode"] type:@"comparecompany"] autorelease];
    [self presentViewController:chartVC animated:YES completion:nil];
    
}

//估值区间
- (IBAction)ggFinBtClicked:(id)sender {
    
    WebChartViewController *chartVC = [[[WebChartViewController alloc] initWithCode:self.companyInfo[@"stockcode"] type:@"valuationspace"] autorelease];
    [self presentViewController:chartVC animated:YES completion:nil];
    
}

//分析师目标价
- (IBAction)ggViewBtClicked:(id)sender {
    
    WebChartViewController *chartVC = [[[WebChartViewController alloc] initWithCode:self.companyInfo[@"stockcode"] type:@"analyseviewspace"] autorelease];
    [self presentViewController:chartVC animated:YES completion:nil];
    
}

-(IBAction)backUp:(UIBarButtonItem *)bt {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestValution{

    NSDictionary *params = @{
                             @"stockcode":self.companyInfo[@"stockcode"]
                             };
    [Utiles postNetInfoWithPath:@"RequestValuation" andParams:params besidesBlock:^(id resObj){
        if(resObj){
            if([[resObj objectForKey:@"status"] boolValue]){
                [Utiles showToastView:self.view withTitle:@"谢谢" andContent:[NSString stringWithFormat:@"共计已发送%@次请求,我们会尽快处理.",[resObj objectForKey:@"data"]] duration:2.0];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CustomCellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.imageView.frame = CGRectMake(0,0,10,10);
    cell.imageView.contentMode = UIViewContentModeCenter;
    int row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"财务数据";
        cell.imageView.image = [UIImage imageNamed:@"fin_small_icon"];
    } else if (row == 1) {
        cell.textLabel.text = @"大行估值";
        cell.imageView.image = [UIImage imageNamed:@"dahon_small_icon"];
    } else if (row ==2) {
        cell.textLabel.text = @"业绩简报";
        cell.imageView.image = [UIImage imageNamed:@"report_small_icon"];
    } else if (row ==3) {
        cell.textLabel.text = @"估值观点";
        cell.imageView.image = [UIImage imageNamed:@"view_small_icon"];
    } else if (row ==4) {
        cell.textLabel.text = @"公司公告";
        cell.imageView.image = [UIImage imageNamed:@"post_small_icon"];
    } else if (row ==5) {
        cell.textLabel.text = @"估友评论";
        cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
    }
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    //财务数据
    if (row == 0) {
        
        if ([self.companyInfo[@"hasmodel"] boolValue]) {
            FinancalModelChartViewController *finChartVC = [[[FinancalModelChartViewController alloc] init] autorelease];
            finChartVC.comInfo = self.companyInfo;
            [self presentViewController:finChartVC animated:YES completion:nil];
        } else {
            FinanceDataViewController *finChartVC = [[[FinanceDataViewController alloc] init] autorelease];
            finChartVC.comInfo = self.companyInfo;
            [self presentViewController:finChartVC animated:YES completion:nil];
        }
        
    } else if (row == 1) {//大行估值
        
        DahonValuationViewController *dahonVC = [[[DahonValuationViewController alloc] init] autorelease];
        dahonVC.comInfo = self.companyInfo;
        [self presentViewController:dahonVC animated:YES completion:nil];
        
    } else if (row == 2) {//业绩简报
        
        AnalysisReportViewController *reportListVC = [[[AnalysisReportViewController alloc] init] autorelease];
        reportListVC.companyInfo = self.companyInfo;
        [self.navigationController pushViewController:reportListVC animated:YES];
        
    } else if (row == 3) {//估值观点
        
        ComGGViewsVC *viewListVC = [[[ComGGViewsVC alloc] initWithStockCode:self.companyInfo[@"stockcode"]] autorelease];
        [self.navigationController pushViewController:viewListVC animated:YES];
        
    } else if (row == 4) {//公司公告
        
        CompanyPostListViewController *postVC = [[[CompanyPostListViewController alloc] init] autorelease];
        postVC.stockCode = self.companyInfo[@"stockcode"];
        [self.navigationController pushViewController:postVC animated:YES];
        
    } else if (row == 5) {//估友评论
        
        GooGuuCommentListVC *comVC = [[[GooGuuCommentListVC alloc] initWithTopical:@"估友评论" type:CompanyComment stockCode:self.companyInfo[@"stockcode"]] autorelease];
        comVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comVC animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotate{
    
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_part1View release];
    [_topBar release];
    [_comNameLabel release];
    [_comIconImg release];
    [_comInfoSeg release];
    [_marketPriLabel release];
    [_googuuPriLabel release];
    [_percentLabel release];
    [_updownIndicator release];
    [_comExpectSeg release];
    [_ggReportButton release];
    [_ggValueModelButton release];
    [_ggFinDataButton release];
    [_ggViewButton release];
    [_comAboutTable release];
    [super dealloc];
}
@end
