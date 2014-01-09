//
//  AnalyDetailContainerViewController.m
//  估股
//
//  Created by Xcode on 13-7-24.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AnalyDetailContainerViewController.h"
#import "GooGuuArticleViewController.h"
#import "ArticleCommentViewController.h"
#import "MHTabBarController.h"
#import "CommonlyMacros.h"

@interface AnalyDetailContainerViewController ()

@end

@implementation AnalyDetailContainerViewController

@synthesize articleId;
@synthesize container;

- (void)dealloc
{
    SAFE_RELEASE(container);
    SAFE_RELEASE(articleId);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utiles iOS7StatusBar:self];
	// Do any additional setup after loading the view.
    GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
    articleViewController.articleId=self.articleId;
    articleViewController.title=@"公司简报";
    ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
    articleCommentViewController.articleId=self.articleId;
    articleCommentViewController.title=@"评论";
    articleCommentViewController.type=StockCompany;
    container=[[MHTabBarController alloc] init];
    NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
    container.viewControllers=controllers;
    [self.view addSubview:container.view];
    [self addChildViewController:container];
    SAFE_RELEASE(articleViewController);
    SAFE_RELEASE(articleCommentViewController);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
