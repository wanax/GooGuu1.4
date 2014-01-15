//
//  Utiles.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "Utiles.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "GCDiscreetNotificationView.h"


@implementation Utiles

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
#define DEFAULTPCT_VOID_COLOR [CPTColor whiteColor]

static NSDateFormatter *formatter;

- (void)dealloc
{
    [super dealloc];
}
+ (CPTColor *)cptcolorWithHexString: (NSString *) stringToConvert andAlpha:(float)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULTPCT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULTPCT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [CPTColor colorWithComponentRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];  
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    
   return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],           
            result[4],result[5],result[6],result[7],            
            result[8],result[9],result[10],result[11],            
            result[12],result[13],result[14],result[15],            
            result[16], result[17],result[18], result[19],            
            result[20], result[21],result[22], result[23],            
            result[24], result[25],result[26], result[27],            
            result[28], result[29],result[30], result[31]];    
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom andIsHide:(BOOL)isHide
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    if(isHide){
        [notificationView hideAnimatedAfter:2.0];
    }
}

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

+ (id)getConfigureInfoFrom:(NSString *)fileName andKey:(NSString *)key inUserDomain:(BOOL)isIn{
    
    NSDictionary *dictionary=nil;
    if(isIn){
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask , YES );
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.plist",documentsDirectory,fileName];
        dictionary = [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    }else{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    }
    
    if(key!=nil){
        return [dictionary objectForKey:key];
    }else{
        return dictionary;
    }
    
  
}
+(void)setConfigureInfoTo:(NSString *)fileName forKey:(NSString *)key andContent:(NSString *)content{

    NSMutableDictionary *dTmp;
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask , YES );
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist",documentsDirectory,fileName];
    dTmp=[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if(dTmp==nil){
        dTmp=[[NSMutableDictionary alloc] init];
    }
    [dTmp setValue:content forKey:key];
    [dTmp writeToFile:filePath atomically: YES];
    [dTmp release];
  
}


+(void)getNetInfoWithPath:(NSString *)url andParams:(NSDictionary *)params besidesBlock:(void (^)(id))block failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    @try {
        AFHTTPClient *getAction=[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[Utiles getConfigureInfoFrom:@"netrequesturl" andKey:@"GooGuuBaseURL" inUserDomain:NO]]];
        [getAction getPath:[Utiles getConfigureInfoFrom:@"netrequesturl" andKey:url inUserDomain:NO] parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
            
            id resObj=[operation.responseString objectFromJSONString];
            if(block){
                block(resObj);
            }
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error){
            failure(operation,error);
        }];
        [getAction release];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        //NSLog(@"get net failed");
    }
    
}

+(void)postNetInfoWithPath:(NSString *)url andParams:(NSDictionary *)params besidesBlock:(void (^)(id))block failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    @try {
        AFHTTPClient *postAction=[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[Utiles getConfigureInfoFrom:@"netrequesturl" andKey:@"GooGuuBaseURL" inUserDomain:NO]]];
        [postAction postPath:[Utiles getConfigureInfoFrom:@"netrequesturl" andKey:url inUserDomain:NO]parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSString *tempRes=[operation.responseString stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
            id resObj=[tempRes objectFromJSONString];
            if(block){
                block(resObj);
            }
            
        }failure:^(AFHTTPRequestOperation *operation,NSError *error){
            failure(operation,error);
        }];
        [postAction release];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        //NSLog(@"post net failed");
    }
    
}

+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if([string isKindOfClass:[NSString class]]){
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }
    }
    if([string isEqualToString:@"<null>"]||[string isEqualToString:@"<NUll>"]){
        return YES;
    }
    
    return NO;
}

+(BOOL)stringToBool:(NSString *)string{
    
    BOOL tag;
    if([string isEqualToString:@"1"]){
        tag=YES;
    }else {
        tag=NO;
    }
    return tag;
    
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400 > 1 && cha/86400 < 604800)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    if (cha >= 604800) {
        timeString = [theDate substringToIndex:theDate.length-8];
    }
    [date release];
    return timeString;
}

+(NSString *)getCatchSize{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize = 0;
    if([fileManager fileExistsAtPath:path]){
        
        NSEnumerator *childFilesEnumerator = [[fileManager subpathsOfDirectoryAtPath:path error:nil] objectEnumerator];
        
        NSString *fileName;
        
        while((fileName = [childFilesEnumerator nextObject]) != nil){
            
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
        }
    }
    return [NSString stringWithFormat:@"%.2f",folderSize/1000];
}

+(void)deleteSandBoxContent{
    
    NSString *extension = @"plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
}

+(double)dateToSecond:(NSString *)date{
    
    if(formatter==nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd"];
    }        
    NSTimeInterval inter = [[formatter dateFromString:date] timeIntervalSince1970];
    return inter;
    
}
+(NSString *)secondToDate:(double)second{
    
    if(formatter==nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd"];
    }
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:second];    
    return [formatter stringFromDate:nd];
  
}

+(BOOL)isDate1:(NSString *)date1 beforeThanDate2:(NSString *)date2{

    date1=[date1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    date2=[date2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
  
    if([date1 intValue]<[date2 intValue]){
        return YES;
    }else{
        return NO;
    }
}

+(NSArray *)sortDateArr:(NSArray *)dateArr{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 longValue] > [obj2 longValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 longValue] < [obj2 longValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSMutableArray *tempDate=[[NSMutableArray alloc] init];
    for(id key in dateArr){
        NSString *str=[key stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [tempDate addObject:[f numberFromString:str]];
    }
    NSArray *tempArr=[tempDate sortedArrayUsingComparator:cmptr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyymmdd"];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-mm-dd"];
    
    [tempDate removeAllObjects];
    for(id obj in tempArr){
        [tempDate addObject:[dateFormatter2 stringFromDate:[dateFormatter dateFromString:[obj stringValue]]]];
    }
    SAFE_RELEASE(dateFormatter);
    SAFE_RELEASE(dateFormatter2);
    SAFE_RELEASE(f);
    return [tempDate autorelease];
}

+(NSString *)dataRecombinant:(NSArray *)chartDatas comInfo:(id)comInfo driverIds:(NSArray *)driverIds price:(NSString *)price{
    
    NSString *returnStr=[NSString stringWithFormat:@"{\"modeldata\":["];
    @try {
        if(![Utiles isBlankString:[chartDatas JSONString]]){
            int n=0;            
            for(id chartData in chartDatas){
                returnStr=[returnStr stringByAppendingFormat:@"{\"data\":["];
                for(id obj in [chartData objectForKey:@"arraynew"]){
                    returnStr=[returnStr stringByAppendingFormat:@"{\"h\":%@,\"id\":\"%@\",\"v\":%@,\"y\":\"%@\"},",[obj objectForKey:@"h"],[obj objectForKey:@"id"],[obj objectForKey:@"v"],[obj objectForKey:@"y"]];
                }
                returnStr=[returnStr stringByAppendingFormat:@"],\"unit\":\"%@\",\"stockcode\":\"%@\",\"itemcode\":%@,\"itemname\":\"%@\"},",[chartData objectForKey:@"unit"],[comInfo objectForKey:@"stockcode"],[driverIds objectAtIndex:n++],[chartData objectForKey:@"title"]];
            }
            returnStr=[returnStr stringByAppendingFormat:@"],"];
            returnStr=[returnStr stringByAppendingFormat:@"\"price\":\"%@\",\"companyname\":\"%@\",\"stockcode\":\"%@\"}",price,[comInfo objectForKey:@"companyname"],[comInfo objectForKey:@"stockcode"]];
            returnStr=[returnStr stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
        }else{
            returnStr=@"";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
  
    return returnStr;
}

+(NSString *)yearFilled:(NSString *)year{
    NSMutableString *temp=[[[NSMutableString alloc] initWithString:year] autorelease];
    if(![Utiles isBlankString:year]){
        if([year length]==1){
            [temp insertString:@"200" atIndex:0];
        }if([year length]==2){
            [temp insertString:@"20" atIndex:0];
        }
        return temp;
    }
    return nil;
}

+(BOOL)isLogin{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"]){
        return YES;
    }else{
        return NO;
    }
}
+(NSString *)getUserToken{
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
    if(![Utiles isBlankString:token]){
        return token;
    }else
        return nil;
}

+(NSString *)getUnitFromData:(NSString *)data andUnit:(NSString *)unit{

    NSString *unitStr=@"";
    
    if(![Utiles isBlankString:data]&&![Utiles isBlankString:unit]){
        
        if ([unit isEqualToString:@"%"]) {
            unitStr = @"百分比";
        } else if ([unit isEqualToString:@"day"]) {
            unitStr = @"天";
        } else if ([unit isEqualToString:@"Millions"]) {
            unitStr = @"百万";
        } else {
            double unitNum = [unit doubleValue];
            double dataNum=[data doubleValue];
            double result=dataNum * unitNum;
            if (fabs(result) > 100000000) {
                unitStr = @"亿";
            } else if (result > 10000) {
                unitStr = @"万";
            } else {
                unitStr = @"1.0";
            }
        }
        
    }
    return unitStr;
    
}


+(NSString *)unitConversionData:(NSString *)data andUnit:(NSString *)unit trueUnit:(NSString *)tUnit{
    
    NSString *resultStr=@"";

    if(![Utiles isBlankString:data]&&![Utiles isBlankString:unit]){
        
        if ([unit isEqualToString:@"百分比"]) {
            resultStr = data;
        } else if ([unit isEqualToString:@"天"]) {
            resultStr = [NSString stringWithFormat:@"%.1f",[data floatValue]];
        } else if ([unit isEqualToString:@"百万"]) {
            resultStr = [NSString stringWithFormat:@"%.2f",[data floatValue]];
        } else {
            double unitNum = [tUnit doubleValue];
            double dataNum=[data doubleValue];
            double result=dataNum * unitNum;
            if ([unit isEqualToString:@"亿"]) {
                resultStr =[NSString stringWithFormat:@"%.2f",result/100000000];
            } else if ([unit isEqualToString:@"万"]) {
                resultStr =[NSString stringWithFormat:@"%.2f",result/10000];
            } else {
                resultStr = [NSString stringWithFormat:@"%.2f",result];
            }
        }
        
    }
    return resultStr;

}

+(id)getObjectDataFromJsFun:(UIWebView *)webView funName:(NSString *)funName byData:(NSString *)data shouldTrans:(BOOL)isTrans{
    NSString *arg=nil;
    if(data==nil){
        arg=[[NSString alloc] initWithFormat:@"%@()",funName];
    }else{
        arg=[[NSString alloc] initWithFormat:@"%@(\"%@\")",funName,data];
    }
    NSString *re=[webView stringByEvaluatingJavaScriptFromString:arg];
    re=[re stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    SAFE_RELEASE(arg);
    if(isTrans)
        return [re objectFromJSONString];
    else
        return re;
}

NSComparator cmptr1 = ^(id obj1, id obj2){
    if ([obj1[@"v"] doubleValue] > [obj2[@"v"] doubleValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1[@"v"] doubleValue] < [obj2[@"v"] doubleValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};
+(NSArray *)arrSort:(NSArray *)arr{
    return [arr sortedArrayUsingComparator:cmptr1];
}

+(BOOL)isNetConnected{
    //return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).isReachable;
    return YES;
}

+(void)showToastView:(UIView *)view withTitle:(NSString *)title andContent:(NSString *)content duration:(float)duration{
    if(title){
        [view makeToast:content duration:duration position:@"center" title:title];
    }else{
        [view makeToast:content duration:duration position:@"center"];
    }
}

+(void)iOS7StatusBar:(UIViewController *)vc{
   
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            vc.edgesForExtendedLayout = UIRectEdgeNone;
            vc.extendedLayoutIncludesOpaqueBars = NO;
            vc.modalPresentationCapturesStatusBarAppearance = NO;
        }
    #endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
}

+(CGSize)getLabelSizeFromString:(NSString *)str font:(UIFont *)font width:(float)width{
    
    CGSize size = CGSizeMake(width,MAXFLOAT);
    NSDictionary * tdic = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]};
    CGSize  actualsize =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize;
}


@end
