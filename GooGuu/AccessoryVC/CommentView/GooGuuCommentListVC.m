//
//  GooGuuCommentList.m
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "GooGuuCommentListVC.h"
#import "ClientCommentCell.h"
#import "RegexKitLite.h"
#import "SVPullToRefresh.h"
#import "AddCommentViewController.h"
#import "CommentDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GooGuuCommentListVC ()

@end

@implementation GooGuuCommentListVC

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type
{
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
    }
    return self;
}
//公司评论列表初始化
- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type stockCode:(NSString *)stockCode {
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
        self.stockCode = stockCode;
    }
    return self;
}
//文章评论列表初始化
- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type articleId:(NSString *)articleId {
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
        self.articleId = articleId;
    }
    return self;
}
//个人评论列表初始化
- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type userName:(NSString *)userName {
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
        self.userName = userName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.topical;
	[self initComponents];
    [self getComments];
}

-(void)initComponents {
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    temp.delegate = self;
    temp.dataSource = self;
    temp.showsVerticalScrollIndicator = NO;
    self.commentTable = temp;
    [self.view addSubview:self.commentTable];

    UIRefreshControl *tempRefresh = [[[UIRefreshControl alloc] init] autorelease];
    tempRefresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [tempRefresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = tempRefresh;
    [self.commentTable addSubview:self.refreshControl];
    
    if (self.type != TargetUserComment) {
        UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self  action:@selector(sendBtClicked:)] autorelease];
        self.navigationItem.rightBarButtonItem = sendButton;
    }
}

-(void)handleRefresh:(UIRefreshControl *)control {
    control.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新中"] autorelease];
    [control endRefreshing];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    [self getComments];
    
}

#pragma mark -
#pragma NetConection

-(void)getComments{
    
    NSString *url = @"";
    NSDictionary *params = nil;
    
    if (self.type == CompanyComment) {
        url = @"CompanyCommentURL";
        params = @{
                   @"stockcode":self.stockCode
                   };
    } else if (self.type == GGViewComment || self.type == ArticleComment) {
        url = @"Commentary";
        params = @{
                   @"articleid":self.articleId
                   };
    } else if (self.type == TargetUserComment) {
        url = @"TargetUserComment";
        params = @{
                   @"username":self.userName
                   };
    }

    [Utiles getNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temps = [[[NSMutableArray alloc] init] autorelease];
        for (id model in obj) {
            [temps addObject:model];
        }
        self.commentList = temps;
        [self.commentTable reloadData];
        [self.commentTable.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark -
#pragma Table DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSArray *arr = [self.commentList[indexPath.row][@"content"] split:@"<br/>"];
    CGSize size = [Utiles getLabelSizeFromString:arr[0] font:[UIFont fontWithName:@"Heiti SC" size:14.0] width:310];
    float height = [arr[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:14.0]}].height;
    int lines = size.height/height + 3;
    size.height = size.height + 8*lines;
    
    if ([arr count] > 1) {
        return size.height + 95;
    } else {
        return size.height + 52;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ClientCommentCellIdentifier = @"ClientCommentCellIdentifier";
    
    ClientCommentCell *cell = (ClientCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    id model = self.commentList[indexPath.row];
    
    if (cell == nil) {
        cell = [[[ClientCommentCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:ClientCommentCellIdentifier] autorelease];
    }
    
    NSArray *arr = [model[@"content"] split:@"<br/>"];
    
    if (self.type == TargetUserComment) {
        cell.content = arr[0];
        cell.userName = [Utiles isBlankString:model[@"companyname"]]?@"":model[@"companyname"];
        cell.artTitle = [Utiles isBlankString:model[@"title"]]?@"":model[@"title"];
        cell.avaURL = model[@"headerpicurl"];
    } else {
        cell.content = arr[0];
        cell.userName = model[@"author"];
        NSString *reg = @"(\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b)|(\\d{8,13})";
        if ([model[@"username"] isMatchedByRegex:reg]) {
            NSString *temp = model[@"username"];
            NSString *temp1 = [temp substringToIndex:3];
            NSString *temp2 = [temp substringFromIndex:[temp length]-3];
            cell.artTitle = [NSString stringWithFormat:@"%@***%@",temp1,temp2];
        } else {
            cell.artTitle = model[@"username"];
        }
        cell.updateTime = [Utiles intervalSinceNow:model[@"updatetime"]];
        cell.avaURL = model[@"headerpicurl"];
    }
 
    //添加评论缩略图
    if ([arr count] > 1) {
        NSString *regexString  = @"\\bhttp.{60,75}((.gif)|(.jpg)|(.jpeg)|(.bmp)|(.png)|(.GIF)|(.JPG)|(.PNG)|(.BMP))\\b";
        NSArray  *matchArray  = [[arr lastObject] componentsMatchedByRegex:regexString];
        cell.thumbnailsURL = matchArray;
    }
    
    return cell;
}



#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *commentId = nil;
    if (self.type == TargetUserComment) {
        commentId = self.commentList[indexPath.row][@"id"];
    } else {
        commentId = self.commentList[indexPath.row][@"rid"];
    }
    CommentDetailViewController *detailVC = [[[CommentDetailViewController alloc] initWithCommentId:commentId] autorelease];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark -
#pragma UIControl Action

-(void)sendBtClicked:(UIBarButtonItem *)bt {
    
    if ([Utiles isLogin]) {
        AddCommentViewController *addCommentViewController = nil;
        if (self.type == CompanyComment) {
            addCommentViewController = [[[AddCommentViewController alloc] initWithArg:self.stockCode type:CompanyComment] autorelease];
        } else {
            addCommentViewController = [[[AddCommentViewController alloc] initWithArg:self.articleId type:CompanyComment] autorelease];
        }
        [self presentViewController:addCommentViewController animated:YES completion:nil];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
    }
    
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
