//
//  MyGooguuViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "MyGooguuViewController.h"
#import "ConcernedViewController.h"
#import "ClientLoginViewController.h"
#import "MHTabBarController.h"
#import "GooGuuContainerViewController.h"
#import "SettingCenterViewController.h"

@interface MyGooguuViewController ()

@end

@implementation MyGooguuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loginBtClicked:(id)sender{
    ClientLoginViewController *loginViewController=nil;
    if (SCREEN_HEIGHT>500) {
        loginViewController = [[[ClientLoginViewController alloc] initWithNibName:@"ClientLoginView5" bundle:nil] autorelease];
    } else {
        loginViewController = [[[ClientLoginViewController alloc] initWithNibName:@"ClientLoginView" bundle:nil] autorelease];
    }
    
    loginViewController.sourceType=MyGooGuuBar;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if(![Utiles isLogin]){
        UIBarButtonItem *settingButton = [[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain
                                                                         target:self action:@selector(loginBtClicked:)] autorelease];
        self.navigationItem.leftBarButtonItem = settingButton;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
 
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"我的估股"];
    
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.navigationItem.rightBarButtonItem = settingButton;
    
    GooGuuContainerViewController *content=[[GooGuuContainerViewController alloc] init];
    content.view.frame=CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT);
    
    [self addChildViewController:content];
    [self.view addSubview:content.view];
    
    SAFE_RELEASE(content);
    
}

-(void)setting:(id)sender{
    SettingCenterViewController *set=[[[SettingCenterViewController alloc] init] autorelease];
    set.title=@"功能设置";
    set.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:set animated:YES];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        
    } else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){

    }
}

-(NSUInteger)supportedInterfaceOrientations{
    
    //NSLog(@"%s",__FUNCTION__);
    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
}

- (BOOL)shouldAutorotate{

    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] shouldAutorotate];
    }else{
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























@end
