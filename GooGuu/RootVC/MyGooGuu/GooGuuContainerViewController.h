//
//  TestViewController.h
//  估股
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 关注列表修正bug  

#import <UIKit/UIKit.h>

@class ConcernedViewController;
@class CalendarViewController;
@class MHTabBarController;

@interface GooGuuContainerViewController : UIViewController

@property (nonatomic,retain) ConcernedViewController *concernedViewController;
@property (nonatomic,retain) ConcernedViewController *saveModelViewControler;
@property (nonatomic,retain) CalendarViewController *calendarViewController;
@property (nonatomic,retain) MHTabBarController* tabBarController;

@end
