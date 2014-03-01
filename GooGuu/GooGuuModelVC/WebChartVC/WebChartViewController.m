//
//  WebChartViewController.m
//  GooGuu
//
//  Created by Xcode on 14-2-26.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "WebChartViewController.h"

@interface WebChartViewController ()

@end

@implementation WebChartViewController

- (id)initWithCode:(NSString *)code type:(NSString *)type
{
    self = [super init];
    if (self) {
        self.stockCode = code;
        self.chartType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initCommponents];
}

-(void)initCommponents {
    
    NSString *url = @"http://www.googuu.net/pages/mobile/company/";
    url = [url stringByAppendingFormat:@"%@/%@.htm",self.chartType,self.stockCode];
    
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_HEIGHT,SCREEN_WIDTH)] autorelease];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [webView sizeToFit];
    [self.view addSubview:webView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
    [doneButton setTitle:NSLocalizedString(@"返回",@"Dismiss button title") forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(5, 5, 50, 30)];
    [doneButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
}

-(void)backButtonClicked:(UIButton *)bt {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        //NSLog(@"here");
    }
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
