//
//  DrawChartTool.m
//  估股
//
//  Created by Xcode on 13-8-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DrawChartTool.h"
#import "UIButton+BGColor.h"

@implementation DrawChartTool

@synthesize standIn;

- (void)dealloc
{
    [standIn release];standIn=nil;
    [super dealloc];
}

+(NSDictionary *)changedDataCombinedWebView:(UIWebView *)webView comInfo:(id)comInfo ggPrice:(NSString *)ggPrice dragChartChangedDriverIds:(NSArray *)dragChartChangedDriverIds disCountIsChanged:(BOOL)isChanged{
    
    NSDictionary *returnData=nil;
    id disCountChangedData=nil;
    id dragChartChangedData=nil;
    
    if(isChanged){
        NSDictionary *params=@{@"stockcode": comInfo[@"stockcode"],@"companyname": comInfo[@"companyname"],@"price": ggPrice};
        NSString *paramStr=[[params JSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        disCountChangedData=[Utiles getObjectDataFromJsFun:webView funName:@"returnSaveDicountData" byData:paramStr shouldTrans:YES];
    }
    
    if([dragChartChangedDriverIds count]>0){
        NSMutableArray *tmpChartsData=[[[NSMutableArray alloc] init] autorelease];
        for(id key in dragChartChangedDriverIds){
            id chartData=[Utiles getObjectDataFromJsFun:webView funName:@"returnChartData" byData:key shouldTrans:YES];
            [tmpChartsData addObject:chartData];
        }
        dragChartChangedData=[[Utiles dataRecombinant:tmpChartsData comInfo:comInfo driverIds:dragChartChangedDriverIds price:ggPrice] objectFromJSONString];
    }
    
    NSMutableArray *tmpModelData=[[NSMutableArray alloc] init];
    if(disCountChangedData){
        for(id obj in disCountChangedData[@"modeldata"]){
            [tmpModelData addObject:obj];
        }
    }
    if(dragChartChangedData){
        for(id obj in dragChartChangedData[@"modeldata"]){
            [tmpModelData addObject:obj];
        }
    }
    
    returnData=@{@"modeldata": tmpModelData,@"price": ggPrice,@"companyname": comInfo[@"companyname"],@"stockcode": comInfo[@"stockcode"]};
    SAFE_RELEASE(tmpModelData);
    return returnData;
    
}

-(UILabel *)addLabelToView:(UIView *)view withTitle:(NSString *)title frame:(CGRect)rect fontSize:(float)size textColor:(NSString *)txtColor location:(NSTextAlignment)location{
    
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.text = title;
    [label setTextColor:[Utiles colorWithHexString:txtColor]];
    [label setTextAlignment:location];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:size]];
    [label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label];
    return [label autorelease];
    
}

-(CGSize)getLabelSizeFromString:(NSString *)str font:(NSString *)font fontSize:(float)fontSize{
    
    CGSize size = CGSizeMake(SCREEN_WIDTH,MAXFLOAT);
    NSDictionary * tdic = @{NSFontAttributeName:[UIFont fontWithName:font size:fontSize], NSForegroundColorAttributeName:[UIColor blackColor]};
    CGSize  actualsize =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize;
}

-(UIButton *)addButtonToView:(UIView *)view withTitle:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect andFun:(SEL)fun{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0f]];
    [button setTag:tag];
    [button setBackgroundColor:[UIColor tangerineColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor] forState:UIControlStateDisabled];

    [button addTarget:standIn action:fun forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return button;
}
NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 floatValue] > [obj2 floatValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 floatValue] < [obj2 floatValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};
+(NSDictionary *)getMaxMinMidFromArr:(NSArray *)arr{
    NSArray *sortArr=[arr sortedArrayUsingComparator:cmptr];
    double max=[[sortArr lastObject] doubleValue];
    double min=[sortArr[0] doubleValue];
    double mid=(max+min)/2;
    NSDictionary *dic=@{@"max": @(max),@"min": @(min),@"mid": @(mid)};
    return dic;
}

+(NSDictionary *)getXYAxisRangeFromxArr:(NSArray *)xArr andyArr:(NSArray *)yArr fromWhere:(ChartType)tag screenHeight:(int)screenHeight{
    
    NSArray *sortXArr=[xArr sortedArrayUsingComparator:cmptr];
    NSArray *sortYArr=[yArr sortedArrayUsingComparator:cmptr];
    
    float xMax=[[sortXArr lastObject] integerValue];
    float xMin=0;
    
    if(tag==DragabelModel){
        int n=0;
        //估值模型图表只显示2010年以后数据
        while ([sortXArr[n] intValue]<10) {
            n++;
        }
        xMin=[sortXArr[n] floatValue];
    }else{
        xMin=[sortXArr[0] floatValue];
    }

    double yMax=[[sortYArr lastObject] doubleValue];
    double yMin=[sortYArr[0] doubleValue];
    double yTap=0.0;
    if(tag==DahonModel){
        yTap=(yMax-yMin);
    }else{
        yTap=(yMax-(yMin<0?yMin:0))*1.4/screenHeight;
    }
    
    float xLowBound=0;
    float xUpBound=0;
    if (tag==FinancalModel) {
        xLowBound=xMin-0.5;
        xUpBound=xMax+0.5;
    } else {
        xLowBound=xMin-1.5;
        xUpBound=xMax+1.5;
    }
    
    double yLowBound=0.0;
    if(yMin>0){
        if(tag==DahonModel){
            yLowBound=yMin-0.2*(yMax-yMin);
        }else if(tag==DragabelModel){
            yLowBound=0-0.2*screenHeight*yTap;
        }else
            yLowBound=0-0.2*screenHeight*yTap;
    }else{
        if(tag==DahonModel){
            yLowBound=yMin-0.2*(yMax-yMin);
        }else if(tag==DragabelModel){
            yLowBound=yMin-0.2*screenHeight*yTap;
        }else
            yLowBound=yMin-0.2*screenHeight*yTap;
    }
    double yUpBound=0.0;
    if(tag==DahonModel){
        yUpBound=yMax+0.2*yTap;
    }else
        yUpBound=yMax+0.2*screenHeight*yTap;
    
    float xBegin=xLowBound;
    float xLength=xUpBound-xLowBound;
    
    double yBegin=yLowBound;
    double yLength=yUpBound-yLowBound;
    
    float xInterval=1;
    double xOrigin=0.0f;
    
    double yInterval=0;
    double yOrigin=xBegin+2;
    
    if(tag==DahonModel){
        xOrigin=yMin;
        yInterval=0.2*yTap;
        yOrigin=xBegin;
    }
    
    return @{@"xBegin": @(xBegin),
             @"xLength": @(xLength),
             @"xInterval": @(xInterval),
             @"xOrigin": @(xOrigin),
             @"yBegin": @(yBegin),
             @"yLength": @(yLength),
             @"yInterval": @(yInterval),
             @"yOrigin": @(yOrigin)};
    
}

+(void)drawXYAxisIn:(CPTXYGraph *)graph toPlot:(CPTXYPlotSpace *)plotSpace withXRANGEBEGIN:(float)XRANGEBEGIN XRANGELENGTH:(float)XRANGELENGTH YRANGEBEGIN:(double)YRANGEBEGIN YRANGELENGTH:(double)YRANGELENGTH XINTERVALLENGTH:(float)XINTERVALLENGTH XORTHOGONALCOORDINATE:(double)XORTHOGONALCOORDINATE XTICKSPERINTERVAL:(float)XTICKSPERINTERVAL YINTERVALLENGTH:(double)YINTERVALLENGTH YORTHOGONALCOORDINATE:(double)YORTHOGONALCOORDINATE YTICKSPERINTERVAL:(double)YTICKSPERINTERVAL to:(id)delegate isY:(BOOL)isY isX:(BOOL)isX type:(ChartType)type{
    
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                   = [CPTColor grayColor];
    textStyle.fontSize                = 12.0f;
    textStyle.textAlignment           = CPTTextAlignmentCenter;
    graph.titleTextStyle           = textStyle;
    graph.titleDisplacement        = CGPointMake(0.0f, -5.0f);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTopLeft;
    
    //设置x，y坐标范围
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(XRANGEBEGIN)
                                                  length:CPTDecimalFromFloat(XRANGELENGTH)];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:
                      CPTDecimalFromCGFloat(YRANGEBEGIN)  length:CPTDecimalFromCGFloat(YRANGELENGTH)];

    //绘制坐标系
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x=axisSet.xAxis;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineCap=kCGLineCapButt;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:120/255.0 green:118/255.0 blue:116/255.0 alpha:1.0];
    if(!isX){
        lineStyle.lineWidth=0.0;
    }
    x.axisLineStyle=lineStyle;
    x.majorIntervalLength=CPTDecimalFromLong(XINTERVALLENGTH);
    x.orthogonalCoordinateDecimal=CPTDecimalFromDouble(XORTHOGONALCOORDINATE);
    x.minorTicksPerInterval=XTICKSPERINTERVAL;
    
    //x.orthogonalCoordinateDecimal=[[NSNumber numberWithInt:0] decimalValue];
    //x.axisConstraints  = [CPTConstraints constraintWithLowerOffset:60];
    lineStyle.lineWidth=1.0;
    if (type == DahonModel) {
        lineStyle.lineWidth=0.2;
        x.majorTickLength=0.0;
        x.tickDirection=CPTSignNegative;
        x.majorGridLineStyle=lineStyle;
        x.axisConstraints  = [CPTConstraints constraintWithLowerOffset:0.1];
    }
    x.minorTickLineStyle = lineStyle;
    x.majorTickLineStyle=lineStyle;
    x.delegate=delegate;
    
    lineStyle.lineWidth = 1.0;
    if(!isY){
        lineStyle.lineWidth=0.0;
    }
    lineStyle.lineColor = [CPTColor grayColor];;
    
    CPTXYAxis *y=axisSet.yAxis;

    if (type == DahonModel) {
       lineStyle.lineWidth=0.2;
       CPTLineCap *lineCap = [CPTLineCap sweptArrowPlotLineCap];
       lineCap.fill      = [CPTFill fillWithColor:lineCap.lineStyle.lineColor];
       lineCap.size = CGSizeMake(15.0, 15.0);
       y.axisLineCapMax  = lineCap;
       y.axisLineCapMin  = lineCap;
       y.axisConstraints  = [CPTConstraints constraintWithLowerOffset:0];
    }

    y.axisLineStyle=lineStyle;
    y.majorIntervalLength=CPTDecimalFromFloat(YINTERVALLENGTH);
    y.orthogonalCoordinateDecimal=CPTDecimalFromFloat(YORTHOGONALCOORDINATE);
    y.minorTicksPerInterval=YTICKSPERINTERVAL;

    y.tickDirection=CPTSignNegative;
    y.majorGridLineStyle=lineStyle;
    y.majorTickLineStyle=lineStyle;
    y.minorTickLineStyle = lineStyle;
    y.delegate=delegate;
    
}


















@end
