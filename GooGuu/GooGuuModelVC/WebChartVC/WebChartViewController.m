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
    
    NSString *url = @"http://192.168.137.122/pages/mobile/company/";
    url = [url stringByAppendingFormat:@"%@/%@.htm",self.chartType,self.stockCode];
    NSLog(@"%@",url);
    
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
