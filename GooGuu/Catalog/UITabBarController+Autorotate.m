//
//  UITabBarController+Autorotate.m
//  UIDemo
//
//  Created by Xcode on 13-7-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UITabBarController+Autorotate.h"

@interface UITabBarController (Autorotate)

@end

@implementation UITabBarController(Autorotate)

//返回最上层的子Controller的shouldAutorotate
//子类要实现屏幕旋转需重写该方法
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

//返回最上层的子Controller的supportedInterfaceOrientations
- (NSUInteger)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}

@end