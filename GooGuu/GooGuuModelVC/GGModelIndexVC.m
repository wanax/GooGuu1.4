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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
}

-(void)initComponents {
    
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self  action:@selector(backUp:)] autorelease];
    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:18.0]};
    self.title = self.companyInfo[@"companyname"];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    self.comAboutTable.scrollEnabled = NO;
    
    self.ggReportButton.layer.cornerRadius = 4.0;
    self.ggValueModelButton.layer.cornerRadius = 4.0;
    self.ggFinDataButton.layer.cornerRadius = 4.0;
    self.ggViewButton.layer.cornerRadius = 4.0;
    
    if (![Utiles isBlankString:self.companyInfo[@"comanylogourl"]]) {
        [self.comIconImg setImageWithURL:[NSURL URLWithString:self.companyInfo[@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    } else {
        [self.comIconImg setImage:[UIImage imageNamed:@"defaultPic"]];
    }

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
    
    [self.comInfoSeg setTitle:[NSString stringWithFormat:@"关注(%@)",self.companyInfo[@"attentioncount"]] forSegmentAtIndex:1];
    [self.comInfoSeg setTitle:[NSString stringWithFormat:@"模型(%@)",self.companyInfo[@"usersavecount"]] forSegmentAtIndex:2];
}

#pragma mark -
#pragma NetWork

-(void)getComInfo {
    
    
}

#pragma mark -
#pragma Button Action

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
        
    } else if (sender.selectedSegmentIndex == 2){//保存用户
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

- (IBAction)comExpectSegClicked:(id)sender {
}

- (IBAction)ggReportBtClicked:(id)sender {
}

- (IBAction)ggModelBtClicked:(id)sender {
}

- (IBAction)ggFinBtClicked:(id)sender {
}

- (IBAction)ggViewBtClicked:(id)sender {
}

-(IBAction)backUp:(UIBarButtonItem *)bt {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        cell.textLabel.text = @"公司公告";
        cell.imageView.image = [UIImage imageNamed:@"post_small_icon"];
    } else if (row == 1) {
        cell.textLabel.text = @"大行估值";
        cell.imageView.image = [UIImage imageNamed:@"dahon_small_icon"];
    } else if (row ==2) {
        cell.textLabel.text = @"估友评论";
        cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
    }
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    //公司公告
    if (row == 0) {
        CompanyPostListViewController *postVC = [[[CompanyPostListViewController alloc] init] autorelease];
        postVC.stockCode = self.companyInfo[@"stockcode"];
        [self.navigationController pushViewController:postVC animated:YES];
    } else if (row == 1) {//大行估值
        DahonValuationViewController *dahonVC = [[[DahonValuationViewController alloc] init] autorelease];
        dahonVC.comInfo = self.companyInfo;
        [self presentViewController:dahonVC animated:YES completion:nil];
    } else if (row == 2) {//估右评论
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
