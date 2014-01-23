//
//  ExpectedSpaceViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-23.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ExpectedSpaceViewController : UIViewController<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTAxisDelegate>

@property (nonatomic,retain) NSArray *upDatas;
@property (nonatomic,retain) NSArray *downDatas;
@property (nonatomic,retain) NSString *stockCode;
@property (nonatomic,retain) NSArray *expects;

@property (nonatomic,retain) CPTXYGraph * graph ;
@property (nonatomic,retain) CPTGraphHostingView *hostView;
@property (nonatomic,retain) CPTXYPlotSpace *plotSpace;
@property (nonatomic,retain) CPTBarPlot *upBarPlot;
@property (nonatomic,retain) CPTBarPlot *downBarPlot;

@end
