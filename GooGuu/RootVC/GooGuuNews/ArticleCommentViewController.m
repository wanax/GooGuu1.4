//
//  ArticleCommentViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ArticleCommentViewController.h"
#import "UserCell.h"
#import "MHTabBarController.h"
#import "UIImageView+AFNetworking.h"
#import "AddCommentViewController.h"
#import "PrettyKit.h"
#import "AnalyDetailViewController.h"
#import "DrawChartTool.h"

@interface ArticleCommentViewController ()

@end

@implementation ArticleCommentViewController

@synthesize articleId;
@synthesize cusTable;
@synthesize commentArr;
@synthesize type;

- (void)dealloc
{
    [commentArr release];
    [cusTable release];
    [articleId release];
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
    if([Utiles isLogin]){
        if(self.type==StockCompany){
            NSMutableArray *arr=[(AnalyDetailViewController *)self.parentViewController.parentViewController.parentViewController myToolBarItems];
            [arr removeLastObject];
            UIToolbar *toolBar=[(AnalyDetailViewController *)self.parentViewController.parentViewController.parentViewController top];
            [toolBar setItems:[NSArray arrayWithArray:arr] animated:YES];
        }
    }
  
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if([Utiles isLogin]){
        if(self.type==News){
            
            UIBarButtonItem *wanSay=[[UIBarButtonItem alloc] initWithTitle:@"添加评论" style:UIBarButtonItemStyleBordered target:self action:@selector(wanSay:)];
            
            [self.parentViewController.navigationItem setRightBarButtonItem:wanSay animated:YES];
            
        }else if(self.type==StockCompany){
            NSAssert(self.type==StockCompany,@"Analy Report");
            
            UIButton *wanSay= [[UIButton alloc] initWithFrame:CGRectMake(280, 10.0, 40, 30.0)];
            [wanSay setTitle:@"添加评论" forState:UIControlStateNormal];
            [wanSay.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
            [wanSay setTitleColor:[Utiles colorWithHexString:@"#307DF9"] forState:UIControlStateNormal];
            [wanSay addTarget:self action:@selector(wanSay:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *nextStepBarBtn = [[UIBarButtonItem alloc] initWithCustomView:wanSay];
            [nextStepBarBtn setWidth:455];
            
            NSMutableArray *arr=[(AnalyDetailViewController *)self.parentViewController.parentViewController.parentViewController myToolBarItems];
            [arr addObject:nextStepBarBtn];
            
            UIToolbar *toolBar=[(AnalyDetailViewController *)self.parentViewController.parentViewController.parentViewController top];
            [toolBar setItems:[NSArray arrayWithArray:arr] animated:YES];
            [wanSay release];
            [self.cusTable reloadData];
        }
    }
  
    [self getComment];
    
}

-(void)wanSay:(id)sender{
    AddCommentViewController *addCommentViewController=[[AddCommentViewController alloc] initWithNibName:@"AddCommentView" bundle:nil];
    addCommentViewController.articleId=self.articleId;
    
    if(self.type==News){
        addCommentViewController.type=NewsType;
        [(UINavigationController *)self.parentViewController.parentViewController pushViewController:addCommentViewController animated:YES];
    }else{
        NSAssert(self.type==StockCompany,@"Should be articel");
        addCommentViewController.type=ArticleType;
        [self presentViewController:addCommentViewController animated:YES completion:nil];
    }
    
    [addCommentViewController release];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nibsRegistered=NO;

    
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-75) style:UITableViewStylePlain];
    [self.cusTable setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    self.cusTable.dataSource=self;
    self.cusTable.delegate=self;
    [self.view addSubview:cusTable];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.cusTable.bounds.size.height, self.view.frame.size.width, self.cusTable.bounds.size.height)];
        
        view.delegate = self;
        [self.cusTable addSubview:view];
        _refreshHeaderView = view;
        
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self getComment];
  
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    
    if(change.x>FINGERCHANGEDISTANCE){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
    }
}

-(void)getComment{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"Commentary" andParams:params besidesBlock:^(id resObj){
        self.commentArr=resObj;
        
        [self.cusTable reloadData];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.cusTable];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma mark Table Data Source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentArr count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *UserCellIdentifier = @"UserCellIdentifier";
    
    if(!nibsRegistered){
        UINib *nib=[UINib nibWithNibName:@"UserCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:UserCellIdentifier];
        nibsRegistered = YES;
    }
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    if (cell == nil) {
        cell = [[UserCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:UserCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSAssert([self.commentArr count]>=row,@"index bound");
    id model=[self.commentArr objectAtIndex:row];
    
    cell.name = [model objectForKey:@"author"];
    cell.decLabel.text = [model objectForKey:@"content"];
    cell.loc = [model objectForKey:@"updatetime"];
    
    DrawChartTool *tool=[[[DrawChartTool alloc] init] autorelease];
    CGSize size =[tool getLabelSizeFromString:[[self.commentArr objectAtIndex:indexPath.row] objectForKey:@"content"] font:@"Heiti SC" fontSize:12.0];

    cell.decLabel.lineBreakMode=NSLineBreakByCharWrapping;
    cell.decLabel.numberOfLines=0;
    [cell.decLabel setFrame:CGRectMake(73, 27, 235, size.height+50)];
    
    @try {
        if([[NSString stringWithFormat:@"%@",[model objectForKey:@"headerpicurl"]] length]>7){
            //异步加载cell图片
        [cell.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[model objectForKey:@"headerpicurl"]]]
          placeholderImage:[UIImage imageNamed:@"pumpkin.png"]
                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                       cell.image = image;
                       
                   }
                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                       
                   }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return cell;
}



#pragma mark -
#pragma mark Table Methods Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font =[UIFont fontWithName:@"Heiti SC" size:12.0];
    DrawChartTool *tool=[[[DrawChartTool alloc] init] autorelease];
    CGSize size =[tool getLabelSizeFromString:[[self.commentArr objectAtIndex:indexPath.row] objectForKey:@"content"] font:@"Heiti SC" fontSize:12.0];
    return size.height+80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //[Utiles showToastView:self.view withTitle:@"用户评论" andContent:[[self.commentArr objectAtIndex:indexPath.row] objectForKey:@"content"] duration:2.0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    
    [self getComment];
    [self.cusTable reloadData];
    
    _reloading = NO;
    
    //[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotate{
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskPortrait;
}






















@end
