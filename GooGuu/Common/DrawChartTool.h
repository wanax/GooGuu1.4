//
//  DrawChartTool.h
//  估股
//
//  Created by Xcode on 13-8-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface DrawChartTool : NSObject

@property (nonatomic,retain) id standIn;

+(NSDictionary *)changedDataCombinedWebView:(UIWebView *)webView comInfo:(id)comInfo ggPrice:(NSString *)price dragChartChangedDriverIds:(NSArray *)dragChartChangedDriverIds disCountIsChanged:(BOOL)isChanged;

-(CGSize)getLabelSizeFromString:(NSString *)str font:(NSString *)font fontSize:(float)fontSize;

-(UILabel *)addLabelToView:(UIView *)view withTitle:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect fontSize:(float)size color:(NSString *)color textColor:(NSString *)txtColor location:(NSTextAlignment)location;

//添加绘图上方功能按钮
-(UIButton *)addButtonToView:(UIView *)view withTitle:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect andFun:(SEL)fun withType:(UIButtonType)buttonType andColor:(NSString *)color textColor:(NSString *)txtColor normalBackGroundImg:(NSString *)bUrl highBackGroundImg:(NSString *) hUrl;

//从新数据中提取xy轴中的坐标数据，长度，起始点，间隔点等
+(NSDictionary *)getXYAxisRangeFromxArr:(NSArray *)xArr andyArr:(NSArray *)yArr fromWhere:(ChartType)tag screenHeight:(int)screenHeight;
+(NSDictionary *)getMaxMinMidFromArr:(NSArray *)arr;
//通过基本坐标数据绘制xy坐标
+(void)drawXYAxisIn:(CPTXYGraph *)graph toPlot:(CPTXYPlotSpace *)plotSpace withXRANGEBEGIN:(float)XRANGEBEGIN XRANGELENGTH:(float)XRANGELENGTH  YRANGEBEGIN:(double)YRANGEBEGIN YRANGELENGTH:(double)YRANGELENGTH XINTERVALLENGTH:(float)XINTERVALLENGTH XORTHOGONALCOORDINATE:(double)XORTHOGONALCOORDINATE XTICKSPERINTERVAL:(float)XTICKSPERINTERVAL YINTERVALLENGTH:(double)YINTERVALLENGTH YORTHOGONALCOORDINATE:(double)YORTHOGONALCOORDINATE YTICKSPERINTERVAL:(double)YTICKSPERINTERVAL to:(id)delegate  isY:(BOOL)isY isX:(BOOL)isX type:(ChartType)type;













@end
