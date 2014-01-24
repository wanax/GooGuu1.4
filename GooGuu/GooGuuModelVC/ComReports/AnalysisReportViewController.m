//
//  AnalysisReportViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票分析

#import "AnalysisReportViewController.h"
#import "CompanyReportCell.h"
#import "GooGuuArticleViewController.h"
#import "AnalyDetailViewController.h"

@interface AnalysisReportViewController ()

@end

#define FINGERCHANGEDISTANCE 100.0

@implementation AnalysisReportViewController


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
    self.nibsRegistered=NO;
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    self.reportTable = tempTable;
    self.reportTable.dataSource=self;
    self.reportTable.delegate=self;
    [self.view addSubview:self.reportTable];
    [self getAnalyrePort];
}

#pragma mark -
#pragma mark Net Get JSON Data

//网络获取数据
- (void)getAnalyrePort{
    
    NSDictionary *params = @{
                             @"stockcode":self.companyInfo[@"stockcode"]
                             };
    [Utiles postNetInfoWithPath:@"CompanyAnalyReportURL" andParams:params besidesBlock:^(id obj){
        if([obj JSONString].length>5){
            self.analyReports = obj;
            [self.reportTable reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 135.0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.analyReports count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ComReportCellIdentifier = @"CompanyReportCellIdentifier";
    
    CompanyReportCell *cell = (CompanyReportCell *)[tableView dequeueReusableCellWithIdentifier:ComReportCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CompanyReportCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
        cell.contentTextView.layoutManager.delegate = self;
        cell.contentTextView.textContainer.size = CGSizeMake(304,80);
    }
    
    int row=[indexPath row];
    id model=[self.analyReports objectAtIndex:row];

    cell.titleLabel.text = model[@"title"];
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    NSString *temp=[model objectForKey:@"brief"];
    if([temp length]>70){
        temp = [NSString stringWithFormat:@"%@.....",[temp substringToIndex:70]];
    }
    cell.contentTextView.text = temp;
    
    cell.timeDiferLabel.text=[Utiles intervalSinceNow:[model objectForKey:@"updatetime"]];

    return cell;
}

#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
}

#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *artId=[NSString stringWithFormat:@"%@",[[self.analyReports objectAtIndex:indexPath.row] objectForKey:@"articleid"]];
//    AnalyDetailViewController *detail=[[AnalyDetailViewController alloc] init];
//    detail.articleId=artId;
//
//    [self presentViewController:detail animated:YES completion:nil];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    [Utiles setConfigureInfoTo:@"readingmarks" forKey:[[self.analyReports objectAtIndex:indexPath.row] objectForKey:@"title"] andContent:@"1"];
    
    id model = self.analyReports[indexPath.row];
    GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:GooGuuView] autorelease];
    articleVC.articleId = model[@"articleid"];
    articleVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //SetConfigure(@"googuuviewreadingmarks", model[@"title"], @"1");
}

- (BOOL)shouldAutorotate{
    return NO;
}




@end
