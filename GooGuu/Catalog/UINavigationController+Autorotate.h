//
//  UINavigationControlle+Autorotate.h
//  UIDemo
//
//  Created by Xcode on 13-7-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-04 | Wanax | nav页面向下代理旋转屏幕能力

#import <UIKit/UIKit.h>

@interface UINavigationController (Autorotate)

- (BOOL)shouldAutorotate   ;
- (NSUInteger)supportedInterfaceOrientations;

@end
