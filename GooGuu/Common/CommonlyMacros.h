//
//  CommonlyMacros.h
//  估股
//
//  Created by Xcode on 13-8-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NavigationBar_HEIGHT 44

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define FRAME_WIDTH (self.view.frame.size.width)

#define FRAME_HEIGHT (self.view.frame.size.height)

#define SAFE_RELEASE(x) [x release];x=nil

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

#define GetConfigure(A,B,C) [Utiles getConfigureInfoFrom:A andKey:B inUserDomain:C]
#define SetConfigure(A,B,C) [Utiles setConfigureInfoTo:A forKey:B andContent:C]

#define SetUserDefaults(A,B) [[NSUserDefaults standardUserDefaults] setObject:A forKey:B];
#define GetUserDefaults(A) [[NSUserDefaults standardUserDefaults] objectForKey:A]

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define Application [UIApplication sharedApplication]

//use dlog to print while in debug model

#ifdef DEBUG

#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#   define DLog(...)

#endif

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#if TARGET_OS_IPHONE

//iPhone Device

#endif

#if TARGET_IPHONE_SIMULATOR

//iPhone Simulator

#endif





//ARC

#if __has_feature(objc_arc)

//compiling with ARC

#else

// compiling without ARC

#endif





//G－C－D

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


#pragma mark - common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }





#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)



#pragma mark - color functions

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]



@interface CommonlyMacros : NSObject

@end
