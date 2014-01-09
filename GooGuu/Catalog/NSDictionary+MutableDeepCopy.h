//
//  NSDictionary+MutableDeepCopy.h
//  welcom_demo_1
//
//  Created by Xcode on 13-5-9.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 深拷贝方法

#import <Foundation/Foundation.h>

@interface NSDictionary (MutableDeepCopy)
-(NSMutableDictionary *)mutableDeepCopy;
//增加mutableDeepCopy方法
@end
