//
//  WishesPieViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-13.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface WishesPieViewController : UIViewController<XYPieChartDelegate,XYPieChartDataSource>

@property (nonatomic,retain) XYPieChart *pieChart;
@property (nonatomic,retain) NSArray *comList;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

- (id)initWithComList:(NSArray *)coms;

@end
