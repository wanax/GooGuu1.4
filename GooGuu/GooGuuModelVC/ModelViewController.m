//
//  ModelViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票模型

#import "ModelViewController.h"
#import "ChartViewController.h"
#import "UIButton+BGColor.h"
#import "MHTabBarController.h"
#import "FinancalModelChartViewController.h"
#import "DahonValuationViewController.h"
#import "DiscountRateViewController.h"
#import "MHTabBarController.h"
#import "FinanceDataViewController.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

@synthesize comInfo;
@synthesize jsonForChart;
@synthesize browseType;
@synthesize savedStockList;
@synthesize chartViewController;
@synthesize disViewController;
@synthesize savedTable;
@synthesize isAttention;
@synthesize attentionBt;
@synthesize inputField;
@synthesize tabController;
@synthesize tapHide;

- (void)dealloc
{
    SAFE_RELEASE(tapHide);
    SAFE_RELEASE(tabController);
    SAFE_RELEASE(inputField);
    SAFE_RELEASE(attentionBt);
    SAFE_RELEASE(disViewController);
    SAFE_RELEASE(comInfo);
    SAFE_RELEASE(jsonForChart);
    SAFE_RELEASE(savedStockList);
    SAFE_RELEASE(savedTable);
    SAFE_RELEASE(chartViewController);
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
-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self removeTextField];
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if(browseType==MySavedType){
        [self.savedTable reloadData];
    }
}
-(void)initTextFeild{
    inputField=[[UITextField alloc] initWithFrame:CGRectMake(0,140,SCREEN_WIDTH,30)];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputField.returnKeyType=UIReturnKeySend;
    inputField.delegate=self;
}

-(void)addTextField{
    [self.view addSubview:inputField];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.1f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFilterLinear;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [[inputField layer] addAnimation:animation forKey:@"animation"];
    animation=nil;
    [inputField becomeFirstResponder];
    tapHide=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapHide];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self removeTextField];
}

-(void)removeTextField{
    [inputField removeFromSuperview];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.1f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFilterLinear;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [[inputField layer] addAnimation:animation forKey:@"animation"];
    animation=nil;
    [inputField resignFirstResponder];
    [self.view removeGestureRecognizer:tapHide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTextFeild];
    isAttention=NO;
    [self getConcernStatus];
    self.tabController=(MHTabBarController *)self.parentViewController;
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    comInfo=delegate.comInfo;    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#F3EFE1"]];
    
    [self initBackground];
    [self addButtons];
    
    if(self.browseType==MySavedType){
        [self initSavedTable];
        [self getChartJsonData];
        [self getSavedStockList];
    }
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];

}
-(void)initBackground{
    
    UIImageView *backGround1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"valuationModelBack"]];
    backGround1.frame=CGRectMake(0,0, SCREEN_WIDTH,60);
    [self.view addSubview:backGround1];
    UIImageView *backGround2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"valuationModelBack"]];
    backGround2.frame=CGRectMake(0,60, SCREEN_WIDTH,60);
    [self.view addSubview:backGround2];
    SAFE_RELEASE(backGround1);
    SAFE_RELEASE(backGround2);
    
}
-(void)requestValution:(UIButton *)bt{
    NSString *stockCode=[comInfo objectForKey:@"stockcode"];
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
-(void)addButtons{
    [self addNewButton:@"查看大行估值" Tag:3 frame:CGRectMake(8, 15, 150, 26)];
  
    if(self.browseType==SearchStockList){
        if([comInfo[@"hasmodel"] boolValue]){
            [self addNewButton:@"查看财务数据" Tag:1 frame:CGRectMake(163, 15, 150, 26)];
            [self addNewButton:@"调整模型参数" Tag:2 frame:CGRectMake(84, 78, 150, 26)];
        }else{
            [self addNewButton:@"查看财务数据" Tag:4 frame:CGRectMake(163, 15, 150, 26)];
            UIButton *reqBt=[UIButton buttonWithType:UIButtonTypeCustom];
            [reqBt setFrame:CGRectMake(120, 78, 80, 26)];
            reqBt.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
            [reqBt setBackgroundImage:[UIImage imageNamed:@"requestValuationBt"] forState:UIControlStateNormal];
            [reqBt setTitle:@"请求估值" forState:UIControlStateNormal];
            [reqBt addTarget:self action:@selector(requestValution:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:reqBt];
        }
    }else{
        [self addNewButton:@"查看财务数据" Tag:1 frame:CGRectMake(163, 15, 150, 26)];
        [self addNewButton:@"调整模型参数" Tag:2 frame:CGRectMake(84, 78, 150, 26)];
    }
    
    
    if(isAttention){
        if (IOS7_OR_LATER) {
            attentionBt=[self addActionButtonTag:AttentionAction frame:CGRectMake(0, 445, 160, 30) img:@"deleteAttentionBt" title:@"取消关注"];
        } else {
            attentionBt=[self addActionButtonTag:AttentionAction frame:CGRectMake(0, 357, 160, 30) img:@"deleteAttentionBt" title:@"取消关注"];
        }
        
    }else{
        if (IOS7_OR_LATER) {
            attentionBt=[self addActionButtonTag:AttentionAction frame:CGRectMake(0, SCREEN_HEIGHT-123, 160, 30) img:@"addAttentionBt" title:@"添加关注"];
        } else {
            attentionBt=[self addActionButtonTag:AttentionAction frame:CGRectMake(0, SCREEN_HEIGHT-123, 160, 30) img:@"addAttentionBt" title:@"添加关注"];
        }
        
    }
    if (IOS7_OR_LATER) {
        [self addActionButtonTag:AddComment frame:CGRectMake(160, SCREEN_HEIGHT-123, 160, 30) img:@"addCommentBt" title:@"添加评论"];
    } else {
        [self addActionButtonTag:AddComment frame:CGRectMake(160, SCREEN_HEIGHT-123, 160, 30) img:@"addCommentBt" title:@"添加评论"];
    }
    
}

-(UIButton *)addActionButtonTag:(NSInteger)tag frame:(CGRect)rect img:(NSString *)img title:(NSString *)title{
    UIButton *bt1 = [[UIButton alloc] init];
    bt1.frame = rect;
    [bt1 setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    bt1.tag = tag;
    bt1.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    [bt1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt1];
    return bt1;
}


-(void)initSavedTable{
    UILabel *board=[[UILabel alloc] initWithFrame:CGRectMake(0,125,SCREEN_WIDTH,30)];
    [board setBackgroundColor:[Utiles colorWithHexString:@"#F3EFE1"]];
    [board setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [board setTextColor:[UIColor blackColor]];
    [board setText:@"已保存数据"];
    [board setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:board];
    self.savedTable=[[UITableView alloc] initWithFrame:CGRectMake(0,155,SCREEN_WIDTH,230) style:UITableViewStylePlain];
    [self.savedTable setBackgroundColor:[Utiles colorWithHexString:@"#F3EFE1"]];
    self.savedTable.dataSource=self;
    self.savedTable.delegate=self;
    [self.view addSubview:self.savedTable];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.savedTable.bounds.size.height, self.view.frame.size.width, self.savedTable.bounds.size.height)];
        
        view.delegate = self;
        [self.savedTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    _count=0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SAFE_RELEASE(board);
}

-(void)getSavedStockList{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[comInfo objectForKey:@"stockcode"],@"stockcode",[Utiles getUserToken],@"token",@"googuu",@"from", nil];
    [Utiles getNetInfoWithPath:@"AdjustedData" andParams:params besidesBlock:^(id resObj){
        if(resObj!=nil){
            self.savedStockList=[resObj objectForKey:@"data"];
            [self.savedTable reloadData];
            if(_count==1){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                _count=0;
            }else{
                _count++;
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        //[Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)getChartJsonData{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[comInfo objectForKey:@"stockcode"],@"stockCode", nil];
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        self.jsonForChart=[resObj JSONString];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        disViewController=[[DiscountRateViewController alloc] init];
        disViewController.jsonData=self.jsonForChart;
        disViewController.view.frame=CGRectMake(0,0,SCREEN_HEIGHT,SCREEN_WIDTH);
        if(_count==1){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _count=0;
        }else{
            _count++;
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}


#pragma mark -
#pragma mark Table Data Source Methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.savedStockList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SavedStockCellIdentifier = @"SavedStockCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SavedStockCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:SavedStockCellIdentifier];
    }
    
    id info=[self.savedStockList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[info objectForKey:@"itemname"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chartViewController=[[ChartViewController alloc] init];
    chartViewController.sourceType=self.browseType;
    chartViewController.globalDriverId=[[self.savedStockList objectAtIndex:indexPath.row] objectForKey:@"itemcode"];
    chartViewController.view.frame=CGRectMake(0,0,SCREEN_HEIGHT,SCREEN_WIDTH);
    if([[[self.savedStockList objectAtIndex:indexPath.row] objectForKey:@"data"] count]==1){
        chartViewController.wantSavedType=DiscountSaved;
    }else{
        chartViewController.wantSavedType=ChartSaved;
    }    
    [self presentViewController:chartViewController animated:YES completion:nil];    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UIButton *)addNewButton:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect{
    UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt1.frame = rect;
    [bt1 setTitle:title forState: UIControlStateNormal];
    [bt1 setBackgroundColorString:@"#C96125" forState:UIControlStateNormal];
    [bt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt1 setBackgroundImage:[UIImage imageNamed:@"valueModelBt"] forState:UIControlStateNormal];
    bt1.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
    bt1.tag = tag;
    [bt1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt1];
    return bt1;
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(change.x<-100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
    }
}

-(void)buttonClicked:(UIButton *)bt{
    [self removeTextField];
    if(bt.tag==1){
        FinancalModelChartViewController *model=[[FinancalModelChartViewController alloc] init];
        [self presentViewController:model animated:YES completion:nil];
        SAFE_RELEASE(model);
    }else if(bt.tag==2){
        chartViewController=[[ChartViewController alloc] init];
        chartViewController.sourceType=self.browseType;
        chartViewController.view.frame=CGRectMake(0,0,SCREEN_HEIGHT,SCREEN_WIDTH);
        [self presentViewController:chartViewController animated:YES completion:nil];
    }else if(bt.tag==3){
        DahonValuationViewController *dahon=[[DahonValuationViewController alloc] init];
        [self presentViewController:dahon animated:YES completion:nil];
    }else if(bt.tag==4){
        FinanceDataViewController *finData=[[FinanceDataViewController alloc] init];
        [self presentViewController:finData animated:YES completion:nil];
    }else if(bt.tag==AttentionAction){
        
        if ([Utiles isLogin]) {
            [self attentionAction];
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
        }
    
        
    }else if(bt.tag==AddComment){
        if ([Utiles isLogin]) {
            [self addTextField];
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
        }
     
    }else if(bt.tag==AddShare){
        
    }
    
}

#pragma mark -
#pragma mark Text Field Methods Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(![Utiles isBlankString:[self.inputField text]]){
        [self removeTextField];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[comInfo objectForKey:@"stockcode"],@"stockcode",inputField.text,@"msg",[Utiles getUserToken],@"token",@"googuu",@"from",nil];
        [Utiles postNetInfoWithPath:@"CompanyReview" andParams:params besidesBlock:^(id obj){
            if([[obj objectForKey:@"status"] isEqualToString:@"1"]){
                self.inputField.text=@"";
                [self.tabController setSelectedIndex:3 animated:YES];
            }else{
                [Utiles ToastNotification:@"发布失败" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }else{
        [Utiles ToastNotification:@"请填写内容" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
    }
    
    return YES;
}

-(void)attentionAction{

    NSString *url=nil;
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",[comInfo objectForKey:@"stockcode"],@"stockcode", nil];
    if(isAttention){
        url=@"DeleteAttention";
    }else{
        url=@"AddAttention";
    }
    
    [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id resObj){
        
        if(![[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
        }else if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            if([url isEqualToString:@"AddAttention"]){
                isAttention=YES;
                [attentionBt setBackgroundImage:[UIImage imageNamed:@"deleteAttentionBt"] forState:UIControlStateNormal];
                [Utiles ToastNotification:@"已成功关注" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            }else if([url isEqualToString:@"DeleteAttention"]){
                isAttention=NO;
                [attentionBt setBackgroundImage:[UIImage imageNamed:@"addAttentionBt"] forState:UIControlStateNormal];
                [Utiles ToastNotification:@"已取消关注" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];

}

-(void)getConcernStatus{
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from", nil];
    [Utiles postNetInfoWithPath:@"AttentionData" andParams:params besidesBlock:^(id resObj){
        if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
            NSArray *temp=[resObj objectForKey:@"data"];
            for(id obj in temp){
                if([[obj objectForKey:@"stockcode"] isEqual:[comInfo objectForKey:@"stockcode"]]){
                    isAttention=YES;
                    [self.attentionBt setBackgroundImage:[UIImage imageNamed:@"deleteAttentionBt"] forState:UIControlStateNormal];
                    break;
                }
            }
        }else{
            [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            isAttention=NO;
            [self.attentionBt setBackgroundImage:[UIImage imageNamed:@"addAttentionBt"] forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        //[Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    [self.chartViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(NSUInteger)supportedInterfaceOrientations{

    if([self isKindOfClass:NSClassFromString(@"ModelViewController")])
        return UIInterfaceOrientationMaskPortrait;

    return [self.chartViewController supportedInterfaceOrientations];
}

#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    [self getSavedStockList];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.savedTable];
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

- (BOOL)shouldAutorotate{
    //NSLog(@"%s",__FUNCTION__);
    return [self.chartViewController shouldAutorotate];
}

























@end
