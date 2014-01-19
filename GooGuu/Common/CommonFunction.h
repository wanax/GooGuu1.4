//
//  CommonFunction.h
//  MathMonsters
//
//  Created by Xcode on 13-12-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunction : NSObject

+(void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd callBack:(void(^)(id obj))block;

+(void)userLogoutcallBack:(void(^)(id obj))block;

@end
