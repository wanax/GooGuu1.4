//
//  UIButton+BGColor.h
//  UIDemo
//
//  Created by Xcode on 13-7-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-15 | Wanax | 设置button背景色

#import <Foundation/Foundation.h>

@interface UIButton(BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundColorString:(NSString *)colorStr forState:(UIControlState)state;

@end
