//
//  tipViewController.h
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-04-10.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-04-10 | Wanax | 初次使用引导界面

#import "TipViewController.h"



@interface TipViewController ()

@end

@implementation TipViewController


#define HEIGHT SCREEN_HEIGHT
#define SAWTOOTH_COUNT 10
#define SAWTOOTH_WIDTH_FACTOR 20 

@synthesize imageView;
@synthesize left = _left;
@synthesize right = _right;
@synthesize pageScroll;
@synthesize pageControl;
@synthesize gotoMainViewBtn;

- (void)dealloc
{
    SAFE_RELEASE(imageView);
    SAFE_RELEASE(_left);
    SAFE_RELEASE(_right);
    SAFE_RELEASE(pageControl);
    SAFE_RELEASE(pageScroll);
    SAFE_RELEASE(gotoMainViewBtn);
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
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pageScroll.contentSize = CGSizeMake(4*320, SCREEN_HEIGHT);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:NO];
    
    self.gotoMainViewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.gotoMainViewBtn.frame = CGRectMake(137, 500, 127, 27);
    //[self.gotoMainViewBtn setTitle:@"Go In To" forState:UIControlStateNormal];
    [self.gotoMainViewBtn setBackgroundImage:[UIImage imageNamed:@"goinBt"] forState:UIControlStateNormal];
    [self.gotoMainViewBtn addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imageView.image = [UIImage imageNamed:@"guide4.png"];
    
    
    UIImageView * imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"guide1.png"];
    
    UIImageView * imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"guide2.png"];
    
    UIImageView * imageView3 = [[UIImageView alloc]init];
    imageView3.image = [UIImage imageNamed:@"guide3.png"];
    
    UIView * returnView = [[UIView alloc]init];
    returnView.backgroundColor = [UIColor whiteColor];
    [returnView addSubview:self.imageView];
    [returnView addSubview:self.gotoMainViewBtn];
    
    
    for(int i = 0; i < 5; ++ i )
    {
        if( i == 0 )
        {
            [pageScroll addSubview:imageView1];
            imageView1.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 1 )
        {
            [pageScroll addSubview:imageView2];
            imageView2.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 2 )
        {
            [pageScroll addSubview:imageView3];
            imageView3.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 3 )
        {
            returnView.frame = CGRectMake(i*320, 0, 320, HEIGHT);
            [pageScroll addSubview:returnView];
        }
    }
    
    [self.view addSubview:pageScroll];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(141,464,50,50);
    [pageControl setNumberOfPages:4];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
}


-(void)hide{
    UIApplication *app=[UIApplication sharedApplication];
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)gotoMainView:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstLaunch"];

    [self.pageControl setHidden:YES];
    [self.pageScroll setHidden:YES];
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    
    CATransition *animation =[CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATruncationMiddle;
    animation.subtype = kCATransitionFromRight;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [delegate application:nil didFinishLaunchingWithOptions:nil];
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGPoint offset = scrollView.contentOffset;
    pageControl.currentPage = offset.x/320;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // NSLog(@"scrollViewDidEndDecelerating");
    CGPoint offset = scrollView.contentOffset;
    pageControl.currentPage = offset.x / 320;
}


-(void)pageTurn:(UIPageControl*)aPageControl
{
    NSLog(@"pageTurn");
    /*
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    pageScroll.contentOffset = CGPointMake(320*whichPage, 0);
    [UIView commitAnimations];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end





































