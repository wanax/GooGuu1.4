//
//  Chart3ViewController.h
//  Chart1.3
//
//  Created by Xcode on 13-4-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-04-15 | Wanax | 可调整参数图表

#import <UIKit/UIKit.h>
#import <math.h>
#import "CorePlot-CocoaTouch.h"
#import "ModelClassGrade2ViewController.h"

@class CQMFloatingController;
@class DiscountRateViewController;

//数据点个数
#define NUM 10

//绘图空间与绘图view底部距离
#define GRAPAHBOTTOMPAD 0.0f
//绘图空间与绘图view顶部的距离
#define GRAPAHTOPPAD 0.0f
//绘图view与self.view顶部距离
#define HOSTVIEWTOPPAD 0.0f
//绘图view与self.view底部距离
#define HOSTVIEWBOTTOMPAD 0.0f


#define FINGERCHANGEDISTANCE 100.0

#define DrawXYAxis [DrawChartTool drawXYAxisIn:graph toPlot:plotSpace withXRANGEBEGIN:XRANGEBEGIN XRANGELENGTH:XRANGELENGTH YRANGEBEGIN:YRANGEBEGIN YRANGELENGTH:YRANGELENGTH XINTERVALLENGTH:XINTERVALLENGTH XORTHOGONALCOORDINATE:XORTHOGONALCOORDINATE XTICKSPERINTERVAL:XTICKSPERINTERVAL YINTERVALLENGTH:YINTERVALLENGTH YORTHOGONALCOORDINATE:YORTHOGONALCOORDINATE YTICKSPERINTERVAL:YTICKSPERINTERVAL to:self isY:YES isX:YES]


@interface ChartViewController : UIViewController<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTBarPlotDataSource,CPTBarPlotDelegate,UIWebViewDelegate,CPTAxisDelegate,ModelClassGrade2Delegate>{
    //x轴起点
    float XRANGEBEGIN;
    //x轴在屏幕可视范围内的范围
    float XRANGELENGTH;
    //y轴起点
    float YRANGEBEGIN;
    //y轴在屏幕可视范围内的范围
    float YRANGELENGTH;
    
    //x轴屏幕范围内大坐标间距
    float XINTERVALLENGTH;
    //x轴坐标的原点（x轴在y轴上的坐标）
    float XORTHOGONALCOORDINATE;
    //x轴每两个大坐标间小坐标个数
    float XTICKSPERINTERVAL;
        
    float YINTERVALLENGTH;
    float YORTHOGONALCOORDINATE;
    float YTICKSPERINTERVAL;
    

    CPTXYGraph * graph ;
    //可调整当前数据线
    NSMutableArray *_forecastPoints;
    //默认置灰当前可调整数据线，做调整后数据对比使用
    NSMutableArray *_forecastDefaultPoints;
    //不可调整历史数据线
    NSMutableArray *_hisPoints;
    //网络获取图表所需数据
    NSString *_jsonForChart;
    //股票种类
    NSArray *_industryClass;
    
    NSMutableArray *_standard;
    
    BOOL _isSaved;
    
}

@property BOOL webIsLoaded;
@property BOOL disCountIsChanged;
@property BOOL isShowDiscountView;
@property BrowseSourceType sourceType;
@property BrowseSourceType wantSavedType;
@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id netComInfo;
@property (nonatomic,retain) NSString *globalDriverId;
@property (nonatomic,retain) NSString *valuesStr;
@property (nonatomic,retain) NSMutableArray *changedDriverIds;

@property (nonatomic,retain) DiscountRateViewController *rateViewController;
@property (nonatomic,retain) ModelClassGrade2ViewController *modelMainViewController;
@property (nonatomic,retain) ModelClassGrade2ViewController *modelFeeViewController;
@property (nonatomic,retain) ModelClassGrade2ViewController *modelCapViewController;

//预测曲线
@property (nonatomic,retain) NSMutableArray *forecastPoints;
//预测默认曲线
@property (nonatomic,retain) NSMutableArray *forecastDefaultPoints;
//历史曲线
@property (nonatomic,retain) NSMutableArray *hisPoints;
//网络获取数据
@property (nonatomic,retain) NSString *jsonForChart;
@property (nonatomic,retain) NSMutableArray *standard;

@property (nonatomic,retain) CPTScatterPlot * forecastLinePlot;
@property (nonatomic,retain) CPTScatterPlot * forecastDefaultLinePlot;
@property (nonatomic,retain) CPTScatterPlot * historyLinePlot;
@property (nonatomic,retain) CPTBarPlot *barPlot;
//是否联动
@property (nonatomic) BOOL linkage;
@property (nonatomic) BOOL isAddGesture;

//行业分类
@property (nonatomic,retain) id industryClass;
@property (nonatomic,retain) NSString *yAxisUnit;
@property (nonatomic,retain) NSString *trueUnit;

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) UILabel *myGGpriceLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UIButton *saveBt;
@property (nonatomic,retain) UIButton *resetBt;
@property (nonatomic,retain) UIButton *linkBt;
@property (nonatomic,retain) UIButton *discountBt;

//绘图view
@property (nonatomic,retain) CPTXYGraph * graph ;
@property (nonatomic,retain) CPTGraphHostingView *hostView;
@property (nonatomic,retain) CPTXYPlotSpace *plotSpace;


//坐标转换方法，实际坐标转化相对坐标
- (CGPoint)CoordinateTransformRealToAbstract:(CGPoint)point;
//坐标转换方法，相对坐标转化实际坐标
- (CGPoint)CoordinateTransformAbstractToReal:(CGPoint)point;
//判断手指触摸点是否在折点旁边
-(BOOL)isNearByThePoint:(CGPoint)p;



@end
