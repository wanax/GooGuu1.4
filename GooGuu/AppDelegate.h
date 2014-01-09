//
//  AppDelegate.h
//  GooGuu
//
//  Created by Xcode on 14-1-8.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSString *appId;
@property (nonatomic,assign) NSString *channelId;
@property (nonatomic,assign) NSString *userId;

@property BOOL isReachable;
@property (nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain)  UITabBarController *tabBarController;

@property (retain,nonatomic) UIPageControl * pageControl;
@property (nonatomic,strong) id comInfo;
@property (nonatomic,retain) NSTimer *loginTimer;

@end
