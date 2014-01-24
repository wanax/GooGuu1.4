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
    self.view.backgroundColor = [UIColor whiteColor];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"announce" ofType:@"txt"];
    NSString *textFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    UITextView *contentView = [[[UITextView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.text = textFile;
    contentView.editable = NO;
    contentView.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
    [self.view addSubview:contentView];

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
