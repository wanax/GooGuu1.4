//
//  MyGooguuViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ConcernedViewController.h"
#import "ClientLoginViewController.h"
#import "CustomCell.h"
#import "AddCell.h"
#import "UserCell.h"
#import "MHTabBarController.h"
#import "ComFieldViewController.h"
#import "PrettyTabBarViewController.h"
#import "PrettyNavigationController.h"
#import "IndicatorView.h"
#import "Indicator2View.h"
#import "SettingCenterViewController.h"


@interface ConcernedViewController ()


@end

@implementation ConcernedViewController


- (id)initWithType:(NSString *)type andSource:(BrowseSourceType)source
{
    self = [super init];
    if (self) {
        self.type = type;
        self.browseType = source;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self getComList];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _showToast=NO;
    self.nibsRegistered=NO;
    self.nibsRegistered2=NO;
    
    [self initViewComponents];
    [self addTableHeader];
    
    if ([Utiles isNetConnected]&&[Utiles isLogin]) {
        [ProgressHUD show:nil];
        [self getComList];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
}

-(void)initViewComponents{
    
    NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
    self.comInfoList = temps;
    if(self.browseType==MyConcernedType){
        IndicatorView *indicator=[[IndicatorView alloc] init];
        [self.view addSubview:indicator];
        [indicator release];
    }else if(self.browseType==MySavedType){
        Indicator2View *indicator=[[Indicator2View alloc] init];
        [self.view addSubview:indicator];
        [indicator release];
    }
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,SCREEN_HEIGHT-148)] autorelease];
   	self.customTableView = tempTable;
    [self.customTableView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    self.customTableView.dataSource=self;
    self.customTableView.delegate=self;
    [self.view addSubview:self.customTableView];
}

-(void)addTableHeader{
    
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

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.isEditing){
        [self.customTableView setEditing:NO animated:YES];
        self.isEditing=NO;
    }
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if([self.type isEqualToString:@"AttentionData"]){
        if(change.x<-100){
            [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
        }else if(change.x>100){
            [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
        }
    }else if([self.type isEqualToString:@"SavedData"]){
        if(change.x<-100){
            [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
        }else if(change.x>100){
            [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
        }
    }
    
}

-(void)getComList{
    
    if([Utiles isLogin]){
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Utiles getUserToken], @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:self.type andParams:params besidesBlock:^(id obj){
            if(![[obj objectForKey:@"status"] isEqualToString:@"0"]){
                @try {
                    self.comInfoList=[NSMutableArray arrayWithArray:[obj objectForKey:@"data"]];
                    [self.customTableView reloadData];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
                
            }else{
                [ProgressHUD showError:[obj objectForKey:@"msg"]];
                self.comInfoList=[NSMutableArray arrayWithCapacity:0];
            }
            [ProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [ProgressHUD dismiss];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }else{
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.comInfoList count];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //股票栏目
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        self.nibsRegistered = YES;
    }
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier: CustomCellIdentifier] autorelease];
    }
    
    @try {
        NSUInteger row = [indexPath row];
        id comInfo=[self.comInfoList objectAtIndex:row];
        cell.name=[comInfo objectForKey:@"companyname"];
        
        NSNumber *gPriceStr=[comInfo objectForKey:@"googuuprice"];
        float g=[gPriceStr floatValue];
        cell.gPrice=[NSString stringWithFormat:@"%.2f",g];
        NSNumber *priceStr=[comInfo objectForKey:@"marketprice"];
        float p = [priceStr floatValue];
        cell.price=[NSString stringWithFormat:@"%.2f",p];
        cell.belong=[NSString stringWithFormat:@"%@.%@",[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"marketname"]];
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
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    cell.backLabel.layer.cornerRadius=5.0;
    cell.backLabel.layer.borderWidth=0;
    cell.backLabel.backgroundColor=[UIColor whiteColor];
    
    UILongPressGestureRecognizer *longP=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:andCellIndex:)];
    [cell addGestureRecognizer:longP];
    
    [cell.contentView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    
    SAFE_RELEASE(longP);
    return cell;
    
}


-(void)longAction:(UILongPressGestureRecognizer *)press andCellIndex:(NSIndexPath *)indexPath{
    
    [self.customTableView setEditing:YES animated:YES];
    self.isEditing=YES;
    
    UIBarButtonItem *cancelEdit=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction)];
    [self.parentViewController.parentViewController.parentViewController.navigationItem setRightBarButtonItem:cancelEdit animated:NO];
    SAFE_RELEASE(cancelEdit);
    
    
}
-(void)cancelAction{
    [self.customTableView setEditing:NO animated:YES];
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(setting:)];
    [self.parentViewController.parentViewController.parentViewController.navigationItem setRightBarButtonItem:settingButton animated:YES];
}
-(void)setting:(id)sender{
    SettingCenterViewController *set=[[[SettingCenterViewController alloc] init] autorelease];
    set.title=@"功能设置";
    set.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark -
#pragma mark Edit Mothods Delegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.browseType==MyConcernedType) {
        return @"取消关注";
    } else {
        return @"删除";
    }
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (editingStyle==UITableViewCellEditingStyleDelete) {
            NSInteger row = [indexPath row];
            NSString *stockCode=[[[self.comInfoList objectAtIndex:row] objectForKey:@"stockcode"] copy];
            [self.comInfoList removeObjectAtIndex:row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",stockCode,@"stockcode", nil];
            NSString *netAction=nil;
            if(self.browseType==MyConcernedType){
                netAction=@"DeleteAttention";
            }else if(self.browseType==MySavedType){
                netAction=@"DeleteModelData";
            }
            [Utiles postNetInfoWithPath:netAction andParams:params besidesBlock:^(id resObj){
                if(![[resObj objectForKey:@"status"] isEqualToString:@"1"]){
                    [ProgressHUD showError:[resObj objectForKey:@"msg"]];
                }
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
            }];
            [stockCode release];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
    
}
#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    int row=indexPath.row;
    @try {
        delegate.comInfo=[[self.comInfoList objectAtIndex:row] retain];
        
        self.comFieldViewController=[[ComFieldViewController alloc] init];
        self.comFieldViewController.browseType=self.browseType;
        self.comFieldViewController.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
        [self presentViewController:self.comFieldViewController animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}


#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getComList];
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    _showToast=NO;
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
    
    //NSLog(@"concern supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    
    return NO;
}




@end