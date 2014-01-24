//
//  FinancalModelChartViewController.m
//  估股
//
//  Created by Xcode on 13-8-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinancalModelChartViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "math.h"
#import <AddressBook/AddressBook.h>
#import "PrettyNavigationController.h"
#import "DrawChartTool.h"
#import "ModelClassViewController.h"
#import "ModelClassGrade2ViewController.h"


@interface FinancalModelChartViewController ()

@end

@implementation FinancalModelChartViewController

static NSString * BAR_IDENTIFIER =@"bar_identifier";


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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.colorArr=[NSArray arrayWithObjects:@"e92058",@"b700b7",@"216dcb",@"13bbca",@"65d223",@"f09c32",@"f15a38",nil];

    ModelClassGrade2ViewController *temp1 = [[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelRatioViewController = temp1;
    self.modelRatioViewController.delegate=self;
    ModelClassGrade2ViewController *temp2 = [[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelChartViewController = temp2;
    self.modelChartViewController.delegate=self;
    ModelClassGrade2ViewController *temp3 = [[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelOtherViewController = temp3;
    self.modelOtherViewController.delegate=self;
    self.modelRatioViewController.classTitle=@"财务比例";
    self.modelChartViewController.classTitle=@"财务图表";
    self.modelOtherViewController.classTitle=@"其它指标";
    
    UIWebView *tempWeb = [[[UIWebView alloc] init] autorelease];
    self.webView = tempWeb;
    self.webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    NSMutableArray *tempPoints = [[[NSMutableArray alloc] init] autorelease];
    self.points = tempPoints;
    
    [self initFinancalModelViewComponents];
    [self initBarChart];

}

-(UIBarButtonItem *)addBarButton:(NSString *)title tag:(int)tag {
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0,0,55,40);
    bt.tag = tag;
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.0];
    [bt addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBt = [[[UIBarButtonItem alloc] initWithCustomView:bt] autorelease];
    return barBt;
}


-(void)initFinancalModelViewComponents{
    
    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_HEIGHT,44)] autorelease];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    [toolBar setItems:@[[self addBarButton:@"返回" tag:FinancialBack],
                        flexibleSpace,
                        [self addBarButton:@"财务比例" tag:FinancialRatio],
                        [self addBarButton:@"财务图表" tag:FinancialChart],
                        [self addBarButton:@"其它指标" tag:FinancialOther]
                        ]];
    [self.view addSubview:toolBar];
    
    DrawChartTool *tool=[[[DrawChartTool alloc] init] autorelease];
    tool.standIn=self;
    self.financalTitleLabel=[tool addLabelToView:self.view withTitle:@"" frame:CGRectMake(0,44,SCREEN_HEIGHT,30) fontSize:12.0 textColor:@"#111111" location:NSTextAlignmentCenter];

}

-(void)initBarChart{
    //初始化图形视图
    @try {
        self.graph=[[CPTXYGraph alloc] initWithFrame:CGRectZero];

        self.graph.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#F0F8FF" andAlpha:1.0]];
       
        self.hostView=[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(5,70,SCREEN_HEIGHT-10,220)];
        [self.view addSubview:self.hostView];
        [self.hostView setHostedGraph : self.graph ];
        self.hostView.collapsesLayers = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    self.graph . paddingLeft = 0.0f ;
    self.graph . paddingRight = 0.0f ;
    self.graph . paddingTop = 0 ;
    self.graph . paddingBottom = 0 ;

    //绘制图形空间
    self.plotSpace=(CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    DrawXYAxisWithoutYAxis;
    [self initBarPlot];
}

#pragma mark -
#pragma Button Clicked Methods

-(void)toolBarAction:(UIBarButtonItem *) bt{
    
    if(bt.tag==FinancialRatio){
        [self presentViewController:self.modelRatioViewController animated:YES completion:nil];
    }else if(bt.tag==FinancialChart){
        [self presentViewController:self.modelChartViewController animated:YES completion:nil];
    }else if(bt.tag==FinancialOther){
        [self presentViewController:self.modelOtherViewController animated:YES completion:nil];
    }else if (bt.tag == FinancialBack) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)backTo:(UIButton *)bt{
    
    bt.showsTouchWhenHighlighted=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(id)getObjectDataFromJsFun:(NSString *)funName byData:(NSString *)data{
    NSString *arg=[[NSString alloc] initWithFormat:@"%@(\"%@\")",funName,data];
    NSString *re=[self.webView stringByEvaluatingJavaScriptFromString:arg];
    re=[re stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    SAFE_RELEASE(arg);
    return [re objectFromJSONString];
}

#pragma mark -
#pragma mark ModelClass Methods Delegate
-(void)modelClassChanged:(NSString *)driverId isShowDisView:(BOOL)isShow{
    [self modelClassChanged:driverId];
}
-(void)modelClassChanged:(NSString *)driverId{
    
    id temp=[self getObjectDataFromJsFun:@"returnChartData" byData:driverId];
    NSMutableArray *tempHisPoints=[[NSMutableArray alloc] init];
    for(id obj in [temp objectForKey:@"array"]){
        if([[obj objectForKey:@"h"] boolValue]){
            [tempHisPoints addObject:obj];
        }
    }
    self.points=tempHisPoints;
    self.trueUnit=[temp objectForKey:@"unit"];
    NSArray *sort=[Utiles arrSort:self.points];
    self.yAxisUnit=[Utiles getUnitFromData:[[[sort lastObject] objectForKey:@"v"] stringValue] andUnit:self.trueUnit];
    self.financalTitleLabel.text=[NSString stringWithFormat:@"%@(单位:%@)",[temp objectForKey:@"title"],self.yAxisUnit];
    [self setXYAxis];
    self.barPlot.baseValue=CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
    [self.graph reloadData];
    SAFE_RELEASE(tempHisPoints);
    
}

#pragma mark -
#pragma mark Web Didfinished CallBack
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [ProgressHUD show:nil];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"stockcode"],@"stockCode", nil];
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        
        [self addNameLabel:resObj[@"info"]];
        
        self.jsonForChart=[resObj JSONString];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        //获取金融模型种类
        id transObj=[self getObjectDataFromJsFun:@"initFinancialData" byData:self.jsonForChart];
        
        self.modelRatioViewController.jsonData=transObj;
        self.modelChartViewController.jsonData=transObj;
        self.modelOtherViewController.jsonData=transObj;
        self.modelRatioViewController.indicator=@"listRatio";
        self.modelChartViewController.indicator=@"listChart";
        self.modelOtherViewController.indicator=@"listOther";
        
        [self modelClassChanged:[[[transObj objectForKey:@"listRatio"] objectAtIndex:0] objectForKey:@"id"]];
        self.barPlot.baseValue=CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
        [ProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [ProgressHUD dismiss];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)addNameLabel:(id)comDetailInfo{
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;
    UILabel *nameLabel=nil;
    nameLabel=[tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"%@\n(%@.%@)",[comDetailInfo objectForKey:@"CompanyName"],[comDetailInfo objectForKey:@"StockCode"],[comDetailInfo objectForKey:@"Market"]] frame:CGRectMake(65,0,220,44) fontSize:14.0 textColor:@"#111111" location:NSTextAlignmentCenter];
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.numberOfLines = 0;
    SAFE_RELEASE(tool);
}


#pragma mark -
#pragma mark Bar Data Source Delegate

// 添加数据标签
-( CPTLayer *)dataLabelForPlot:( CPTPlot *)plot recordIndex:( NSUInteger )index
{
    static CPTMutableTextStyle *whiteText = nil ;
    if ( !whiteText ) {
        whiteText = [[ CPTMutableTextStyle alloc ] init ];
        whiteText.color=[CPTColor blackColor];
        whiteText.fontSize=9.0;
        whiteText.fontName=@"Heiti SC";
    }

    CPTTextLayer *newLayer = nil ;
    NSString *numberString =nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if([self.trueUnit isEqualToString:@"%"]){
        
        //[formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setPositiveFormat:@"0.00;0.00;-0.00"];
        numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.points objectAtIndex:index] objectForKey:@"v"] floatValue]*100]];
        
    }else{
        numberString=[[[self.points objectAtIndex:index] objectForKey:@"v"] stringValue];
        numberString=[Utiles unitConversionData:numberString andUnit:self.yAxisUnit trueUnit:self.trueUnit];
    }
    newLayer=[[CPTTextLayer alloc] initWithText:numberString style:whiteText];
    SAFE_RELEASE(formatter);
    return [newLayer autorelease];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [self.points count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    
    if([(NSString *)plot.identifier isEqualToString:BAR_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[NSNumber numberWithInt:[[[self.points objectAtIndex:index] objectForKey:@"y"] intValue]];
        }else if([key isEqualToString:@"y"]){
            num=[NSNumber numberWithFloat:[[[self.points objectAtIndex:index] objectForKey:@"v"] floatValue]];
        }
        
    }
    
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    if(axis.coordinate==CPTCoordinateX){
        
        NSNumberFormatter * formatter   = (NSNumberFormatter *)axis.labelFormatter;
        // axis.fillMode=@"132";
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
            newStyle.color=[CPTColor colorWithComponentRed:153/255.0 green:129/255.0 blue:64/255.0 alpha:1.0];
            positiveStyle  = newStyle;
            
            theLabelTextStyle = positiveStyle;
            
            NSString * labelString      = [formatter stringForObjectValue:tickLocation];
            labelString=[Utiles yearFilled:labelString];
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 3.0;
            newLabel.rotation     = 0;
            //newLabel.font=[UIFont fontWithName:@"Heiti SC" size:13.0];
            [newLabels addObject:newLabel];
            SAFE_RELEASE(newLabel);
            SAFE_RELEASE(newLabelLayer);
        }
        
        axis.axisLabels = newLabels;
    }else{
        
    }
    
    
    return NO;
}

-(void)initBarPlot{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
    self.barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:134/255.0 green:171/255.0 blue:125/255.0 alpha:1.0] horizontalBars:NO];
    self.barPlot. dataSource = self ;
    self.barPlot.delegate=self;
    self.barPlot.lineStyle=lineStyle;
    self.barPlot.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:[self.colorArr objectAtIndex:arc4random()%7] andAlpha:0.6]];
    // 图形向右偏移： 0.25
    self.barPlot.barOffset = CPTDecimalFromFloat(0.0f) ;
    // 在 SDK 中， barCornerRadius 被 cornerRadius 替代
    self.barPlot.barCornerRadius=0;
    self.barPlot.barWidth=CPTDecimalFromFloat(1.0f);
    self.barPlot.barWidthScale=0.5f;
    self.barPlot.labelOffset=0;
    self.barPlot.identifier = BAR_IDENTIFIER;

    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 3.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [self.barPlot addAnimation:fadeInAnimation forKey:@"shadowOffset"];
    // 添加图形到绘图空间
    [self.graph addPlot :self.barPlot toPlotSpace :self.plotSpace];
}

-(void)setXYAxis{
    NSMutableArray *xTmp=[[NSMutableArray alloc] init];
    NSMutableArray *yTmp=[[NSMutableArray alloc] init];
    for(id obj in self.points){
        [xTmp addObject:[obj objectForKey:@"y"]];
        [yTmp addObject:[obj objectForKey:@"v"]];
    }
    NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:FinancalModel screenHeight:220];
    XRANGEBEGIN=[[xyDic objectForKey:@"xBegin"] floatValue];
    XRANGELENGTH=[[xyDic objectForKey:@"xLength"] floatValue];
    XORTHOGONALCOORDINATE=[[xyDic objectForKey:@"xOrigin"] floatValue];
    XINTERVALLENGTH=[[xyDic objectForKey:@"xInterval"] floatValue];
    YRANGEBEGIN=[[xyDic objectForKey:@"yBegin"] floatValue];
    YRANGELENGTH=[[xyDic objectForKey:@"yLength"] floatValue];
    YORTHOGONALCOORDINATE=[[xyDic objectForKey:@"yOrigin"] floatValue];
    YINTERVALLENGTH=[[xyDic objectForKey:@"yInterval"] floatValue];
    DrawXYAxisWithoutYAxis;
    SAFE_RELEASE(xTmp);
    SAFE_RELEASE(yTmp);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.hostView.frame=CGRectMake(10,70,SCREEN_HEIGHT-20,240);
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}









@end