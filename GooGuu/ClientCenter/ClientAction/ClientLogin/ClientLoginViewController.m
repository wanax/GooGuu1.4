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
#import "GooGuuContainerViewController.h"
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
        
        [self userLoginUserName:name pwd:pwd];
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
    [self userLoginUserName:userNameField.text pwd:userPwdField.text];
}

-(IBAction)cancelBtClicked:(UIButton *)bt{
    [self viewDisMiss];
}

-(IBAction)backGroundIsClicked{
    [self.userNameField resignFirstResponder];
    [self.userPwdField resignFirstResponder];
}

-(void)viewDisMiss{
    [userNameField resignFirstResponder];
    [userPwdField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    if(isGoIn){
        [delegate.tabBarController setSelectedIndex:sourceType];
    }else if(!isGoIn){
        if (sourceType==MyGooGuuBar) {
            [delegate.tabBarController setSelectedIndex:NewsBar];
        } else {
            [delegate.tabBarController setSelectedIndex:sourceType];
        }
    }
}

-(void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd{
    if ([Utiles isNetConnected]) {
        
        [MBProgressHUD showHUDAddedTo:self.view withTitle:@"正在登录" animated:YES];
       
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[userName lowercaseString],@"username",[Utiles md5:pwd],@"password",@"googuu",@"from", nil];
        
        [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id info){

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"token"] forKey:@"UserToken"];
                
                NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",pwd,@"password", nil];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"UserInfo"];
                
                NSLog(@"%@",[info objectForKey:@"token"]);
                isGoIn=YES;
                
                [self viewDisMiss];
                
            }else {
                NSString *msg=@"";
                if ([info[@"status"] isEqual:@"0"]) {
                    msg=@"用户不存在";
                } else if ([info[@"status"] isEqual:@"2"]){
                    msg=@"邮箱未激活";
                } else if ([info[@"status"] isEqual:@"3"]){
                    msg=@"密码错误";
                }
                [Utiles ToastNotification:msg andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
    
  
}

-(void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
    NSLog(@"finished");
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
