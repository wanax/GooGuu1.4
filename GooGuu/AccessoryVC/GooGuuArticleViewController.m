//
//  GooGuuArticleViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuArticleViewController.h"
#import "UIImageView+WebCache.h"
#import "CXPhotoBrowser.h"
#import "CXPhoto.h"
#import "AddCommentViewController.h"
#import "ArticleCommentViewController.h"
#import "GooGuuCommentListVC.h"
#import "GGModelIndexVC.h"
#import "ComFieldViewController.h"
#import "ExpectedSpaceViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareSDK/SSInheritValue.h"

@interface GooGuuArticleViewController ()

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end

@implementation GooGuuArticleViewController


- (id)initWithModel:(id)model andType:(GooGuuArticleType)type
{
    self = [super init];
    if (self) {
        self.articleInfo = model;
        self.sourceType = type;
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.photoDataSource = temp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.articleInfo[@"companyname"]!=nil) {
        self.title = self.articleInfo[@"companyname"];
    }else if (self.articleInfo[@"title"]!=nil) {
        self.title = self.articleInfo[@"title"];
    }

    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    CXPhotoBrowser *tempBrowser = [[[CXPhotoBrowser alloc] initWithDataSource:self delegate:self] autorelease];
    self.browser = tempBrowser;
    
    [self initComponts];
    [self getArticleContent];
}

-(void)favBtClicked:(UIBarButtonItem *)bt {
    
    NSString *url = @"";
    if ([bt.title isEqualToString:@"收藏"]) {
        url = @"AddFavArticle";
    } else {
        url = @"CancelFavArticle";
    }
    NSDictionary *params = @{
                             @"articleid":self.articleId,
                             @"token":[Utiles getUserToken],
                             @"from":@"googuu",
                             @"state":@"1"
                             };
    [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id obj) {
 
        if ([obj[@"status"] isEqualToString:@"1"]) {
            if ([bt.title isEqualToString:@"收藏"]) {
                bt.title = @"取消收藏";
            } else {
                bt.title = @"收藏";
            }
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:obj[@"msg"] duration:1.5];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)initComponts {
    
    UIWebView *tempWeb = [[[UIWebView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH, SCREEN_HEIGHT-74)] autorelease];
    self.articleWeb = tempWeb;
    self.articleWeb.delegate=self;

    UIBarButtonItem *favButton = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self  action:@selector(favBtClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = favButton;
    
    if ([Utiles isLogin]) {
        NSDictionary *params = @{
                                 @"token":[Utiles getUserToken],
                                 @"from":@"googuu",
                                 @"state":@"1"
                                 };
        [Utiles getNetInfoWithPath:@"FavoriteArticles" andParams:params besidesBlock:^(id obj) {
            
            NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
            id data = obj[@"data"];
            for (id model in data) {
                [temp addObject:model[@"title"]];
            }
            if ([temp containsObject:self.articleInfo[@"title"]]) {
                favButton.title = @"取消收藏";
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
    if (self.articleInfo[@"stockcode"]!=nil&&self.articleInfo[@"stockcode"]!= [NSNull null]) {
        [self addButton:CGRectMake(0,SCREEN_HEIGHT-30,80,30) title:@"公司" image:@"icon_company_small"];
        [self addButton:CGRectMake(80,SCREEN_HEIGHT-30,80,30) title:@"分享" image:@"icon_share_small"];
        [self addButton:CGRectMake(160,SCREEN_HEIGHT-30,80,30) title:@"评论" image:@"icon_msg_small"];
        [self addButton:CGRectMake(240,SCREEN_HEIGHT-30,80,30) title:@"多空" image:@"icon_pie_small"];
    }else{
        [self addButton:CGRectMake(0,SCREEN_HEIGHT-30,160,30) title:@"分享" image:@"icon_share_small"];
        [self addButton:CGRectMake(160,SCREEN_HEIGHT-30,160,30) title:@"评论" image:@"icon_msg_small"];
    }
}

-(void)addButton:(CGRect)frame title:(NSString *)title image:(NSString *)url{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = frame;
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
    bt.backgroundColor = [UIColor cloudsColor];
    [bt setImage:[UIImage imageNamed:url] forState:UIControlStateNormal];
    [bt setImageEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
    [bt setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTintColor:[UIColor peterRiverColor]];
    [bt addTarget:self action:@selector(actionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
}

#pragma mark -
#pragma mark Buttons Clicks

-(void)actionBtClicked:(UIButton *)bt {
    
    if ([bt.titleLabel.text isEqual:@"评论"]) {
        if (self.articleInfo[@"stockcode"]!=nil&&self.articleInfo[@"stockcode"]!= [NSNull null]) {
            GooGuuCommentListVC *comVC = [[[GooGuuCommentListVC alloc] initWithTopical:self.articleInfo[@"stockcode"] type:CompanyComment] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
        } else {

            GooGuuCommentListVC *comVC = [[[GooGuuCommentListVC alloc] initWithTopical:self.articleId type:GGViewComment] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
        }
       
        
    } else if ([bt.titleLabel.text isEqual:@"公司"]) {
        NSDictionary *params = @{
                                 @"stockcode":self.articleInfo[@"stockcode"]
                                 };
        [Utiles getNetInfoWithPath:@"GetCompanyInfo" andParams:params besidesBlock:^(id obj) {
            
            GGModelIndexVC *modelIndexVC = [[[GGModelIndexVC alloc] initWithNibName:@"GGModelIndexView" bundle:nil] autorelease];
            modelIndexVC.companyInfo = obj;
            UINavigationController *navModel = [[[UINavigationController alloc] initWithRootViewController:modelIndexVC] autorelease];
            [self presentViewController:navModel animated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else if ([bt.titleLabel.text isEqual:@"多空"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@""
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"历史多空统计"
                                      otherButtonTitles:@"看多", @"看空", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet release];
    } else if ([bt.titleLabel.text isEqual:@"分享"]) {

        NSString *content = @"";
        NSString *imgURL = nil;
        NSString *webURL = [NSString stringWithFormat:@"http://www.googuu.net/pages/content/view/%@.htm",self.articleId];;
        if ([self.articleInfo[@"concise"] length] > 90) {
            content = [NSString stringWithFormat:@"%@...",[self.articleInfo[@"concise"] substringToIndex:86]];
        } else {
            content = self.articleInfo[@"concise"];
        }
        if (self.sourceType == HotReport || self.sourceType == HotView) {
            content = [NSString stringWithFormat:@"%@%@",content,webURL];
        } else if (self.sourceType == CommentReport || self.sourceType == CommentView) {
            NSArray *arr = [self.articleInfo[@"replycontent"] split:@"<br/>"];
            content = [NSString stringWithFormat:@"%@%@",arr[0],webURL];
        } else if (self.sourceType == ReportArticle) {
            content = [NSString stringWithFormat:@"%@%@",content,webURL];
        } else if (self.sourceType == ViewArticle) {
            imgURL = self.articleInfo[@"titleimgurl"];
            content = [NSString stringWithFormat:@"%@%@",content,webURL];
        }

        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@""
                                                    image:(imgURL == nil?nil:[ShareSDK imageWithUrl:imgURL])
                                                    title:@"估股分享"
                                                      url:nil
                                              description:@""
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //定制微信好友信息
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:content
                                               title:@"估股分享"
                                                 url:webURL
                                          thumbImage:(imgURL == nil?nil:[ShareSDK imageWithUrl:imgURL])
                                               image:INHERIT_VALUE
                                        musicFileUrl:nil
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
        //微信朋友圈
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
        [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                              content:nil
                                                title:self.articleInfo[@"title"]
                                                  url:webURL
                                           thumbImage:(imgURL == nil?[ShareSDK imageWithPath:imagePath]:[ShareSDK imageWithUrl:imgURL])
                                                image:INHERIT_VALUE
                                         musicFileUrl:nil
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];

        id<ISSContainer> container = [ShareSDK container];
        [container setIPhoneContainerWithViewController:self];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        //创建自定义分享列表
        NSArray *shareList = [ShareSDK customShareListWithType:
                              SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                              SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                              SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                              nil];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [ProgressHUD showSuccess:@"分享成功"];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"%i", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            //多空统计
            ExpectedSpaceViewController *expectVC = [[[ExpectedSpaceViewController alloc] init] autorelease];
            expectVC.stockCode = self.articleInfo[@"stockcode"];
            [self presentViewController:expectVC animated:YES completion:nil];
            break;
        }
        case 1: {
            //看多
            NSDictionary *params = @{
                                     @"stockcode":self.articleInfo[@"stockcode"],
                                     @"flag":@"1",
                                     @"from":@"googuu",
                                     @"token":[Utiles getUserToken],
                                     @"state":@"1"
                                     };
            [Utiles postNetInfoWithPath:@"ExpectedSpaceVote" andParams:params besidesBlock:^(id obj) {
                
                if ([obj[@"status"] isEqualToString:@"1"]) {
                    [ProgressHUD showSuccess:@"投票成功"];
                } else {
                    [ProgressHUD showError:obj[@"msg"]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];

            break;
        }
        case 2: {
            //看空
            [self voteForCompany:@"2"];
            break;
        }
    }
}

-(void)voteForCompany:(NSString *) updown{
    NSDictionary *params = @{
                             @"stockcode":self.articleInfo[@"stockcode"],
                             @"flag":updown,
                             @"from":@"googuu",
                             @"token":[Utiles getUserToken],
                             @"state":@"1"
                             };
    [Utiles postNetInfoWithPath:@"ExpectedSpaceVote" andParams:params besidesBlock:^(id obj) {
        
        if ([obj[@"status"] isEqualToString:@"1"]) {
            [ProgressHUD showSuccess:@"投票成功"];
        } else {
            [ProgressHUD showError:obj[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)addCommentBtClicked{
    if ([Utiles isLogin]) {
        AddCommentViewController *addCommentViewController=[[[AddCommentViewController alloc] init] autorelease];
        addCommentViewController.type = ArticleReview;
        addCommentViewController.articleId = self.articleId;
        [self presentViewController:addCommentViewController animated:YES completion:nil];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
    }
}

-(void)comeIntoComBtClicked:(UIButton *)sender{
    ComFieldViewController *com=[[[ComFieldViewController alloc] init] autorelease];
    com.browseType=SearchStockList;
    com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self presentViewController:com animated:YES completion:nil];
}


-(void)getArticleContent {

    NSDictionary *params = @{
                             @"articleid":self.articleId
                             };
    
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){

        [self.articleWeb loadHTMLString:article[@"content"] baseURL:nil];
        self.articleContent = article[@"content"];
        [self addTapOnWebView];
        [self.view addSubview:self.articleWeb];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //文章文字大小
    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%dpx'",12];
    NSString *imgSize=[[NSString alloc] initWithFormat:@"var temp = document.getElementsByTagName(\"img\");\
                       for (var i = 0; i < temp.length; i ++) {\
                       temp[i].style.width = '300px';\
                       temp[i].style.height = '200px';\
                       }"];
    NSString *urlStr=[self.articleWeb stringByEvaluatingJavaScriptFromString:@"var str=\"\";\
                   function imgUrl(){\
                   var temp = document.getElementsByTagName(\"img\");\
                   for (var i = 0; i < temp.length; i ++) {\
                       str+=temp[i].src+\"|\";\
                   }\
                   return str;\
                   }\
                   imgUrl();"];
    NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:[urlStr componentsSeparatedByString:@"|"]];
    [tempArr removeLastObject];
    self.imageUrlList=tempArr;
    for (id obj in self.imageUrlList) {
        CXPhoto *photo = nil;
        photo = [[[CXPhoto alloc] initWithURL:[NSURL URLWithString:obj]] autorelease];
        [self.photoDataSource addObject:photo];
    }
    [self.articleWeb stringByEvaluatingJavaScriptFromString:botySise];
    [self.articleWeb stringByEvaluatingJavaScriptFromString:imgSize];
    SAFE_RELEASE(botySise);
    SAFE_RELEASE(imgSize);
    SAFE_RELEASE(tempArr);
}



-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.articleWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.articleWeb];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.articleWeb stringByEvaluatingJavaScriptFromString:imgURL];

    if (urlToSave.length > 0) {   
        [self presentViewController:self.browser animated:YES completion:^{
            
        }];
    }
}
#pragma mark -
#pragma mark CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    [self.imageTitleLabel setText:[NSString stringWithFormat:@"%d/%d",(index+1),[self.imageUrlList count]]];
}

#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)] autorelease];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
        [doneButton setTitle:NSLocalizedString(@"返回",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 5, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        doneButton.layer.borderColor = [[UIColor whiteColor] CGColor];

        [navBarView addSubview:doneButton];
        
        self.imageTitleLabel = [[[UILabel alloc] init] autorelease];
        [self.imageTitleLabel setFrame:CGRectMake((size.width - 60)/2, 10, 60, 40)];
        [self.imageTitleLabel setCenter:navBarView.center];
        [self.imageTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.imageTitleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [self.imageTitleLabel setTextColor:[UIColor whiteColor]];
        [self.imageTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.imageTitleLabel setText:@""];
        self.imageTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.imageTitleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:self.imageTitleLabel];
    }
    
    return navBarView;
}

#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate{
    return NO;
}




















@end
