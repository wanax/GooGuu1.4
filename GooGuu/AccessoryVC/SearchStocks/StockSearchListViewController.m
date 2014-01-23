//
//  StockSearchListViewController.m
//  googuu
//
//  Created by Xcode on 13-8-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "StockSearchListViewController.h"
#import "IndicatorSearchView.h"
#import "SearchStockCell.h"
#import "GGModelIndexVC.h"

@interface StockSearchListViewController ()

@end

@implementation StockSearchListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title=@"股票搜索";
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-40)] autorelease];
    self.searchTable = tempTable;
    self.searchTable.dataSource=self;
    self.searchTable.delegate=self;
    [self.view addSubview:self.searchTable];
    
    UISearchBar *tempBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0,45,SCREEN_WIDTH,35)] autorelease];
    self.searchBar = tempBar;

    [self.searchBar setPlaceholder:@"输入股票代码/名称/拼音"];
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.delegate=self;
    [self.view addSubview:self.searchBar];
 
}

-(void)getcomListByKey:(NSString *)key{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:key,@"q", nil];
    [Utiles postNetInfoWithPath:@"QueryComList" andParams:params besidesBlock:^(id resObj){
        self.comList=resObj;
        [self.searchTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)requestValution:(UIButton *)bt{
    NSString *stockCode=self.comList[bt.tag][@"stockcode"];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:stockCode,@"stockcode", nil];
    [Utiles postNetInfoWithPath:@"RequestValuation" andParams:params besidesBlock:^(id resObj){       
        if(resObj){
            if([[resObj objectForKey:@"status"] boolValue]){
                [bt setTitle:@"请求送达" forState:UIControlStateNormal];
                [Utiles showToastView:self.view withTitle:@"谢谢" andContent:[NSString stringWithFormat:@"共计已发送%@次请求,我们会尽快处理.",[resObj objectForKey:@"data"]] duration:2.0];
            }
        }        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * SearchStockCellIdentifier =
    @"SearchStockCellIdentifier";
    
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"SearchStockCell" bundle:nil];
        [self.searchTable registerNib:nib forCellReuseIdentifier:SearchStockCellIdentifier];
        self.nibsRegistered = YES;
    }
    
    SearchStockCell *cell = [self.searchTable dequeueReusableCellWithIdentifier:SearchStockCellIdentifier];
    if (cell == nil) {
        cell = [[[SearchStockCell alloc] initWithStyle:UITableViewCellStyleValue1
                                 reuseIdentifier: SearchStockCellIdentifier] autorelease];
    }

    id comInfo=self.comList[indexPath.row];
    
    cell.companyNameLabel.lineBreakMode=NSLineBreakByCharWrapping;
    cell.companyNameLabel.numberOfLines=0;
    cell.companyNameLabel.text = comInfo[@"companyname"];
    cell.stockCodeLabel.text = [NSString stringWithFormat:@"%@.%@",comInfo[@"stockcode"],comInfo[@"market"]];
    [cell.requestValuationsBt setTag:indexPath.row];
    
    if([comInfo[@"hasmodel"] boolValue]){
        [cell.requestValuationsBt setHidden:YES];
    }else{
        [cell.requestValuationsBt setTitle:@"请求估值" forState:UIControlStateNormal];
        [cell.requestValuationsBt addTarget:self action:@selector(requestValution:) forControlEvents:UIControlEventTouchUpInside];
        [cell.requestValuationsBt setHidden:NO];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    return indexPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *params = @{
                             @"stockcode":self.comList[indexPath.row][@"stockcode"]
                             };
    [Utiles getNetInfoWithPath:@"GetCompanyInfo" andParams:params besidesBlock:^(id obj) {
        
        GGModelIndexVC *modelIndexVC = [[[GGModelIndexVC alloc] initWithNibName:@"GGModelIndexView" bundle:nil] autorelease];
        modelIndexVC.companyInfo = obj;
        UINavigationController *navModel = [[[UINavigationController alloc] initWithRootViewController:modelIndexVC] autorelease];
        [self presentViewController:navModel animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.searchBar resignFirstResponder];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -
#pragma mark Scroll Delegate Methods

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark Search Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getcomListByKey:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [self getcomListByKey:sBar.text];
    [self.searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)sBar {
    [self getcomListByKey:sBar.text];
    sBar.text=@"";
    [self.searchBar resignFirstResponder];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
