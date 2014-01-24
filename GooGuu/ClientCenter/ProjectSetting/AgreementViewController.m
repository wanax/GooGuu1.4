//
//  AgreementViewController.m
//  googuu
//
//  Created by Xcode on 13-9-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AgreementViewController.h"
#import "UIButton+BGColor.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

@synthesize agreeBt;
@synthesize disAgreeBt;

- (void)dealloc
{
    SAFE_RELEASE(agreeBt);
    SAFE_RELEASE(disAgreeBt);
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
	self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 45, 300, 360)] autorelease];
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0,0,300,960);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"txt"];
    NSString *textFile = [[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] autorelease];
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
    
    [self.agreeBt setBackgroundColor:[Utiles colorWithHexString:@"#A75524"] forState:UIControlStateNormal];
    [self.disAgreeBt setBackgroundColor:[Utiles colorWithHexString:@"#4CB649"] forState:UIControlStateNormal];
}

-(IBAction)agreeBtClicked:(id)sender{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"agreement"];
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    
    [delegate application:nil didFinishLaunchingWithOptions:nil];
}
-(IBAction)disAgreeBtClicked:(id)sender{
    [self exitApplication];
}
- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
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
