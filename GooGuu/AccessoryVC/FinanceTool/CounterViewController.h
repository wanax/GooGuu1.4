//
//  CounterViewController.h
//  googuu
//
//  Created by Xcode on 13-10-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  2013-10-15 | Wanax | 金融工具计算详细页面

#import <UIKit/UIKit.h>
#import "BetaFactorCountViewController.h"

@interface CounterViewController : UIViewController<UITextFieldDelegate,BetaFactorVCDelegate>{
    NSInteger selectedTextFieldTag;
    CGPoint standard;
}

@property FinancalToolsType toolType;

@property (nonatomic,retain) NSDictionary *params;
@property (nonatomic,retain) NSArray *floatParams;

@end
