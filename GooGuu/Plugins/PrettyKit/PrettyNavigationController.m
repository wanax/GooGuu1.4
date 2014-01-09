//
//  PrettyNavigationController.m
//  UIDemo
//
//  Created by Xcode on 13-7-19.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "PrettyNavigationController.h"
#import "PrettyNavigationBar.h"

@interface PrettyNavigationController ()

@end

@implementation PrettyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    [self setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    return [super initWithRootViewController:rootViewController];
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
