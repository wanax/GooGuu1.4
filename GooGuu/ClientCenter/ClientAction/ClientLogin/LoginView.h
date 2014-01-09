//
//  LoginView.h
//  UIDemo
//
//  Created by Xcode on 13-6-6.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-06 | Wanax | 登录界面

#import <UIKit/UIKit.h>


@interface LoginView : UIView

@property (nonatomic,retain) UILabel *title;

@property (nonatomic,retain) UITextField *userNameField;
@property (nonatomic,retain) UITextField *userPwdField;

@property (nonatomic,retain) UILabel *cancel;

@property (nonatomic,assign) id<UITextFieldDelegate> delegate;

@end
