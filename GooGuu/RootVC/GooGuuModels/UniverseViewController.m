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

@synthesize theSearchBar;


- (void)dealloc {
    [theSearchBar release], theSearchBar = nil;
    [super dealloc];
}



- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title=@"估值模型";
    [Utiles iOS7StatusBar:self];
    // Do any additional setup after loading the view.
    StockContainerViewController *content=[[StockContainerViewController alloc] init];
    if (IOS7_OR_LATER) {
        content.view.frame=CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    } else {
        content.view.frame=CGRectMake(0,-22,SCREEN_WIDTH,SCREEN_HEIGHT);
    }
    
    
    [self.view addSubview:content.view];
    [self addChildViewController:content];
    
    [content release];
}


- (void)viewDidAppear:(BOOL)animated {
    //[self.theSearchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}



#pragma mark -
#pragma mark Search Delegate Methods


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.theSearchBar resignFirstResponder];
    CompanyListViewController *nextController=[[CompanyListViewController alloc] init];
    nextController.comType=@"全部";
    nextController.isShowSearchBar=YES;
    nextController.type=ALL;
    
    if(![self.navigationController.topViewController isKindOfClass:[CompanyListViewController class]]){
        @try{
            [self.navigationController pushViewController:nextController animated:YES];
            [theSearchBar resignFirstResponder];
        }@catch (NSException *e) {
            NSLog(@"%@",e);
        }
    }
    [self resignFirstResponder];
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