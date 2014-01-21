//
//  UniverseViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UniverseViewController.h"
#import "StockContainerViewController.h"
#import "CompanyListViewController.h"
#import "CommonlyMacros.h"

@interface UniverseViewController ()

@end

@implementation UniverseViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title=@"估值模型";
    
    // Do any additional setup after loading the view.
    StockContainerViewController *content=[[[StockContainerViewController alloc] init] autorelease];
    content.view.frame=CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT);
  
    [self.view addSubview:content.view];
    [self addChildViewController:content];
    
    [self addSearchBt];
}

-(void)addSearchBt{
    
    UIButton *wanSay = [[[UIButton alloc] initWithFrame:CGRectMake(200, 10.0, 30, 30)] autorelease];
    [wanSay setImage:[UIImage imageNamed:@"searchBt"] forState:UIControlStateNormal];
    //[wanSay addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:wanSay] autorelease];
    [self.navigationItem setRightBarButtonItem:nextStepBarBtn animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //[self.theSearchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}






-(NSUInteger)supportedInterfaceOrientations{
    
    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (BOOL)shouldAutorotate
{
    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] shouldAutorotate];
    }else{
        return NO;
    }
}














@end