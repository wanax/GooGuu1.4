//
//  IntroductionViewController.h
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票介绍

#import <UIKit/UIKit.h>
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "SDImageCache.h"

#define FINGERCHANGEDISTANCE 100.0

@interface IntroductionViewController : UIViewController<CXPhotoBrowserDataSource, CXPhotoBrowserDelegate>{
    CGPoint standard;
}

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic, retain) NSArray *photos;

@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

@end
