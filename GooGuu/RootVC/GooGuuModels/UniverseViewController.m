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
#import "StockSearchListViewController.h"

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

-(void)searchAction:(id)sender{
    
    StockSearchListViewController *searchVC = [[[StockSearchListViewController alloc] init] autorelease];
    searchVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

-(void)addSearchBt{
    
    UIBarButtonItem *nextStepBarBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)] autorelease];
    self.navigationItem.rightBarButtonItem = nextStepBarBtn;
    
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