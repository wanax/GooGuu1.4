//
//  AboutUsAndCopyrightViewController.m
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AboutUsAndCopyrightViewController.h"
#import "UIButton+BGColor.h"

@interface AboutUsAndCopyrightViewController ()

@end

@implementation AboutUsAndCopyrightViewController

@synthesize checkUpdateBt;

- (void)dealloc
{
    [checkUpdateBt release];checkUpdateBt=nil;
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
    self.title=@"关于我们";
	[self.checkUpdateBt setBackgroundColorString:@"#BB4C1C" forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}












@end
