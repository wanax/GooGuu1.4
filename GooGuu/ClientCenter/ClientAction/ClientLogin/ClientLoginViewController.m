//
//  ClientLongViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  客户登录控制器


#import "ClientLoginViewController.h"
#import "PrettyTabBarViewController.h"
#import "MHTabBarController.h"
#import "UserRegisterViewController.h"


@interface ClientLoginViewController ()

@end

@implementation ClientLoginViewController


-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autoCheckImg=[[UIImageView alloc] init];
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    if([Utiles isLogin]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if([GetConfigure(@"userconfigure",@"rememberPwd",YES) isEqual:@"1"]){
        id userInfo = [GetUserDefaults(@"UserInfo") objectFromJSONString];
        if (userInfo) {
            [self.userNameField setText:userInfo[@"username"]];
            [self.userPwdField setText:userInfo[@"password"]];
        }
        [self.autoCheckImg setImage:[UIImage imageNamed:@"autoLoginCheck"]];
    }else{
        [self.autoCheckImg setImage:nil];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isGoIn=NO;
    self.userNameField.delegate=self;
    self.userPwdField.delegate=self;
    
    self.autoCheckImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *rememberTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoBtClicked:)];
    [self.autoCheckImg addGestureRecognizer:rememberTap];
    SAFE_RELEASE(rememberTap);
    
    self.backButton.style = UIBarButtonSystemItemCancel;
    self.backButton.action = @selector(cancelBtClicked:);
}


#pragma mark -
#pragma mark TextField Method Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag==100){
        [self.userNameField resignFirstResponder];
        [self.userPwdField becomeFirstResponder];
    }else if(textField.tag==200){
 
        NSString *name=[self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pwd=[self.userPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [ProgressHUD show:nil];
        [CommonFunction userLoginUserName:name pwd:pwd callBack:^(id obj) {
            [ProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark Button Methods

-(IBAction)autoBtClicked:(id)sender{
    if([[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"rememberPwd" inUserDomain:YES] isEqual:@"1"]){        
        [self.autoCheckImg setImage:nil];
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"0"];
    }else{
        [self.autoCheckImg setImage:[UIImage imageNamed:@"autoLoginCheck"]];
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"1"];
    }
    
}

-(IBAction)freeRegBtClicked:(id)sender{
    UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
    regVC.actionType=UserRegister;
    [self presentViewController:regVC animated:YES completion:nil];
}

-(IBAction)findPwdBtClicked:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.googuu.net/pages/user/forgotPassword.htm"]]; 
}

-(IBAction)loginBtClicked:(id)sender{
    [ProgressHUD show:nil];
    [CommonFunction userLoginUserName:self.userNameField.text pwd:self.userPwdField.text callBack:^(id obj) {
        [ProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.tabBarController.selectedIndex = 0;
    }];
}

-(IBAction)cancelBtClicked:(UIButton *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.tabBarController.selectedIndex = 0;
}

-(IBAction)backGroundIsClicked{
    [self.userNameField resignFirstResponder];
    [self.userPwdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"warning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
