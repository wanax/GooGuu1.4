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
#import "ComFieldViewController.h"

@interface StockSearchListViewController ()

@end

@implementation StockSearchListViewController

@synthesize comList;
@synthesize nibsRegistered;
@synthesize searchBar;
@synthesize searchTable;

- (void)dealloc
{
    SAFE_RELEASE(comList);
    SAFE_RELEASE(searchTable);
    SAFE_RELEASE(searchBar);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.searchBar becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utiles iOS7StatusBar:self];
	self.title=@"股票搜索";
    searchTable=[[UITableView alloc] initWithFrame:CGRectMake(0,62,SCREEN_WIDTH,SCREEN_HEIGHT-125)];
    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,35)];
    
    if(!IOS7_OR_LATER){
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }

    [self.searchBar setPlaceholder:@"输入股票代码/名称/拼音"];
    self.searchBar.backgroundColor = [UIColor grayColor];
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    
    [searchTable setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    searchTable.dataSource=self;
    searchTable.delegate=self;
    [self.view addSubview:searchTable];
    
    IndicatorSearchView *indicator=[[IndicatorSearchView alloc] init];
    indicator.center=CGPointMake(SCREEN_WIDTH/2,50);
    [self.view insertSubview:indicator aboveSubview:self.searchTable];
    [indicator release];
    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.searchTable.bounds.size.height, self.view.frame.size.width, self.searchTable.bounds.size.height)];
        
        view.delegate = self;
        [self.searchTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
 
}

-(void)getcomListByKey:(NSString *)key{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:key,@"q", nil];
    [Utiles postNetInfoWithPath:@"QueryComList" andParams:params besidesBlock:^(id resObj){
        
        self.comList=resObj;
        [self.searchTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)requestValution:(UIButton *)bt{
    NSString *stockCode=[[self.comList objectAtIndex:bt.tag-1] objectForKey:@"stockcode"];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:stockCode,@"stockcode", nil];
    [Utiles postNetInfoWithPath:@"RequestValuation" andParams:params besidesBlock:^(id resObj){       
        if(resObj){
            if([[resObj objectForKey:@"status"] boolValue]){
                [bt setBackgroundImage:[UIImage imageNamed:@"hasDoneRequestedBt"] forState:UIControlStateNormal];
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
    return 90.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * SearchStockCellIdentifier =
    @"SearchStockCellIdentifier";
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"SearchStockCell" bundle:nil];
        [searchTable registerNib:nib forCellReuseIdentifier:SearchStockCellIdentifier];
        nibsRegistered = YES;
    }
    
    SearchStockCell *cell = [searchTable dequeueReusableCellWithIdentifier:SearchStockCellIdentifier];
    if (cell == nil) {
        cell = [[[SearchStockCell alloc] initWithStyle:UITableViewCellStyleValue1
                                 reuseIdentifier: SearchStockCellIdentifier] autorelease];
    }
    
    
    NSUInteger row;
    row = [indexPath row];
    @try{
        id comInfo=[comList objectAtIndex:row];
        cell.companyNameLabel.lineBreakMode=NSLineBreakByCharWrapping;
        cell.companyNameLabel.numberOfLines=0;
        [cell.companyNameLabel setText:[comInfo objectForKey:@"companyname"]==nil?@"":[comInfo objectForKey:@"companyname"]];
        [cell.stockCodeLabel setText:[NSString stringWithFormat:@"%@.%@",[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"market"]]];
        [cell.requestValuationsBt setTag:row+1];
        if([[comInfo objectForKey:@"hasmodel"] boolValue]){
            [cell.comModelImg setImage:[UIImage imageNamed:@"hasModelSymbol"]];
            [cell.requestValuationsBt setHidden:YES];
        }else{
            [cell.comModelImg setImage:[UIImage imageNamed:@"hasnoModelSymbol"]];
            [cell.requestValuationsBt setBackgroundImage:[UIImage imageNamed:@"requestValuationBt"] forState:UIControlStateNormal];
            [cell.requestValuationsBt setTitle:@"请求估值" forState:UIControlStateNormal];
            [cell.requestValuationsBt addTarget:self action:@selector(requestValution:) forControlEvents:UIControlEventTouchUpInside];
            [cell.requestValuationsBt setHidden:NO];
        }
        
        if([[comInfo objectForKey:@"hasreport"] boolValue]){
            [cell.comBriefImg setImage:[UIImage imageNamed:@"hasBriefSymbol"]];
        }else{
            [cell.comBriefImg setImage:[UIImage imageNamed:@"hasnoBriefSymbol"]];
        }
        
        cell.backLabel.layer.cornerRadius=5.0;
        cell.backLabel.layer.borderWidth=0;
        cell.backLabel.backgroundColor=[UIColor whiteColor];
        [cell.contentView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
        
    }@catch (NSException *e) {
        NSLog(@"%@",e);
    }
    
    return cell;
    
}


#pragma mark -
#pragma mark Table Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    return indexPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    int row=indexPath.row;
    delegate.comInfo=[self.comList objectAtIndex:row];
    ComFieldViewController *com=[[ComFieldViewController alloc] init];
    com.browseType=SearchStockList;
    com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self presentViewController:com animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchBar resignFirstResponder];
}



#pragma mark -
#pragma mark Search Delegate Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
//搜索实现
-(void)resetSearch
{
    [self handleSearchForTerm:@""];
    
}
-(void)handleSearchForTerm:(NSString *)searchTerm
{
    [self getcomListByKey:searchTerm];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    NSString *searchTerm=[sBar text];
    [self handleSearchForTerm:searchTerm];
    [searchBar resignFirstResponder];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)sBar
{
    [self resetSearch];
    //重置
    sBar.text=@"";
    //输入框清空
    [searchTable reloadData];
    [searchBar resignFirstResponder];
    //重新载入数据，隐藏软键盘
    
}


#pragma mark -
#pragma mark - Table Header View Methods

- (void)doneLoadingTableViewData{
    [self getcomListByKey:@"1"];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.searchTable];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [searchBar resignFirstResponder];
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
