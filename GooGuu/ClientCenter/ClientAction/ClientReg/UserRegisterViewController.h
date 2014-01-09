//
//  UserRegisterViewController.h
//  googuu
//
//  Created by Xcode on 13-10-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKProgressTimer.h"


@interface UserRegisterViewController :UIViewController<UITextFieldDelegate,KKProgressTimerDelegate>{
    NSInteger selectedTextFieldTag;
}

@property UserActionType actionType;

@property (nonatomic,retain) UIButton *getCheckCodeBt;

@property (nonatomic,retain) KKProgressTimer *timer;

@end
