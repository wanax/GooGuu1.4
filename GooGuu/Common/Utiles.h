//
//  Utiles.h
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-07 | Wanax | 工具类

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "CPTColor.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@class MBProgressHUD;
@interface Utiles : NSObject


//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (CPTColor *) cptcolorWithHexString: (NSString *) stringToConvert andAlpha:(float)alpha;

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str;
//loading弹出框
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;
//长方形顶层弹出框
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom andIsHide:(BOOL)isHide;
//根据key值获取配置文件内容，可修改文件置于沙箱中，isIn为YES
+ (id)getConfigureInfoFrom:(NSString *)fileName andKey:(NSString *)key inUserDomain:(BOOL)isIn;
+(void)setConfigureInfoTo:(NSString *)fileName forKey:(NSString *)key andContent:(NSString *)content;

+(void)getNetInfoWithPath:(NSString *)url andParams:(NSDictionary *)params besidesBlock:(void(^)(id obj))block failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)postNetInfoWithPath:(NSString *)url andParams:(NSDictionary *)params besidesBlock:(void(^)(id obj))block failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//字符串判空
+ (BOOL) isBlankString:(NSString *)string;
//字符串转bool
+(BOOL)stringToBool:(NSString *)string;

+ (NSString *)intervalSinceNow: (NSString *) theDate;

+(NSString *)getCatchSize;
+(void)deleteSandBoxContent;

//日期与秒数转换since1970
+(double)dateToSecond:(NSString *)date;
+(NSString *)secondToDate:(double)second;

+(BOOL)isDate1:(NSString *)date1 beforeThanDate2:(NSString *)date2;

+(NSArray *)sortDateArr:(NSArray *)dateArr;

+(NSString *)dataRecombinant:(NSArray *)chartDatas comInfo:(id)comInfo driverIds:(NSArray *)driverIds price:(NSString *)price;

+(NSString *)yearFilled:(NSString *)year;

+(BOOL)isLogin;
+(NSString *)getUserToken;

+(NSString *)unitConversionData:(NSString *)data andUnit:(NSString *)unit trueUnit:(NSString *)tUnit;
+(NSString *)getUnitFromData:(NSString *)data andUnit:(NSString *)unit;

+(id)getObjectDataFromJsFun:(UIWebView *)webView funName:(NSString *)funName byData:(NSString *)data shouldTrans:(BOOL)isTrans;

+(NSArray *)arrSort:(NSArray *)arr;

+(BOOL)isNetConnected;

+(void)showToastView:(UIView *)view withTitle:(NSString *)title andContent:(NSString *)content duration:(float)duration;

+(void)iOS7StatusBar:(UIViewController *)vc;


@end
