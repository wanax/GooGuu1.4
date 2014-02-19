//
//  GuestCommentViewController.h
//  welcom_demo_1
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-用户评论

#import "GuestCommentViewController.h"
#import "UserCell.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "UIImageView+AFNetworking.h"
#import "MHTabBarController.h"
#import "EGORefreshTableHeaderView.h"
#import "ComFieldViewController.h"
#import "AddCommentViewController.h"
#import "PrettyKit.h"
#import "ComfieldTabelDataSource.h"

static NSString * const UserCellIdentifier = @"UserCellIdentifier";


@interface GuestCommentViewController ()

@property (nonatomic, strong) ComfieldTabelDataSource *commentsArrayDataSource;

@end

@implementation GuestCommentViewController

@synthesize nibsRegistered;

@synthesize commentList;

@synthesize search;
@synthesize table;



- (void)dealloc
{
    SAFE_RELEASE(commentList);
    SAFE_RELEASE(search);
    SAFE_RELEASE(table);
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

    if([Utiles isLogin]){
        NSMutableArray *arr=[(ComFieldViewController *)self.parentViewController.parentViewController.parentViewController myToolBarItems];
        [arr removeLastObject];
        UIToolbar *toolBar=[(ComFieldViewController *)self.parentViewController.parentViewController.parentViewController top];
        [toolBar setItems:[NSArray arrayWithArray:arr] animated:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{

    if([Utiles isLogin]){
        UIButton *wanSay= [[UIButton alloc] initWithFrame:CGRectMake(280, 10.0, 40, 30.0)];
        [wanSay setTitle:@"添加评论" forState:UIControlStateNormal];
        [wanSay.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
        [wanSay setTitleColor:[Utiles colorWithHexString:@"#307DF9"] forState:UIControlStateNormal];

        [wanSay addTarget:self action:@selector(wanSay:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *nextStepBarBtn = [[UIBarButtonItem alloc] initWithCustomView:wanSay];
        [nextStepBarBtn setWidth:455];
      
        NSMutableArray *arr=[(ComFieldViewController *)self.parentViewController.parentViewController.parentViewController myToolBarItems];
        [arr addObject:nextStepBarBtn];
        
        UIToolbar *toolBar=[(ComFieldViewController *)self.parentViewController.parentViewController.parentViewController top];
        [toolBar setItems:[NSArray arrayWithArray:arr] animated:YES];
        [wanSay release];
        
    }
    [self.table reloadData];
}

-(void)wanSay:(id)sender{
    
    if ([Utiles isNetConnected]) {
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        id comInfo=delegate.comInfo;
        
        NSString *code=[NSString stringWithFormat:@"%@",[comInfo objectForKey:@"stockcode"]];
        
        AddCommentViewController *addCommentViewController=[[AddCommentViewController alloc] initWithNibName:@"AddCommentView" bundle:nil];
        addCommentViewController.articleId=code;
        addCommentViewController.type = CompanyReview;
        
        [self presentViewController:addCommentViewController animated:YES completion:nil];
        [addCommentViewController release];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }  
}

- (void)setupTableView
{    
    TableViewCellConfigureBlock configureCell = ^(UserCell *cell, id model) {
        [cell configureForCommentCell:model];
    };
    NSArray *models = self.commentList;
    self.commentsArrayDataSource = [[ComfieldTabelDataSource alloc] initWithItems:models
                                                         cellIdentifier:UserCellIdentifier
                                                     configureCellBlock:configureCell];
    self.table.dataSource = self.commentsArrayDataSource;
    [self.table registerNib:[UserCell nib] forCellReuseIdentifier:UserCellIdentifier];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self getComments];
    self.table=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-70)];
    [self.table setBackgroundColor:[Utiles colorWithHexString:@"#EFEBD9"]];
    self.table.delegate=self;
    [self.view addSubview:self.table];
    [self setupTableView];
  
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        
        view.delegate = self;
        [self.table addSubview:view];
        _refreshHeaderView = view;
        
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    

    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    
    if(change.x>FINGERCHANGEDISTANCE){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
    }
}

-(void)getComments{
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    NSString *stockCode=[NSString stringWithFormat:@"%@",[delegate.comInfo objectForKey:@"stockcode"]];

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:stockCode,@"stockcode", nil];
    [Utiles postNetInfoWithPath:@"CompanyCommentURL" andParams:params besidesBlock:^(id obj){
        if([obj JSONString].length>5){
            self.commentList=obj;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
            [self setupTableView];
        }else{
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];

    
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [Utiles showToastView:self.view withTitle:@"用户评论" andContent:[[self.commentList objectAtIndex:indexPath.row] objectForKey:@"content"] duration:2.0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    
    [self getComments];
    [self setupTableView];
    
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

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}













@end
