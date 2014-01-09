//
//  CounterBankViewController.h
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  2013-10-15 | Wanax | 金融工具计算详细页面 银行类计算有别于其它计算方式 故新页面中实现

#import <UIKit/UIKit.h>

@interface CounterBankViewController : UIViewController<UITextFieldDelegate>{
    NSInteger selectedTextFieldTag;
    NSInteger selectedBtTag;
    CGPoint standard;
}

@property FinancalToolsType toolType;

@property (nonatomic,retain) NSDictionary *params;
@property (nonatomic,retain) NSArray *floatParams;

@end
