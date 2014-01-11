//
//  AnalyDetailViewController.m
//  估股
//
//  Created by Xcode on 13-7-24.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AnalyDetailViewController.h"
#import "UILabel+VerticalAlign.h"
#import "PrettyToolbar.h"
#import "AnalyDetailContainerViewController.h"

@interface AnalyDetailViewController ()

@end

@implementation AnalyDetailViewController

@synthesize articleId;
@synthesize top;
@synthesize myToolBarItems;
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
	// Do any additional setup after loading the view.
    container=[[AnalyDetailContainerViewController alloc] init];
    container.articleId=self.articleId;
    container.view.frame=CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height-30);
    
    [self.view addSubview:container.view];
    [self addChildViewController:container];
    
    [self addToolBar];
}

-(void)addToolBar{
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    top=[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    myToolBarItems=[[NSMutableArray alloc] init];
    [myToolBarItems addObject:back];
    [top setItems:myToolBarItems];
    UILabel *companyNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
    [companyNameLabel setBackgroundColor:[UIColor clearColor]];
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    id comInfo=delegate.comInfo;
    [companyNameLabel setText:[comInfo objectForKey:@"companyname"]];
    [companyNameLabel setTextAlignment:NSTextAlignmentCenter];
    [companyNameLabel setTextColor:[Utiles colorWithHexString:@"#2E71FA"]];
    [top addSubview:companyNameLabel];
    SAFE_RELEASE(companyNameLabel);
    [self.view addSubview:top];
    [back release];
    [top release];
    
}

-(void)back:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
