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
#import "ComFieldViewController.h"

@interface GooGuuArticleViewController ()

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end

@implementation GooGuuArticleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.photoDataSource = temp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.articleInfo[@"companyname"];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    CXPhotoBrowser *tempBrowser = [[[CXPhotoBrowser alloc] initWithDataSource:self delegate:self] autorelease];
    self.browser = tempBrowser;
    
    [self initComponts];
    [self getArticleContent];
}


-(void)initComponts {
    
    UIWebView *tempWeb = [[[UIWebView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH, SCREEN_HEIGHT-74)] autorelease];
    self.articleWeb = tempWeb;
    self.articleWeb.delegate=self;

    [self addButton:CGRectMake(0,SCREEN_HEIGHT-30,80,30) title:@"公司" image:@"icon_company_small"];
    [self addButton:CGRectMake(80,SCREEN_HEIGHT-30,80,30) title:@"分享" image:@"icon_share_small"];
    [self addButton:CGRectMake(160,SCREEN_HEIGHT-30,80,30) title:@"评论" image:@"icon_msg_small"];
    [self addButton:CGRectMake(240,SCREEN_HEIGHT-30,80,30) title:@"多空" image:@"icon_pie_small"];
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
    
}

-(void)addCommentBtClicked{
    if ([Utiles isLogin]) {
        AddCommentViewController *addCommentViewController=[[[AddCommentViewController alloc] init] autorelease];
        addCommentViewController.type=ArticleType;
        addCommentViewController.articleId = self.articleInfo[@"articleid"];
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
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleInfo[@"articleid"],@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){

        [self.articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];
        
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
