//
//  WebChartViewController.h
//  GooGuu
//
//  Created by Xcode on 14-2-26.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebChartViewController : UIViewController

@property (retain, nonatomic) NSString *stockCode;
@property (retain, nonatomic) NSString *chartType;

- (id)initWithCode:(NSString *)code type:(NSString *)type;

@end
