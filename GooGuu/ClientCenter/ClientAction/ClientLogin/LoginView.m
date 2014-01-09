//
//  LoginView.m
//  UIDemo
//
//  Created by Xcode on 13-6-6.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "LoginView.h"
#import "ClientCenterViewController.h"


@implementation LoginView


@synthesize userNameField;
@synthesize userPwdField;

@synthesize title;
@synthesize cancel;

@synthesize delegate;

- (void)dealloc
{
    [userNameField release];userNameField=nil;
    [userPwdField release];userPwdField=nil;

    [title release];title=nil;
    [cancel release];cancel=nil;
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        cancel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
        cancel.userInteractionEnabled = YES;
        UIImageView *backCancel=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_delete_green"]];
        backCancel.frame=CGRectMake(-15,-15,60,60);
        cancel.layer.cornerRadius = 5;
        cancel.layer.borderColor = [Utiles colorWithHexString:@"#00a0b0"].CGColor;
        cancel.layer.borderWidth = 3;
        [cancel addSubview:backCancel];
        

        [self addSubview:cancel];
        [backCancel release];
       
        title=[[UILabel alloc] initWithFrame:CGRectMake(110,60,100,30)];
        title.textAlignment=NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont fontWithName:@"Heiti SC" size:25];
        title.text=@"小马财经";
        title.highlighted=YES;
        
        
        userNameField=[[UITextField alloc] initWithFrame:CGRectMake(50,130,220,35)];
        [userNameField setBackgroundColor:[UIColor whiteColor]];
        userNameField.placeholder = @"example@mail.com"; //默认显示的字
        userNameField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        userNameField.borderStyle=UITextBorderStyleRoundedRect;
        userNameField.clearButtonMode=UITextFieldViewModeUnlessEditing;
        userNameField.tag=100;
        userNameField.autocapitalizationType=UITextAutocapitalizationTypeNone;

        
        userPwdField=[[UITextField alloc] initWithFrame:CGRectMake(50,175,220,35)];
        [userPwdField setBackgroundColor:[UIColor whiteColor]];
        userPwdField.borderStyle=UITextBorderStyleRoundedRect;
        userPwdField.placeholder=@"密码";
        userPwdField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        userPwdField.secureTextEntry=YES;
        userPwdField.tag=200;
        userPwdField.returnKeyType=UIReturnKeyGo;
        
        
        [self addSubview:title];
        [self addSubview:userNameField];
        [self addSubview:userPwdField];
        
      
    }
    return self;
}














@end
