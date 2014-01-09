//
//  PrettyTabBarViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "PrettyTabBarViewController.h"
#import "PrettyTabBar.h"

@interface PrettyTabBarViewController ()

@end

@implementation PrettyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    [self setValue:[[[PrettyTabBar alloc] init] autorelease] forKeyPath:@"tabBar"];
    return [super init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
