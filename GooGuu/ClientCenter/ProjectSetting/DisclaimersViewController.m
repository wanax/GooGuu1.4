//
//  DisclaimersViewController.m
//  googuu
//
//  Created by Xcode on 13-9-3.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DisclaimersViewController.h"

@interface DisclaimersViewController ()

@end

@implementation DisclaimersViewController


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
    self.title=@"免责声明";
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#EAE6D0"]];
    UIScrollView *scrollView=nil;
    if (IOS7_OR_LATER) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, -80, SCREEN_WIDTH, SCREEN_HEIGHT+100)];
    } else {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, -20, SCREEN_WIDTH, SCREEN_HEIGHT+30)];
    }
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0,0,300,960);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"announce" ofType:@"txt"];
    NSString *textFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:17.0]];
    label.layer.borderWidth  = 0.0f;
    label.layer.cornerRadius = 2.0f;
    [label setText:textFile];
    [label setBackgroundColor:[Utiles colorWithHexString:@"#EAE6D0"]];
    scrollView.contentSize = CGSizeMake(300,1000);
    [scrollView addSubview:label];
    [self.view addSubview:scrollView];

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
