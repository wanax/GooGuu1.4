//
//  FeedBackViewController.m
//  googuu
//
//  Created by Xcode on 13-8-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

@synthesize feedBackField;

- (void)dealloc
{
    SAFE_RELEASE(feedBackField);
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
    
	self.title=@"意见反馈";
    self.feedBackField.returnKeyType=UIReturnKeySend;
    self.feedBackField.delegate=self;
}

- (IBAction)backgroundTap:(id)sender {
    [feedBackField resignFirstResponder];
}

#pragma mark -
#pragma mark TextField Methods Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"iphone:%@",textField.text],@"content",nil];
    [Utiles postNetInfoWithPath:@"FeedBack" andParams:params besidesBlock:^(id obj){
        if([[obj objectForKey:@"status"] isEqualToString:@"1"]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [Utiles ToastNotification:@"发布失败" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];

    return YES;
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
