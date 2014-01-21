//
//  ClientLongViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  客户登录控制器


#import "ClientLoginViewController.h"
#import "LoginView.h"
#import "ConcernedViewController.h"
#import "LoginView.h"
#import "MBProgressHUD.h"
#import "PrettyTabBarViewController.h"
#import "MHTabBarController.h"
#import "ConcernedViewController.h"
#import "UserRegisterViewController.h"


@interface ClientLoginViewController ()

@end

@implementation ClientLoginViewController

@synthesize userNameField;
@synthesize userPwdField;
@synthesize loginBt;
@synthesize cancelBt;
@synthesize regBt;
@synthesize findPwdBt;
@synthesize autoCheckImg;
@synthesize autoLoginBt;
@synthesize sourceType;

- (void)dealloc
{   
    SAFE_RELEASE(userNameField);
    SAFE_RELEASE(userPwdField);
    SAFE_RELEASE(loginBt);
    SAFE_RELEASE(regBt);
    SAFE_RELEASE(cancelBt);
    SAFE_RELEASE(findPwdBt);
    SAFE_RELEASE(autoLoginBt);
    SAFE_RELEASE(autoCheckImg);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

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
        autoCheckImg=[[UIImageView alloc] init];
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    if([Utiles isLogin]){
        [self viewDisMiss];
    }
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if([[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"rememberPwd" inUserDomain:YES] isEqual:@"1"]){
        id userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
        if (userInfo) {
            [self.userNameField setText:userInfo[@"username"]];
            [self.userPwdField setText:userInfo[@"password"]];
        }
        [autoCheckImg setImage:[UIImage imageNamed:@"autoLoginCheck"]];
    }else{
        [autoCheckImg setImage:nil];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isGoIn=NO;
    userNameField.delegate=self;
    userPwdField.delegate=self;
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userNameImg"]];
    image.frame=CGRectMake(0,0,20,20);
    userNameField.leftView=image;
    userNameField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    UIImageView *image2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdImg"]];
    image2.frame=CGRectMake(0,0,20,20);
    userPwdField.leftView=image2;
    userPwdField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    autoCheckImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *rememberTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoBtClicked:)];
    [autoCheckImg addGestureRecognizer:rememberTap];
    SAFE_RELEASE(rememberTap);
    

}


#pragma mark -
#pragma mark TextField Method Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag==100){
        [userNameField resignFirstResponder];
        [userPwdField becomeFirstResponder];
    }else if(textField.tag==200){
 
        NSString *name=[userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pwd=[userPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [CommonFunction userLoginUserName:name pwd:pwd callBack:^(id obj) {
            NSLog(@"%@",obj);
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
        [autoCheckImg setImage:nil];
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"0"];
    }else{
        [autoCheckImg setImage:[UIImage imageNamed:@"autoLoginCheck"]];
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"1"];
    }
    
}

-(IBAction)freeRegBtClicked:(id)sender{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.googuu.net/pages/user/newRegister.htm"]];
    UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
    regVC.actionType=UserRegister;
    [self presentViewController:regVC animated:YES completion:nil];
}

-(IBAction)findPwdBtClicked:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.googuu.net/pages/user/forgotPassword.htm"]]; 
}

-(IBAction)loginBtClicked:(id)sender{
    [CommonFunction userLoginUserName:userNameField.text pwd:userPwdField.text callBack:^(id obj) {
        NSLog(@"%@",obj);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(IBAction)cancelBtClicked:(UIButton *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
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
