//
//  DahonValuationViewController.m
//  估股
//
//  Created by Xcode on 13-8-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DahonValuationViewController.h"
#import "DrawChartTool.h"
#import "UIButton+BGColor.h"

@interface DahonValuationViewController ()

@end

@implementation DahonValuationViewController

@synthesize oneMonth;
@synthesize threeMonth;
@synthesize sixMonth;
@synthesize oneYear;
@synthesize lastMarkBt;
@synthesize titleLabel;

@synthesize daHonLinePlot;
@synthesize gooGuuLinePlot;
@synthesize historyLinePlot;

@synthesize jsonData;
@synthesize comInfo;
@synthesize dateArr;
@synthesize chartData;
@synthesize daHonIndexDateMap;
@synthesize daHonDataDic;
@synthesize daHonIndexSets;
@synthesize gooGuuIndexDateMap;
@synthesize gooGuuDataDic;
@synthesize gooGuuIndexSets;

@synthesize graph;
@synthesize hostView;
@synthesize plotSpace;

static NSString * DAHON_DATALINE_IDENTIFIER =@"dahon_dataline_identifier";
static NSString * GOOGUU_DATALINE_IDENTIFIER =@"googuu_dataline_identifier";
static NSString * HISTORY_DATALINE_IDENTIFIER =@"history_dataline_identifier";

- (void)dealloc
{
    SAFE_RELEASE(titleLabel);
    SAFE_RELEASE(lastMarkBt);
    SAFE_RELEASE(comInfo);
    SAFE_RELEASE(daHonIndexSets);
    SAFE_RELEASE(daHonIndexDateMap);
    SAFE_RELEASE(daHonDataDic);
    SAFE_RELEASE(gooGuuIndexDateMap);
    SAFE_RELEASE(gooGuuDataDic);
    SAFE_RELEASE(gooGuuIndexSets);
    SAFE_RELEASE(oneMonth);
    SAFE_RELEASE(oneYear);
    SAFE_RELEASE(threeMonth);
    SAFE_RELEASE(sixMonth);
    SAFE_RELEASE(historyLinePlot);
    SAFE_RELEASE(daHonLinePlot);
    SAFE_RELEASE(gooGuuLinePlot);
    SAFE_RELEASE(dateArr);
    SAFE_RELEASE(chartData);
    SAFE_RELEASE(jsonData);
    
    SAFE_RELEASE(graph);
    SAFE_RELEASE(hostView);
    SAFE_RELEASE(plotSpace);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}
-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    comInfo=delegate.comInfo;
    [self initData];
    [self initChart];
    [MBProgressHUD showHUDAddedTo:self.hostView animated:YES];
	[self.view setBackgroundColor:[Utiles colorWithHexString:@"#F6F1E6"]];
    [self initDahonViewComponents];
}

-(void)initDahonViewComponents{
    //NSLog(@"%s",__FUNCTION__);
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;
    UIImageView *topBar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dragChartBar"]];
    if (IOS7_OR_LATER) {
        topBar.frame=CGRectMake(0,20,SCREEN_HEIGHT,40);
    } else {
        topBar.frame=CGRectMake(0,0,SCREEN_HEIGHT,40);
    }
    
    [self.view addSubview:topBar];
    
    //title
    if (IOS7_OR_LATER) {
        titleLabel=[tool addLabelToView:self.view withTitle:@"" Tag:6 frame:CGRectMake(0,60,SCREEN_HEIGHT,30) fontSize:11.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
        [tool addButtonToView:self.view withTitle:@"返回" Tag:5 frame:CGRectMake(15,25,54,30) andFun:@selector(backTo:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"backBt" highBackGroundImg:nil];
        [tool addButtonToView:self.view withTitle:@"刷新" Tag:6 frame:CGRectMake(SCREEN_HEIGHT-64,25,54,30) andFun:@selector(reflash:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"reflashBt" highBackGroundImg:nil];
    } else {
        titleLabel=[tool addLabelToView:self.view withTitle:@"" Tag:6 frame:CGRectMake(0,40,SCREEN_HEIGHT,30) fontSize:11.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
        [tool addButtonToView:self.view withTitle:@"返回" Tag:5 frame:CGRectMake(15,5,54,30) andFun:@selector(backTo:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"backBt" highBackGroundImg:nil];
        [tool addButtonToView:self.view withTitle:@"刷新" Tag:6 frame:CGRectMake(SCREEN_HEIGHT-64,5,54,30) andFun:@selector(reflash:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"reflashBt" highBackGroundImg:nil];
    }
    
    int iOS7H0,iOS7H1;
    if (IOS7_OR_LATER) {
        iOS7H0=28;
        iOS7H1=38;
    } else {
        iOS7H0=45;
        iOS7H1=55;
    }
    
    //提示信息
    [tool addLabelToView:self.view withTitle:@"*点击图标查看大行估值" Tag:6 frame:CGRectMake(SCREEN_HEIGHT-145,SCREEN_WIDTH-iOS7H1,140,40) fontSize:11.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
    
    oneMonth=[tool addButtonToView:self.view withTitle:@"一个月" Tag:OneMonth frame:CGRectMake(SCREEN_HEIGHT-335,SCREEN_WIDTH-iOS7H0,40,22) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [oneMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:10.0]];
    threeMonth=[tool addButtonToView:self.view withTitle:@"三个月" Tag:ThreeMonth frame:CGRectMake(SCREEN_HEIGHT-285,SCREEN_WIDTH-iOS7H0,40,22) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [threeMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:10.0]];
    sixMonth=[tool addButtonToView:self.view withTitle:@"六个月" Tag:SixMonth frame:CGRectMake(SCREEN_HEIGHT-235,SCREEN_WIDTH-iOS7H0,40,22) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [sixMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:10.0]];
    oneYear=[tool addButtonToView:self.view withTitle:@"一年" Tag:OneYear frame:CGRectMake(SCREEN_HEIGHT-185,SCREEN_WIDTH-iOS7H0,40,22) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"monthChoosenBt" highBackGroundImg:nil];
    [oneYear.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:10.0]];
    lastMarkBt=oneYear;
    [oneMonth setEnabled:NO];
    [threeMonth setEnabled:NO];
    [sixMonth setEnabled:NO];
    [oneYear setEnabled:NO];
    SAFE_RELEASE(tool);
    SAFE_RELEASE(topBar);
}

-(void)changeDateInter:(UIButton *)bt{
    bt.showsTouchWhenHighlighted=YES;
    int count=[self.dateArr count];
    if(bt.tag==OneMonth){
        [self changeBtState:oneMonth];
        XRANGEBEGIN=count-24;
        XRANGELENGTH=24;
        XINTERVALLENGTH=4.5;
    }else if(bt.tag==ThreeMonth){
        [self changeBtState:threeMonth];
        XRANGEBEGIN=count-60;
        XRANGELENGTH=59;
        XINTERVALLENGTH=10.7;
    }else if(bt.tag==SixMonth){
        [self changeBtState:sixMonth];
        XRANGEBEGIN=count-130;
        XRANGELENGTH=129;
        XINTERVALLENGTH=23;
    }else if(bt.tag==OneYear){
        [self changeBtState:oneYear];
        XRANGEBEGIN=count-269;
        XRANGELENGTH=269;
        XINTERVALLENGTH=50;
    }
    [self setXYAxis];
}

-(void)changeBtState:(UIButton *)nowBt{
    [lastMarkBt setBackgroundImage:nil forState:UIControlStateNormal];
    [lastMarkBt.titleLabel setTextColor:[Utiles colorWithHexString:@"#e97a31"]];
    [nowBt setBackgroundImage:[UIImage imageNamed:@"monthChoosenBt"] forState:UIControlStateNormal];
    [nowBt setTitleColor:[Utiles colorWithHexString:@"#FFFEFE"] forState:UIControlStateNormal];
    CATransition *transition=[CATransition animation];
    transition.duration=0.3f;
    transition.fillMode=kCAFillRuleNonZero;
    transition.type=kCATransitionMoveIn;
    transition.subtype=kCATransitionFromTop;
    [nowBt.layer addAnimation:transition forKey:@"animation"];
    transition.type=kCATransitionFade;
    transition.subtype=kCATransitionFromTop;
    [lastMarkBt.layer addAnimation:transition forKey:@"animation"];
    lastMarkBt=nowBt;
}

-(void)initChart{
    //初始化图形视图
    @try {
        graph=[[CPTXYGraph alloc] initWithFrame:CGRectZero];
        //CPTTheme *theme=[CPTTheme themeNamed:kCPTPlainWhiteTheme];
        //[graph applyTheme:theme];
        graph.fill=[CPTFill fillWithImage:[CPTImage imageWithCGImage:[UIImage imageNamed:@"discountBack"].CGImage]];
        
        hostView=[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(20,80,SCREEN_WIDTH-20,180) ];
        [self.view addSubview:hostView];
        [hostView setHostedGraph : graph ];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    graph . paddingLeft = 0.0f ;
    graph . paddingRight = 0.0f ;
    graph . paddingTop = 0 ;
    graph . paddingBottom = 0 ;
    
    //graph.title=@"大行估值";
    [titleLabel setText:@"大行估值"];
    //绘制图形空间
    plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction=YES;
    [self.hostView setAllowPinchScaling:YES];
    DrawXYAxisWithoutXAxisOrYAxis;
    [self addScatterChart];
}


-(void)initData{
    
    NSDictionary *params=@{@"stockcode": comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"GetStockHistoryData" andParams:params besidesBlock:^(id resObj){
        NSNumberFormatter * formatter   = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"##.##"];
        @try {
            self.chartData=resObj[@"stockHistoryData"][@"data"];
            id info=resObj[@"stockHistoryData"][@"info"];
            
            DrawChartTool *tool=[[DrawChartTool alloc] init];
            tool.standIn=self;
            //公司名称
            if (IOS7_OR_LATER) {
                [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"%@\n(%@.%@)",info[@"companyName"],info[@"stockCode"],info[@"marketName"]] Tag:6 frame:CGRectMake((SCREEN_HEIGHT-340)/2,20,340,40) fontSize:18.0 color:nil textColor:@"#F9F8F6" location:NSTextAlignmentCenter];
            } else {
                [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"%@\n(%@.%@)",info[@"companyName"],info[@"stockCode"],info[@"marketName"]] Tag:6 frame:CGRectMake((SCREEN_HEIGHT-340)/2,0,340,40) fontSize:18.0 color:nil textColor:@"#F9F8F6" location:NSTextAlignmentCenter];
            }
            SAFE_RELEASE(tool);
            
            NSString *open=[formatter stringForObjectValue:info[@"open"]==nil?@"":info[@"open"]];
            NSString *close=[formatter stringForObjectValue:info[@"close"]==nil?@"":info[@"close"]];
            NSString *high=[formatter stringForObjectValue:info[@"high"]==nil?@"":info[@"high"]];
            NSString *low=[formatter stringForObjectValue:info[@"low"]==nil?@"":info[@"low"]];
            NSString *volume=[NSString stringWithFormat:@"%@",info[@"volume"]==nil?@"":info[@"volume"]];
            NSString *indicator=[NSString stringWithFormat:@"昨开盘:%@ 昨收盘:%@ 最高价:%@ 最低价:%@ 成交量:%@",open,close,high,low,volume];
            [titleLabel setText:indicator];
            
            self.dateArr=[Utiles sortDateArr:self.chartData];
            self.daHonDataDic=resObj[@"dahonData"];
            self.gooGuuDataDic=resObj[@"googuuData"];
            
            [self setDateMap];
            
            int count=[self.dateArr count];
            XRANGEBEGIN=count-269;
            XRANGELENGTH=269;
            XINTERVALLENGTH=50;
            [MBProgressHUD hideHUDForView:self.hostView animated:YES];
            SAFE_RELEASE(formatter);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
        [self setXYAxis];
        [oneMonth setEnabled:YES];
        [threeMonth setEnabled:YES];
        [sixMonth setEnabled:YES];
        [oneYear setEnabled:YES];
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        [oneMonth setEnabled:NO];
        [threeMonth setEnabled:NO];
        [sixMonth setEnabled:NO];
        [oneYear setEnabled:NO];
    }];
}

-(void)setDateMap{
    
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
    for(int i=0;i<[self.dateArr count];i++){
        [tempDic setValue:@(i) forKey:(self.dateArr)[i]];
    }
    
    self.daHonIndexDateMap=[self dateRestruct:tempDic keys:[Utiles sortDateArr:[self.daHonDataDic allKeys]]];
    self.daHonIndexSets=[self.daHonIndexDateMap allKeys];
    
    self.gooGuuIndexDateMap=[self dateRestruct:tempDic keys:[Utiles sortDateArr:[self.gooGuuDataDic allKeys]]];
    self.gooGuuIndexSets=[self.gooGuuIndexDateMap allKeys];
    
    SAFE_RELEASE(tempDic);
    
}

-(NSMutableDictionary *)dateRestruct:(NSMutableDictionary *)tempDic keys:(NSArray *)keys{
    NSMutableDictionary *tempMap=[[NSMutableDictionary alloc] init];
    NSMutableArray *scoreCounter=[[NSMutableArray alloc] init];
    NSArray *dates=[Utiles sortDateArr:[tempDic allKeys]];
    BOOL isAdd=NO;
    for(id key in keys){
        if([dates containsObject:key]){
            [tempMap setValue:key forKey:[NSString stringWithFormat:@"%@",tempDic[key]]];
            [scoreCounter addObject:tempDic[key]];
        }else{
            for(int n=[scoreCounter count]==0?0:[[scoreCounter lastObject] intValue];n<[dates count];n++){
                if([Utiles isDate1:dates[n] beforeThanDate2:key]){
                    continue;
                }else{
                    [tempMap setValue:key forKey:[NSString stringWithFormat:@"%d",n]];
                    [scoreCounter addObject:@(n-1)];
                    isAdd=YES;
                    break;
                }
            }
            if(!isAdd){
                [tempMap setValue:key forKey:[NSString stringWithFormat:@"%d",[dates count]-1]];
            }
        }
        
    }
    SAFE_RELEASE(scoreCounter);
    return [tempMap autorelease];
}

-(void)setXYAxis{
    
    [self lineShowWithAnimation];
    NSMutableArray *xTmp=[[NSMutableArray alloc] init];
    NSMutableArray *yTmp=[[NSMutableArray alloc] init];
    int n=0;
    for(id obj in self.dateArr){
        [xTmp addObject:@(n++)];
    }
    for(id obj in self.chartData){
        [yTmp addObject:(self.chartData)[obj][@"close"]];
    }
    @try {
        NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:DahonModel screenWidth:195];
        XORTHOGONALCOORDINATE=[xyDic[@"xOrigin"] doubleValue];
        YRANGEBEGIN=[xyDic[@"yBegin"] doubleValue];
        YRANGELENGTH=[xyDic[@"yLength"] doubleValue];
        YORTHOGONALCOORDINATE=[xyDic[@"yOrigin"] doubleValue];
        YINTERVALLENGTH=[xyDic[@"yInterval"] doubleValue];
        plotSpace.globalYRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(YRANGEBEGIN) length:CPTDecimalFromDouble(YRANGELENGTH)];
        plotSpace.globalXRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-30) length:CPTDecimalFromDouble(320)];
        DrawXYAxisWithoutXAxisOrYAxis;
        [graph reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)reflash:(UIButton *)bt{
    [MBProgressHUD showHUDAddedTo:self.hostView animated:YES];
    [self initData];
    
}

-(void)backTo:(UIButton *)bt{
    bt.showsTouchWhenHighlighted=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


//散点数据源委托实现
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    int count=0;
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        if(self.chartData){
            count=[self.chartData count];
        }else{
            count=0;
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:DAHON_DATALINE_IDENTIFIER]){
        if(self.daHonIndexSets){
            count=[self.daHonIndexSets count];
        }else{
            count=0;
        }
    }else if([(NSString *)plot.identifier isEqualToString:GOOGUU_DATALINE_IDENTIFIER]){
        if(self.gooGuuIndexSets){
            count=[self.gooGuuIndexSets count];
        }else{
            count=0;
        }
    }
    return count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        
        if(index<[self.dateArr count]){
            NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
            @try {
                if([key isEqualToString:@"x"]){
                    num=[NSNumber numberWithInt:index] ;
                }else if([key isEqualToString:@"y"]){
                    num=[self.chartData valueForKey:(self.dateArr)[index]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:DAHON_DATALINE_IDENTIFIER]){
        if(index<[self.daHonIndexSets count]){
            @try {
                NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
                NSInteger trueIndex=[(self.daHonIndexSets)[index] intValue];
                if([key isEqualToString:@"x"]){
                    num=@(trueIndex);
                }else if([key isEqualToString:@"y"]){
                    num=[self.chartData valueForKey:(self.dateArr)[trueIndex]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:GOOGUU_DATALINE_IDENTIFIER]){
        if(index<[self.gooGuuIndexSets count]){
            @try {
                NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
                NSInteger trueIndex=[(self.gooGuuIndexSets)[index] intValue];
                if([key isEqualToString:@"x"]){
                    num=@(trueIndex);
                }else if([key isEqualToString:@"y"]){
                    num=[self.chartData valueForKey:(self.dateArr)[trueIndex]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }
    return  num;
}

#pragma mark -
#pragma mark Scatter Plot Methods Delegate
-(NSDictionary *)getDataFromDic:(NSDictionary *)dic dateMap:(NSMutableDictionary *)map andArr:(NSArray *)sets byIndex:(NSUInteger)idx{
    
    NSString *msg=[[NSString alloc] init];
    NSString *title=[[NSString alloc] init];
    NSNumber *trueIndex=@([sets[idx] intValue]);
    NSString *date=map[[NSString stringWithFormat:@"%@",trueIndex]];
    id data=dic[date];
    title=[NSString stringWithFormat:@"%@",date];
    for(id obj in data){
        msg=[msg stringByAppendingFormat:@"%@:%@\n",obj[@"dahonName"],obj[@"desc"]];
    }
    return @{@"msg": msg,@"title": title};
}

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx{
    NSDictionary *info=nil;
    NSDictionary *info2=nil;
    if(plot.identifier==GOOGUU_DATALINE_IDENTIFIER){
        info=[self getDataFromDic:self.gooGuuDataDic dateMap:self.gooGuuIndexDateMap andArr:self.gooGuuIndexSets byIndex:idx];
        if([self.daHonIndexSets containsObject:(self.gooGuuIndexSets)[idx]]){
            info2=[self getDataFromDic:self.daHonDataDic dateMap:self.daHonIndexDateMap andArr:self.daHonIndexSets byIndex:idx];
        }
    }else if(plot.identifier==DAHON_DATALINE_IDENTIFIER){
        info=[self getDataFromDic:self.daHonDataDic dateMap:self.daHonIndexDateMap andArr:self.daHonIndexSets byIndex:idx];
    }
    NSString *msg=nil;
    if(info2){
        msg=[NSString stringWithFormat:@"%@%@",info[@"msg"],info2[@"msg"]];
    }else{
        msg=[NSString stringWithFormat:@"%@",info[@"msg"]];
    }
    [Utiles showToastView:self.view withTitle:info[@"title"] andContent:msg duration:1.5];
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    if(axis.coordinate==CPTCoordinateX){
        @try {
            NSNumberFormatter * formatter   = (NSNumberFormatter *)axis.labelFormatter;
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            //[formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
            [formatter setPositiveFormat:@"##"];
            //CGFloat labelOffset             = axis.labelOffset;
            NSMutableSet * newLabels        = [NSMutableSet set];
            static CPTTextStyle * positiveStyle = nil;
            for (NSDecimalNumber * tickLocation in locations) {
                CPTTextStyle *theLabelTextStyle;
                
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.fontSize=10.0;
                newStyle.fontName=@"Heiti SC";
                newStyle.color=[CPTColor colorWithComponentRed:153/255.0 green:129/255.0 blue:64/255.0 alpha:0.8];
                positiveStyle  = newStyle;
                
                theLabelTextStyle = positiveStyle;
                
                NSString * labelString      = [formatter stringForObjectValue:tickLocation];
                NSString *str=nil;
                if([self.dateArr count]>10){
                    @try {
                        if([labelString intValue]<=[self.dateArr count]-1&&[labelString intValue]>=0){
                            str=(self.dateArr)[[labelString intValue]];
                        }else{
                            str=@"";
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                    }
                }
                CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:str style:theLabelTextStyle];
                [newLabelLayer sizeToFit];
                CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
                newLabel.tickLocation       = tickLocation.decimalValue;
                newLabel.offset             =  0;
                newLabel.rotation     = 0;
                [newLabels addObject:newLabel];
            }
            
            axis.axisLabels = newLabels;
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    }else{
        NSNumberFormatter * formatter   = (NSNumberFormatter *)axis.labelFormatter;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //[formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
        [formatter setPositiveFormat:@"##.##"];
        NSMutableSet * newLabels        = [NSMutableSet set];
        static CPTTextStyle * positiveStyle = nil;
        for (NSDecimalNumber * tickLocation in locations) {
            CPTTextStyle *theLabelTextStyle;
            
            CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
            newStyle.fontSize=11.0;
            newStyle.fontName=@"Heiti SC";
            newStyle.color=[CPTColor colorWithComponentRed:153/255.0 green:129/255.0 blue:64/255.0 alpha:0.8];
            positiveStyle  = newStyle;
            
            theLabelTextStyle = positiveStyle;
            
            NSString * labelString      = [formatter stringForObjectValue:tickLocation];
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
            [newLabelLayer sizeToFit];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 0;
            [newLabels addObject:newLabel];
        }
        
        axis.axisLabels = newLabels;
        
    }
    
    
    return NO;
}

-(void)addScatterChart{
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    //修改折线图线段样式,创建可调整数据线段
    historyLinePlot=[[CPTScatterPlot alloc] init];
    lineStyle.miterLimit=2.0f;
    lineStyle.lineWidth=2.0f;
    lineStyle.lineColor=[CPTColor colorWithComponentRed:255/255.0 green:114/255.0 blue:0/255.0 alpha:0.8];
    historyLinePlot.dataLineStyle=lineStyle;
    historyLinePlot.identifier=HISTORY_DATALINE_IDENTIFIER;
    historyLinePlot.labelOffset=5;
    historyLinePlot.dataSource=self;
    historyLinePlot.delegate=self;
    
    daHonLinePlot=[[CPTScatterPlot alloc] init];
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor clearColor];
    daHonLinePlot.dataLineStyle=lineStyle;
    daHonLinePlot.identifier=DAHON_DATALINE_IDENTIFIER;
    daHonLinePlot.labelOffset=5;
    daHonLinePlot.dataSource=self;
    daHonLinePlot.delegate=self;
    
    gooGuuLinePlot=[[CPTScatterPlot alloc] init];
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor clearColor];
    gooGuuLinePlot.dataLineStyle=lineStyle;
    gooGuuLinePlot.identifier=GOOGUU_DATALINE_IDENTIFIER;
    gooGuuLinePlot.labelOffset=5;
    gooGuuLinePlot.dataSource=self;
    gooGuuLinePlot.delegate=self;
    
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:0.5];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor: [CPTColor colorWithComponentRed:226/255.0 green:93/255.0 blue:31/255.0 alpha:0.7]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(20, 20);
    
    daHonLinePlot.plotSymbol = plotSymbol;
    
    plotSymbol = [CPTPlotSymbol trianglePlotSymbol];
    plotSymbol.lineStyle     = symbolLineStyle;
    symbolLineStyle.lineWidth = 0.0;
    plotSymbol.fill          = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#498641" andAlpha:1.0]];
    plotSymbol.size          = CGSizeMake(17, 17);
    gooGuuLinePlot.plotSymbol=plotSymbol;
    
    historyLinePlot.opacity = 0.0f;
    daHonLinePlot.opacity = 0.0f;
    gooGuuLinePlot.opacity=0.0f;
    [self lineShowWithAnimation];
    
    [graph addPlot:historyLinePlot];
    [graph addPlot:daHonLinePlot];
    [graph addPlot:gooGuuLinePlot];
    
}
-(void)lineShowWithAnimation{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeBoth;
    fadeInAnimation.toValue             = @1.0f;
    [daHonLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [historyLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [gooGuuLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        if (IOS7_OR_LATER) {
            self.hostView.frame=CGRectMake(10,90,SCREEN_HEIGHT-20,195);
        } else {
            self.hostView.frame=CGRectMake(10,70,SCREEN_HEIGHT-20,195);
        }
    }
}
-(NSUInteger)supportedInterfaceOrientations{
    //NSLog(@"%s",__FUNCTION__);
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"%s",__FUNCTION__);
    return YES;
}










@end
