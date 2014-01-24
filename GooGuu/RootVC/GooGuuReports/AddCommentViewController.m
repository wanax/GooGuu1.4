//
//  AddCommentViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AddCommentViewController.h"
#import "AFImageRequestOperation.h"
#import "UIButton+BGColor.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type
{
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.commentText.returnKeyType = UIReturnKeyNext;
    self.commentText.layer.borderWidth = 1.0;
    self.commentText.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FFFFFF"]];
    
    UIBarButtonItem *backBarItem = self.topBar.items[0];
    backBarItem.action = @selector(backBtClick:);
    UIBarButtonItem *sendBarItem = self.topBar.items[2];
    sendBarItem.action = @selector(sendComment);
}

-(void)backBtClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTap:(id)sender {
    [self.commentText resignFirstResponder];
}

#pragma mark -
#pragma mark TextField Methods Delegate

-(void)sendComment {
    if(self.type==CompanyType){
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.topical,@"stockcode",self.commentText.text,@"msg",[Utiles getUserToken],@"token",@"googuu",@"from",nil];
        [Utiles postNetInfoWithPath:@"CompanyReview" andParams:params besidesBlock:^(id obj){
            if([[obj objectForKey:@"status"] isEqualToString:@"1"]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [ProgressHUD showError:@"发布失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }else{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.topical,@"articleid",self.commentText.text,@"msg",[Utiles getUserToken],@"token",@"googuu",@"from",nil];
        [Utiles postNetInfoWithPath:@"ContentrReply" andParams:params besidesBlock:^(id resObj){
            if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [ProgressHUD showError:@"发布失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
















@end
