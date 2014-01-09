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
        NSMutableArray *tmpChartsData=[[NSMutableArray alloc] init];
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

-(UILabel *)addLabelToView:(UIView *)view withTitle:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect fontSize:(float)size color:(NSString *)color textColor:(NSString *)txtColor location:(NSTextAlignment)location{
    
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    [label setText:title];
    [label setTextColor:[Utiles colorWithHexString:txtColor]];
    [label setTextAlignment:location];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:size]];
    [label setTag:tag];
    
    if(color){
        [label setBackgroundColor:[Utiles colorWithHexString:color]];
    }else{
        [label setBackgroundColor:[UIColor clearColor]];
    }
    //[[label layer] setBorderColor:[[UIColor blackColor] CGColor]];
    //[[label layer] setBorderWidth:1.0];
    [view addSubview:label];
    return [label autorelease];
    
}

-(CGSize)getLabelSizeFromString:(NSString *)str font:(NSString *)font fontSize:(float)fontSize{
    CGSize size = CGSizeMake(320,2000);
    return [str sizeWithFont:[UIFont fontWithName:font size:fontSize] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
}

-(UIButton *)addButtonToView:(UIView *)view withTitle:(NSString *)title Tag:(NSInteger)tag frame:(CGRect)rect andFun:(SEL)fun withType:(UIButtonType)buttonType andColor:(NSString *)color textColor:(NSString *)txtColor normalBackGroundImg:(NSString *)bUrl highBackGroundImg:(NSString *)hUrl{
    
    UIButton *button=[UIButton buttonWithType:buttonType];
    [button setFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:12.0f]];
    [button setTitleColor:[Utiles colorWithHexString:txtColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTag:tag];
    
    if(color){
        if (buttonType==UIButtonTypeCustom) {
            [button setBackgroundColor:[Utiles colorWithHexString:color]];
        }else if(buttonType==UIButtonTypeRoundedRect){
            [button setBackgroundColorString:color forState:UIControlStateNormal];
        }
    }else{
        [button setBackgroundColor:[UIColor clearColor]];
    }
    if(bUrl){
        [button setBackgroundImage:[UIImage imageNamed:bUrl] forState:UIControlStateNormal];
    }
    if(hUrl){
        [button setBackgroundImage:[UIImage imageNamed:hUrl] forState:UIControlStateHighlighted];
    }
    
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

+(NSDictionary *)getXYAxisRangeFromxArr:(NSArray *)xArr andyArr:(NSArray *)yArr fromWhere:(ChartType)tag screenWidth:(int)screenWidth{
    
    NSArray *sortXArr=[xArr sortedArrayUsingComparator:cmptr];
    NSArray *sortYArr=[yArr sortedArrayUsingComparator:cmptr];
    
    float xMax=[[sortXArr lastObject] integerValue];
    float xMin=0;
    @try {
        if(tag==DragabelModel){
            int n=0;
            if([sortXArr[0] intValue]<10){
                for(id year in sortXArr){
                    n++;
                    if([year intValue]==10){
                        break;
                    }
                }
            }
            xMin=[sortXArr[n] floatValue];
        }else{
            xMin=[sortXArr[0] floatValue];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    //NSInteger xTap=1;
    double yMax=[[sortYArr lastObject] doubleValue];
    double yMin=[sortYArr[0] doubleValue];
    double yTap=0.0;
    if(tag==DahonModel){
        yTap=(yMax-yMin);
    }else{
        yTap=(yMax-(yMin<0?yMin:0))*1.4/screenWidth;
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
            yLowBound=0-0.2*screenWidth*yTap;
        }else
            yLowBound=0-0.2*screenWidth*yTap;
    }else{
        if(tag==DahonModel){
            yLowBound=yMin-0.2*(yMax-yMin);
        }else if(tag==DragabelModel){
            yLowBound=yMin-0.2*screenWidth*yTap;
        }else
            yLowBound=yMin-0.2*screenWidth*yTap;
    }
    double yUpBound=0.0;
    if(tag==DahonModel){
        yUpBound=yMax+0.2*yTap;
    }else
        yUpBound=yMax+0.2*screenWidth*yTap;
    
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
        yInterval=0.5*yTap;
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

+(void)drawXYAxisIn:(CPTXYGraph *)graph toPlot:(CPTXYPlotSpace *)plotSpace withXRANGEBEGIN:(float)XRANGEBEGIN XRANGELENGTH:(float)XRANGELENGTH YRANGEBEGIN:(double)YRANGEBEGIN YRANGELENGTH:(double)YRANGELENGTH XINTERVALLENGTH:(float)XINTERVALLENGTH XORTHOGONALCOORDINATE:(double)XORTHOGONALCOORDINATE XTICKSPERINTERVAL:(float)XTICKSPERINTERVAL YINTERVALLENGTH:(double)YINTERVALLENGTH YORTHOGONALCOORDINATE:(double)YORTHOGONALCOORDINATE YTICKSPERINTERVAL:(double)YTICKSPERINTERVAL to:(id)delegate isY:(BOOL)isY isX:(BOOL)isX{
    
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                   = [CPTColor grayColor];
    textStyle.fontSize                = 14.0f;
    textStyle.textAlignment           = CPTTextAlignmentCenter;
    graph.titleTextStyle           = textStyle;
    graph.titleDisplacement        = CGPointMake(0.0f, -20.0f);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    /*NSLog(@"\nXRANGEBEGIN%f\nXRANGELENGTH%f\nXORTHOGONALCOORDINATE%f\nXTICKSPERINTERVAL%f\nYRANGEBEGIN%f\nYRANGELENGTH%f\nYORTHOGONALCOORDINATE%f\nYTICKSPERINTERVAL%f\n",XRANGEBEGIN,XRANGELENGTH,XORTHOGONALCOORDINATE,XTICKSPERINTERVAL,YRANGEBEGIN,YRANGELENGTH,YORTHOGONALCOORDINATE,YINTERVALLENGTH);*/
    
    //设置x，y坐标范围
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(XRANGEBEGIN)
                                                  length:CPTDecimalFromFloat(XRANGELENGTH)];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:
                      CPTDecimalFromCGFloat(YRANGEBEGIN)  length:CPTDecimalFromCGFloat(YRANGELENGTH)];
    //plotSpace.allowsUserInteraction=YES;
    
    //绘制坐标系
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x=axisSet.xAxis;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineCap=kCGLineCapButt;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:120/255.0 green:118/255.0 blue:116/255.0 alpha:1.0];
    if(!isX){
        lineStyle.lineWidth=0;
    }
    x.axisLineStyle=lineStyle;
    x.majorIntervalLength=CPTDecimalFromLong(XINTERVALLENGTH);
    x.orthogonalCoordinateDecimal=CPTDecimalFromDouble(XORTHOGONALCOORDINATE);
    x.minorTicksPerInterval=XTICKSPERINTERVAL;
    //lineStyle.lineWidth=1.0;
    x.minorTickLineStyle = lineStyle;
    x.majorTickLineStyle=lineStyle;
    x.delegate=delegate;
    
    //lineStyle.lineColor = [CPTColor colorWithComponentRed:112/255.0 green:196/255.0 blue:64/255.0 alpha:1.0];
    lineStyle.lineWidth = 1.0;
    if(!isY){
        lineStyle.lineWidth=0.0;
    }
    lineStyle.lineColor = [CPTColor colorWithComponentRed:153/255.0 green:129/255.0 blue:64/255.0 alpha:1.0];
    CPTXYAxis *y=axisSet.yAxis;
    y.axisLineStyle=lineStyle;
    y.majorIntervalLength=CPTDecimalFromFloat(YINTERVALLENGTH);
    y.orthogonalCoordinateDecimal=CPTDecimalFromFloat(YORTHOGONALCOORDINATE);
    y.minorTicksPerInterval=YTICKSPERINTERVAL;
    
    lineStyle.lineWidth=1.0;
    y.tickDirection=CPTSignNegative;
    y.majorGridLineStyle=lineStyle;
    y.majorTickLineStyle=lineStyle;
    y.minorTickLineStyle = lineStyle;
    y.delegate=delegate;
    
}


















@end
