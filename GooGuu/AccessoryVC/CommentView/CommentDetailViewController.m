//
//  CommentDetailViewController.m
//  GooGuu
//
//  Created by Xcode on 14-2-25.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface CommentDetailViewController ()

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end

@implementation CommentDetailViewController

- (id)initWithCommentId:(NSString *)id
{
    self = [super init];
    if (self) {
        self.commentId = id;
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.photoDataSource = temp;
        self.isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    CXPhotoBrowser *tempBrowser = [[[CXPhotoBrowser alloc] initWithDataSource:self delegate:self] autorelease];
    self.browser = tempBrowser;

	[self getCommentDetail];
}


-(void)getCommentDetail {

    NSDictionary *params = @{
                             @"id":self.commentId
                             };
    [Utiles getNetInfoWithPath:@"CommentDetail" andParams:params besidesBlock:^(id obj) {

        UIWebView *tempWeb = [[[UIWebView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
        self.commentWeb = tempWeb;
        self.commentWeb.backgroundColor = [UIColor whiteColor];
        self.commentWeb.delegate = self;

        NSString *regStr = @"(<a href=.{10,110}_blank\">)|(</a>)";
        NSString *resultStr = [obj[@"data"] stringByReplacingOccurrencesOfRegex:regStr withString:@""];
        
        [self.commentWeb loadHTMLString:resultStr baseURL:nil];
        [self addTapOnWebView];
        [self.view addSubview:self.commentWeb];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{

    //文章文字大小
    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('p')[0].style.fontSize='%dpx'",15];
    NSString *imgSize=[[NSString alloc] initWithFormat:@"var temp = document.getElementsByTagName(\"img\");\
                       for (var i = 0; i < temp.length; i ++) {\
                       temp[i].style.width = '300px';\
                       temp[i].style.height = '200px';\
                       }"];
    NSString *urlStr=[self.commentWeb stringByEvaluatingJavaScriptFromString:@"var str=\"\";\
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
    [self.commentWeb stringByEvaluatingJavaScriptFromString:botySise];
    [self.commentWeb stringByEvaluatingJavaScriptFromString:imgSize];
    SAFE_RELEASE(botySise);
    SAFE_RELEASE(imgSize);
    SAFE_RELEASE(tempArr);
}



-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.commentWeb addGestureRecognizer:singleTap];
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
    CGPoint pt = [sender locationInView:self.commentWeb];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.commentWeb stringByEvaluatingJavaScriptFromString:imgURL];
    
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
    [self dismissViewControllerAnimated:YES completion:^{
        self.commentWeb.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate{
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
