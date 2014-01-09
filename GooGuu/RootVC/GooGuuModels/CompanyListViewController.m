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
#import "math.h"
#import "MHTabBarController.h"
#import "ComFieldViewController.h"
#import "StockCell.h"
#import "UIButton+BGColor.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SVPullToRefresh.h"
#import "IndicatorComView.h"
#import "StockSearchListViewController.h"


@interface CompanyListViewController ()

@end

#define FINGERCHANGEDISTANCE 100.0

@implementation CompanyListViewController


-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self getConcernStocksCode];
    [self.table reloadData];
    if(self.isSearchList){
        [self.search becomeFirstResponder];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.search resignFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.nibsRegistered = NO;

    self.title=@"估值模型";
    [self initViewComponents];
    [self addTableHeaderAndFooter];
    
    if ([Utiles isNetConnected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getCompanyList];
        [self getConcernStocksCode];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }

    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];

}
-(void)initViewComponents{
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,62,SCREEN_WIDTH,SCREEN_HEIGHT-160)] autorelease];
    self.table = temp;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UISearchBar *tempBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,35)] autorelease];
    self.search = tempBar;
    [self.search setPlaceholder:@"输入股票代码/名称"];
    
    self.search.delegate=self;
    
    IndicatorComView *indicator=[[IndicatorComView alloc] init];
    indicator.center=CGPointMake(SCREEN_WIDTH/2,50);
    [self.view insertSubview:indicator aboveSubview:self.table];
    [indicator release];
    [self.view addSubview:self.search];
    [self.table setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    self.table.dataSource=self;
    self.table.delegate=self;
    
    [self.view addSubview:self.table];
}
-(void)addTableHeaderAndFooter{
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        
        view.delegate = self;
        [self.table addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];

    [self.table addInfiniteScrollingWithActionHandler:^{
        [self addCompany];
    }];

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
        [self.table reloadData];
        [self.table.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma mark Init Methods

-(void)getCompanyList{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.type],@"market", nil];
    [Utiles getNetInfoWithPath:@"QueryAllCompany" andParams:params besidesBlock:^(id resObj){
        
        self.comList=resObj;
        [self.table reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}
     
-(void)getConcernStocksCode{
    
    if([Utiles isLogin]){

        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from", nil];
        [Utiles postNetInfoWithPath:@"AttentionData" andParams:params besidesBlock:^(id resObj){
            if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
                NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
                self.concernStocksCodeArr = temps;
                NSArray *temp=[resObj objectForKey:@"data"];
                for(id obj in temp){
                    [self.concernStocksCodeArr addObject:[NSString stringWithFormat:@"%@",[obj objectForKey:@"stockcode"]]];
                }
                [self.table reloadData];
            }else{
                [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
                NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
                self.concernStocksCodeArr = temps;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
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
        }else if([self.comType isEqualToString:@"深市"]){
            if(change.x<-FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:3 animated:YES];
            }else if(change.x>FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
            }
        }else if([self.comType isEqualToString:@"沪市"]){
            if(change.x>FINGERCHANGEDISTANCE){
                [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
            }
        }
    }
  
}

#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * StockCellIdentifier =
    @"StockCellIdentifier";
    
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"StockCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:StockCellIdentifier];
        self.nibsRegistered = YES;
    }
    
    StockCell *cell = [tableView dequeueReusableCellWithIdentifier:StockCellIdentifier];
    if (cell == nil) {
        cell = [[[StockCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier: StockCellIdentifier] autorelease];
    }
    

    NSUInteger row;
    row = [indexPath row];
    @try{
        NSDictionary *comInfo=[self.comList objectAtIndex:row];
        cell.stockNameLabel.text=[comInfo objectForKey:@"companyname"]==nil?@"":[comInfo objectForKey:@"companyname"];
        [cell.concernBt setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        if([Utiles isLogin]){
            if([self.concernStocksCodeArr containsObject:[NSString stringWithFormat:@"%@",[comInfo objectForKey:@"stockcode"]]]){
                [cell.concernBt setTitle:@"取消关注" forState:UIControlStateNormal];
                [cell.concernBt setBackgroundImage:[UIImage imageNamed:@"cancelConcernBtt"] forState:UIControlStateNormal];
                [cell.concernBt setTag:row+1];
            }else{
                [cell.concernBt setTitle:@"添加关注" forState:UIControlStateNormal];
                //[cell.concernBt setBackgroundColorString:@"#F21E83" forState:UIControlStateNormal];
                [cell.concernBt setBackgroundImage:[UIImage imageNamed:@"addConcernBtt"] forState:UIControlStateNormal];
                [cell.concernBt setTag:row+1];
            }
            
            [cell.concernBt addTarget:self action:@selector(cellBtClick:) forControlEvents:UIControlEventTouchDown];
            [cell.concernBt setHidden:NO];
        }else{
            [cell.concernBt setHidden:YES];
        }
        NSNumber *gPriceStr=[comInfo objectForKey:@"googuuprice"];
        float g=[gPriceStr floatValue];
        cell.gPriceLabel.text=[NSString stringWithFormat:@"%.2f",g];
        NSNumber *priceStr=[comInfo objectForKey:@"marketprice"];
        float p = [priceStr floatValue];
        cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",p];
        cell.belongLabel.text=[NSString stringWithFormat:@"%@.%@",[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"marketname"]];
        float outLook=(g-p)/p;
        cell.percentLabel.text=[NSString stringWithFormat:@"%.2f%%",outLook*100];
        
        
        NSString *riseColorStr=[NSString stringWithFormat:@"RiseColor%@",[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES]];
        NSString *fallColorStr=[NSString stringWithFormat:@"FallColor%@",[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES]];
        NSString *riseColor=[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:riseColorStr inUserDomain:NO];
        NSString *fallColor=[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:fallColorStr inUserDomain:NO];

        if(outLook>0){
            cell.percentLabel.backgroundColor=[Utiles colorWithHexString:riseColor];
        }else if(outLook==0){
            cell.percentLabel.backgroundColor=[UIColor whiteColor];
        }else if(outLook<0){
            cell.percentLabel.backgroundColor=[Utiles colorWithHexString:fallColor];
        }
        
        cell.backLabel.layer.cornerRadius=5.0;
        cell.backLabel.layer.borderWidth=0;
        cell.backLabel.backgroundColor=[UIColor whiteColor];
  
    }@catch (NSException *e) {
        NSLog(@"%@",e);
    }
    
    return cell;
    
}

-(void)cellBtClick:(id)sender{
    
    UIButton *cellBt=(UIButton *)sender;
    NSString *title=[cellBt currentTitle];
    NSString *stockCode=[[self.comList objectAtIndex:cellBt.tag-1] objectForKey:@"stockcode"];
    if([title isEqualToString:@"取消关注"]){
     
        [self NetAction:@"DeleteAttention" andCode:stockCode withBt:cellBt];
 
    }else if([title isEqualToString:@"添加关注"]){

        [self NetAction:@"AddAttention" andCode:stockCode withBt:cellBt];
      
    }
    
}

-(Boolean)NetAction:(NSString *)url andCode:(NSString *)stockCode withBt:(UIButton *)cellBt{
    __block Boolean tag;

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",stockCode,@"stockcode", nil];

    [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id resObj){

        if(![[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
        }else if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            if([url isEqualToString:@"AddAttention"]){
                [self.concernStocksCodeArr addObject:stockCode];
                [cellBt setTitle:@"取消关注" forState:UIControlStateNormal];
                [cellBt setBackgroundColorString:@"#34C3C1" forState:UIControlStateNormal];
            }else if([url isEqualToString:@"DeleteAttention"]){
                [self.concernStocksCodeArr removeObject:stockCode];
                [cellBt setTitle:@"添加关注" forState:UIControlStateNormal];
                [cellBt setBackgroundColorString:@"#F21E83" forState:UIControlStateNormal];
            }
            tag=YES;
            [self.table reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];

    return tag;
}


#pragma mark -
#pragma mark Table Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.search resignFirstResponder];
    return indexPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    int row=indexPath.row;
    delegate.comInfo=[self.comList objectAtIndex:row];
    
    ComFieldViewController *tempCom = [[[ComFieldViewController alloc] init] autorelease];
    self.com = tempCom;
    self.com.browseType=ValuationModelType;
    self.com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self presentViewController:self.com animated:YES completion:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.search resignFirstResponder];
}



#pragma mark -
#pragma mark Search Delegate Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    StockSearchListViewController *searchList=[[StockSearchListViewController alloc] init];
    searchList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchList animated:YES];
    SAFE_RELEASE(searchList);
    [self.search resignFirstResponder];
  
}

#pragma mark -
#pragma mark - Table Header View Methods

- (void)doneLoadingTableViewData{
    [self getCompanyList];
    [self getConcernStocksCode];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.search resignFirstResponder];
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
    return YES;
}






@end
