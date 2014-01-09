//
//  Chart3ViewController.m
//  Chart1.3
//
//  Created by Xcode on 13-4-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  公司详细页图表绘制

#import "ChartViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "math.h"
#import <AddressBook/AddressBook.h>
#import "ModelViewController.h"
#import "MHTabBarController.h"
#import "MBProgressHUD.h"
#import "PrettyNavigationController.h"
#import "DrawChartTool.h"
#import "DiscountRateViewController.h"
#import "UIButton+BGColor.h"
#import <CoreText/CoreText.h>



@interface ChartViewController ()

@end

@implementation ChartViewController

@synthesize trueUnit;
@synthesize sourceType;
@synthesize wantSavedType;
@synthesize comInfo;
@synthesize netComInfo;
@synthesize disCountIsChanged;
@synthesize globalDriverId;
@synthesize valuesStr;
@synthesize webIsLoaded;
@synthesize changedDriverIds;
@synthesize isShowDiscountView;

@synthesize rateViewController;
@synthesize modelMainViewController;
@synthesize modelFeeViewController;
@synthesize modelCapViewController;

@synthesize forecastPoints=_forecastPoints;
@synthesize forecastDefaultPoints=_forecastDefaultPoints;
@synthesize hisPoints=_hisPoints;
@synthesize standard=_standard;

@synthesize jsonForChart=_jsonForChart;

@synthesize forecastDefaultLinePlot;
@synthesize forecastLinePlot;
@synthesize historyLinePlot;
@synthesize barPlot;

@synthesize linkage;
@synthesize isAddGesture;

@synthesize industryClass=_industryClass;
@synthesize yAxisUnit;
@synthesize hostView;
@synthesize plotSpace;
@synthesize graph;

@synthesize webView;
@synthesize priceLabel;
@synthesize myGGpriceLabel;
@synthesize saveBt;
@synthesize discountBt;


static NSString * FORECAST_DATALINE_IDENTIFIER =@"forecast_dataline_identifier";
static NSString * FORECAST_DEFAULT_DATALINE_IDENTIFIER =@"forecast_default_dataline_identifier";
static NSString * HISTORY_DATALINE_IDENTIFIER =@"history_dataline_identifier";
static NSString * COLUMNAR_DATALINE_IDENTIFIER =@"columnar_dataline_identifier";


- (void)dealloc
{
    SAFE_RELEASE(trueUnit);
    SAFE_RELEASE(discountBt);
    SAFE_RELEASE(changedDriverIds);
    SAFE_RELEASE(saveBt);
    SAFE_RELEASE(myGGpriceLabel);
    SAFE_RELEASE(globalDriverId);
    SAFE_RELEASE(comInfo);
    SAFE_RELEASE(valuesStr);
    SAFE_RELEASE(netComInfo);
    
    SAFE_RELEASE(rateViewController);
    SAFE_RELEASE(modelMainViewController);
    SAFE_RELEASE(modelFeeViewController);
    SAFE_RELEASE(modelCapViewController);
    
    [yAxisUnit release];yAxisUnit=nil;
    [graph release];graph=nil;
    [plotSpace release];plotSpace=nil;
    [hostView release];hostView=nil;
    
    [_forecastDefaultPoints release];_forecastDefaultPoints=nil;
    [_forecastPoints release];_forecastPoints=nil;
    [_hisPoints release];_hisPoints=nil;
    [_jsonForChart release];_jsonForChart=nil;
    [_industryClass release];_industryClass=nil;
    [_standard release];_standard=nil;
    
    [forecastLinePlot release];forecastLinePlot=nil;
    [forecastDefaultLinePlot release];forecastDefaultLinePlot=nil;
    [historyLinePlot release];historyLinePlot=nil;
    [barPlot release];barPlot=nil;
    
    [webView release];webView=nil;
    [priceLabel release];priceLabel=nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark General Methods
-(void)addToDriverIds:(NSString *)driverId{
    //NSLog(@"addToDriverIds");
    if(![self.changedDriverIds containsObject:driverId]){
        [self.changedDriverIds addObject:driverId];
    }
}
-(void)addDiscountView{
    if([Utiles isNetConnected]){
        if(!isShowDiscountView){
            isShowDiscountView=YES;
            [self.discountBt setEnabled:NO];
            [self.view addSubview:self.rateViewController.view];
            CATransition *transition=[CATransition animation];
            transition.duration=0.1f;
            transition.fillMode=kCAFillRuleNonZero;
            transition.type=kCATransitionFade;
            transition.subtype=kCATransitionFromTop;
            [self.rateViewController.view.layer addAnimation:transition forKey:@"animation"];
        }
    }else{
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
}
-(void)removeDiscountView{
    if(isShowDiscountView){
        isShowDiscountView=NO;
        [self.discountBt setEnabled:YES];
        CATransition *transition=[CATransition animation];
        transition.duration=0.1f;
        transition.delegate=self;
        transition.fillMode=kCAFillRuleNonZero;
        transition.type=kCATransitionFade;
        transition.subtype=kCATransitionFromBottom;
        [self.rateViewController.view removeFromSuperview];
        [self.view.layer addAnimation:transition forKey:@"animation"];
    }
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if(webIsLoaded){
        if(![Utiles isBlankString:self.valuesStr]){
            self.valuesStr=[self.valuesStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            [Utiles getObjectDataFromJsFun:self.webView funName:@"setValues" byData:self.valuesStr shouldTrans:NO];
            [self modelClassChanged:globalDriverId];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    //NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#F6F1E6"]];
    [self.discountBt setEnabled:NO];
 
    [self initVariable];
    
    webView=[[UIWebView alloc] init];
    webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    
    [self initPlotSpace];
}
-(void)initVariable{
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    comInfo=delegate.comInfo;
    self.changedDriverIds=[[NSMutableArray alloc] init];
    linkage=YES;
    _isSaved=YES;
    webIsLoaded=NO;
    self.modelMainViewController=[[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelFeeViewController=[[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelCapViewController=[[[ModelClassGrade2ViewController alloc] init] autorelease];
    self.modelMainViewController.delegate=self;
    self.modelFeeViewController.delegate=self;
    self.modelCapViewController.delegate=self;
    self.modelMainViewController.classTitle=@"主营收入";
    self.modelFeeViewController.classTitle=@"运营费用";
    self.modelCapViewController.classTitle=@"运营资本";
}

-(void)initPlotSpace{
    self.forecastPoints=[[NSMutableArray alloc] init];
    self.hisPoints=[[NSMutableArray alloc] init];
    self.forecastDefaultPoints=[[NSMutableArray alloc] init];
    self.standard=[[NSMutableArray alloc] init];
    
    //初始化图形视图
    @try {
        graph=[[CPTXYGraph alloc] initWithFrame:CGRectZero];
        graph.fill=[CPTFill fillWithImage:[CPTImage imageWithCGImage:[UIImage imageNamed:@"discountBack"].CGImage]];
        //graph.cornerRadius  = 5.0f;
        hostView=[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(0,40,SCREEN_WIDTH,270) ];
        [self.view addSubview:hostView];
        [hostView setHostedGraph : graph ];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    graph . paddingLeft = 0.0f ;
    graph . paddingRight = 0.0f ;
    graph . paddingTop = 0 ;
    graph . paddingBottom = GRAPAHBOTTOMPAD ;
    
    //绘制图形空间
    plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    //plotSpace.allowsUserInteraction=YES;
    DrawXYAxis;
}

-(void)initChartViewComponents{
    //NSLog(@"initChartViewComponents");
    int iOS7H0,iOS7H1,iOS7H2;
    iOS7H0=20;
    iOS7H1=25;
    iOS7H2=72;
    UIImageView *topBar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dragChartBar"]];
    topBar.frame=CGRectMake(0,iOS7H0,SCREEN_HEIGHT,40);
    [self.view addSubview:topBar];
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;
    
    [tool addButtonToView:self.view withTitle:@"主营收入" Tag:MainIncome frame:CGRectMake(SCREEN_HEIGHT-403,iOS7H1,100,31) andFun:@selector(selectIndustry:forEvent:) withType:UIButtonTypeRoundedRect andColor:@"#FFFEFE" textColor:@"#000000" normalBackGroundImg:@"mainIncomeBt" highBackGroundImg:@"selectedMainIncome"];
    
    [tool addButtonToView:self.view withTitle:@"运营费用" Tag:OperaFee frame:CGRectMake(SCREEN_HEIGHT-303,iOS7H1,100,31) andFun:@selector(selectIndustry:forEvent:) withType:UIButtonTypeRoundedRect andColor:@"#FFFEFE" textColor:@"#000000" normalBackGroundImg:@"mainFeeBt" highBackGroundImg:@"selectedMainfee"];
    
    [tool addButtonToView:self.view withTitle:@"运营资本" Tag:OperaCap frame:CGRectMake(SCREEN_HEIGHT-203,iOS7H1,100,31) andFun:@selector(selectIndustry:forEvent:) withType:UIButtonTypeRoundedRect andColor:@"#FFFEFE" textColor:@"#000000" normalBackGroundImg:@"mainFeeBt" highBackGroundImg:@"selectedMainfee"];
    
    self.discountBt=[tool addButtonToView:self.view withTitle:@"折现率" Tag:DiscountRate frame:CGRectMake(SCREEN_HEIGHT-103,iOS7H1,100,31) andFun:@selector(selectIndustry:forEvent:) withType:UIButtonTypeRoundedRect andColor:@"#FFFEFE" textColor:@"#000000" normalBackGroundImg:@"discountBt" highBackGroundImg:@"selectedDiscount"];
    [self.discountBt setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [tool addButtonToView:self.view withTitle:@"返回" Tag:BackToSuperView frame:CGRectMake(10,iOS7H1,50,32) andFun:@selector(chartAction:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"backBt" highBackGroundImg:nil];
    
    saveBt=[tool addButtonToView:self.view withTitle:@"保存" Tag:SaveData frame:CGRectMake(SCREEN_HEIGHT-62,iOS7H2,54,26) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#d0d1d2" textColor:@"#FFFEFE" normalBackGroundImg:@"saveBt" highBackGroundImg:nil];
    
    self.linkBt=[tool addButtonToView:self.view withTitle:@"点动" Tag:DragChartType frame:CGRectMake(SCREEN_HEIGHT-180,iOS7H2,54,26) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#2bc0a7" textColor:@"#FFFEFE" normalBackGroundImg:@"resetBt" highBackGroundImg:nil];
    
    self.resetBt=[tool addButtonToView:self.view withTitle:@"复位" Tag:ResetChart frame:CGRectMake(SCREEN_HEIGHT-121,iOS7H2,54,26) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#2bc0a7" textColor:@"#FFFEFE" normalBackGroundImg:@"resetBt" highBackGroundImg:nil];
    
    int iOSHeightStatusBar;
    iOSHeightStatusBar=20;
    
    //公司名称label
    CGSize labelsize1 = [tool getLabelSizeFromString:netComInfo[@"CompanyName"] font:@"Heiti SC" fontSize:14.0];
    //公司股票行业label
    //CGSize labelsize2 = [tool getLabelSizeFromString:[NSString stringWithFormat:@"(%@.%@)",netComInfo[@"StockCode"],netComInfo[@"Market"]] font:@"Heiti SC" fontSize:11.0];
//    float maxWidthLenght=MAX(labelsize1.width,labelsize2.width);
    
    UILabel *comNameLabel=[tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"%@",netComInfo[@"CompanyName"]] Tag:0 frame:CGRectMake(0,40+iOSHeightStatusBar,SCREEN_HEIGHT-320,35) fontSize:14.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
    comNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    comNameLabel.numberOfLines = 0;
    
    [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"(%@.%@)",netComInfo[@"StockCode"],netComInfo[@"Market"]] Tag:0 frame:CGRectMake(0,75+iOSHeightStatusBar,SCREEN_HEIGHT-320,15) fontSize:11.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###0.##"];
    NSString *ggPrice=[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:@([netComInfo[@"GooguuValuation"] floatValue])]];
    
    CGFloat companyNameLabelLenght=SCREEN_HEIGHT-320;
    //估值label
    CGSize defaultGGpriceLabelSize=[tool getLabelSizeFromString:@"估股估值:HK$" font:@"Heiti SC" fontSize:10.0];
    //估值数值label
    NSString *defaultGprice=[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:@([netComInfo[@"GooguuValuation"] floatValue])]];
    CGSize defaultPriceLabelSize=[tool getLabelSizeFromString:defaultGprice font:@"Heiti SC" fontSize:10.0];
    [tool addLabelToView:self.view withTitle:@"估股估值:HK$" Tag:11 frame:CGRectMake(companyNameLabelLenght+40,43+(40+labelsize1.height)/2-defaultGGpriceLabelSize.height+iOSHeightStatusBar,defaultGGpriceLabelSize.width,defaultGGpriceLabelSize.height) fontSize:10.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    
    [tool addLabelToView:self.view withTitle:defaultGprice Tag:11 frame:CGRectMake(companyNameLabelLenght+defaultGGpriceLabelSize.width+40,43+(40+labelsize1.height)/2-defaultGGpriceLabelSize.height+defaultGGpriceLabelSize.height-defaultPriceLabelSize.height+iOSHeightStatusBar,defaultPriceLabelSize.width,defaultPriceLabelSize.height) fontSize:10.0 color:nil textColor:@"#e18e14" location:NSTextAlignmentLeft];
    
    //我的估值label
    CGSize myGGpriceLabelSize=[tool getLabelSizeFromString:@"我的估值:HK$" font:@"Heiti SC" fontSize:10.0];
    //我的估值数值label
    CGSize priceLabelSize=[tool getLabelSizeFromString:ggPrice font:@"Heiti SC" fontSize:13.0];
    priceLabelSize.width=priceLabelSize.width+25;
    //CGFloat priceLabelTap=300-myGGpriceLabelSize.width-priceLabelSize.width-5;
    
    myGGpriceLabel=[tool addLabelToView:self.view withTitle:@"我的估值:HK$" Tag:11 frame:CGRectMake(companyNameLabelLenght+40,74+iOSHeightStatusBar,myGGpriceLabelSize.width+3,myGGpriceLabelSize.height) fontSize:10.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    priceLabel=[tool addLabelToView:self.view withTitle:@"" Tag:11 frame:CGRectMake(companyNameLabelLenght+40+myGGpriceLabelSize.width,74+myGGpriceLabelSize.height-priceLabelSize.height+iOSHeightStatusBar,priceLabelSize.width+10,priceLabelSize.height) fontSize:13.0 color:nil textColor:@"#e18e14" location:NSTextAlignmentLeft];
    if(self.sourceType!=MySavedType){
        [myGGpriceLabel setHidden:YES];
        [priceLabel setHidden:YES];
    }
 
    //市场价label
    CGSize markPriceLabelSize=[tool getLabelSizeFromString:@"市场价:HK$" font:@"Heiti SC" fontSize:10.0];
    [tool addLabelToView:self.view withTitle:@"市场价:HK$" Tag:11 frame:CGRectMake(companyNameLabelLenght+40,45+iOSHeightStatusBar,markPriceLabelSize.width,markPriceLabelSize.height) fontSize:10.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    
    //市场价数值label
    CGSize markPriceSize=[tool getLabelSizeFromString:[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:@([netComInfo[@"MarketPrice"] floatValue])]] font:@"Heiti SC" fontSize:10.0];
    [tool addLabelToView:self.view withTitle:[numberFormatter stringFromNumber:@([netComInfo[@"MarketPrice"] floatValue])] Tag:11 frame:CGRectMake(companyNameLabelLenght+40+markPriceLabelSize.width,45+iOSHeightStatusBar,markPriceSize.width,markPriceSize.height) fontSize:10.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    
    [self addScatterChart];
    if ([Utiles isNetConnected]) {
        [self.discountBt setEnabled:YES];
    }
    
    SAFE_RELEASE(topBar);
    SAFE_RELEASE(tool);
    SAFE_RELEASE(numberFormatter);
    
}

#pragma mark -
#pragma Button Clicked Methods
-(void)chartAction:(UIButton *)bt{
    //NSLog(@"chartAction");
    bt.showsTouchWhenHighlighted=YES;
    if(bt.tag==SaveData){
        
        id combinedData=[DrawChartTool changedDataCombinedWebView:self.webView comInfo:comInfo ggPrice:self.priceLabel.text dragChartChangedDriverIds:self.changedDriverIds disCountIsChanged:self.disCountIsChanged];
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",[combinedData JSONString],@"data", nil];

        [Utiles postNetInfoWithPath:@"AddModelData" andParams:params besidesBlock:^(id resObj){
            if([resObj[@"status"] isEqual:@"1"]){
                [bt setBackgroundImage:[UIImage imageNamed:@"savedBt"] forState:UIControlStateNormal];
                [bt setEnabled:NO];
                _isSaved=YES;
                [Utiles showToastView:self.view withTitle:nil andContent:resObj[@"msg"] duration:1.5];
            }else if([resObj[@"status"] isEqual:@"2"]){
                [Utiles showToastView:self.view withTitle:nil andContent:resObj[@"msg"] duration:1.5];
            }else{
                [Utiles showToastView:self.view withTitle:nil andContent:@"保存失败" duration:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"用户未登录" duration:1.5];
        }];
        [self.changedDriverIds removeAllObjects];
        
    }else if(bt.tag==DragChartType){
        if(linkage){
            [bt setTitle:@"联动" forState:UIControlStateNormal];
            [self addBarChart];
            linkage=NO;
        }else{
            [bt setTitle:@"点动" forState:UIControlStateNormal];
            [self addScatterChart];
            linkage=YES;
        }
    }else if(bt.tag==ResetChart){
        [self.forecastPoints removeAllObjects];
        for(id obj in self.forecastDefaultPoints){
            [self.forecastPoints addObject:[obj mutableCopy]];
        }
        [self.forecastPoints removeObjectAtIndex:0];
        [self.hisPoints lastObject][@"v"] = (self.forecastDefaultPoints)[1][@"v"];
        [self addToDriverIds:globalDriverId];
        [self setStockPrice];
        [self setXYAxis];
    }else if(bt.tag==BackToSuperView){
        bt.showsTouchWhenHighlighted=YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)selectIndustry:(UIButton *)sender forEvent:(UIEvent*)event{
    //NSLog(@"selectIndustry");
    sender.showsTouchWhenHighlighted=YES;
	//CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    //floatingController.frameSize=CGSizeMake(280,280);
    //floatingController.frameColor=[Utiles colorWithHexString:@"#e26b17"];
    if(sender.tag==MainIncome){
        modelMainViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:modelMainViewController animated:YES completion:nil];
    }else if(sender.tag==OperaFee){
        modelFeeViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:modelFeeViewController animated:YES completion:nil];
    }else if(sender.tag==OperaCap){
        modelCapViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:modelCapViewController animated:YES completion:nil];
    }else if(sender.tag==DiscountRate){
        NSString *values=[Utiles getObjectDataFromJsFun:self.webView funName:@"getValues" byData:nil shouldTrans:NO];
        if (SCREEN_HEIGHT>500) {
            rateViewController=[[DiscountRateViewController alloc] initWithNibName:@"DiscountRateView5" bundle:nil];
            rateViewController.view.frame=CGRectMake(0,60,SCREEN_HEIGHT,SCREEN_WIDTH-60);
        } else {
            rateViewController=[[DiscountRateViewController alloc] initWithNibName:@"DiscountRateView" bundle:nil];
            rateViewController.view.frame=CGRectMake(0,60,SCREEN_HEIGHT,SCREEN_WIDTH-60);
        }   
        rateViewController.jsonData=self.jsonForChart;
        rateViewController.valuesStr=values;
        rateViewController.dragChartChangedDriverIds=self.changedDriverIds;
        rateViewController.chartViewController=self;
        rateViewController.sourceType=ChartViewType;
        [self addDiscountView];
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"webViewDidFinishLoad");
    webIsLoaded=YES;
    [MBProgressHUD showHUDAddedTo:self.hostView animated:YES];
    NSDictionary *params=@{@"stockCode": comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        
        netComInfo=resObj[@"info"];
        [self initChartViewComponents];
        
        self.jsonForChart=[resObj JSONString];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        id resTmp=[Utiles getObjectDataFromJsFun:self.webView funName:@"initData" byData:self.jsonForChart shouldTrans:YES];
        
        self.industryClass=resTmp;
        id transObj=resTmp;
        self.modelMainViewController.jsonData=transObj;
        self.modelFeeViewController.jsonData=transObj;
        self.modelCapViewController.jsonData=transObj;
        self.modelMainViewController.indicator=@"listMain";
        self.modelFeeViewController.indicator=@"listFee";
        self.modelCapViewController.indicator=@"listCap";
        
        if(globalDriverId==0){
            globalDriverId=self.industryClass[@"listMain"][0][@"id"];
        }
        if(self.sourceType==MySavedType){
            [self adjustChartDataForSaved:comInfo[@"stockcode"] andToken:[Utiles getUserToken]];
        }else{
            [self modelClassChanged:globalDriverId];
        }
    
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        if(!isAddGesture){
            //手势添加
            UIPanGestureRecognizer *panGr=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPan:)];
            [hostView addGestureRecognizer:panGr];
            [panGr release];
            isAddGesture=YES;
        }
     
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        [self.discountBt setEnabled:NO];
        [self.saveBt setEnabled:NO];
        [self.resetBt setEnabled:NO];
        [self.linkBt setEnabled:NO];
    }];
    
    
}

#pragma mark -
#pragma mark ModelClass Methods Delegate
-(void)modelClassChanged:(NSString *)driverId isShowDisView:(BOOL)isShow{
    self.isShowDiscountView=isShow;
    [self modelClassChanged:driverId];
}
-(void)modelClassChanged:(NSString *)driverId{
    //NSLog(@"modelClassChanged");
    id chartData=[Utiles getObjectDataFromJsFun:self.webView funName:@"returnChartData" byData:driverId shouldTrans:YES];
    globalDriverId=driverId;
    
    [self divideData:chartData];
 
    self.trueUnit=chartData[@"unit"];
    NSArray *sort=[Utiles arrSort:self.forecastPoints];
    self.yAxisUnit=[Utiles getUnitFromData:[[[sort lastObject] objectForKey:@"v"] stringValue] andUnit:self.trueUnit];
    
    graph.title=[NSString stringWithFormat:@"%@(单位:%@)",chartData[@"title"],self.yAxisUnit];
    [self setXYAxis];
    [self setStockPrice];
    [self removeDiscountView];
}

#pragma mark -
#pragma mark General Methods
-(void)divideData:(id)sourceData{
    //NSLog(@"divideData");
    @try {
        [self.hisPoints removeAllObjects];
        [self.forecastDefaultPoints removeAllObjects];
        [self.forecastPoints removeAllObjects];
        //构造折点数据键值对 key：年份 value：估值 方便后面做临近折点的判断
        NSMutableDictionary *mutableObj=nil;
        for(id obj in sourceData[@"array"]){
            mutableObj=[[NSMutableDictionary alloc] initWithDictionary:obj];
            if([mutableObj[@"h"] boolValue]){
                [self.hisPoints addObject:mutableObj];
            }else{
                [self.forecastDefaultPoints addObject:[[mutableObj mutableCopy] autorelease]];
            }
        }
        for(id obj in sourceData[@"arraynew"]){
            mutableObj=[[NSMutableDictionary alloc] initWithDictionary:obj];
            [self.forecastPoints addObject:mutableObj];
        }
        //历史数据与预测数据线拼接
        [self.forecastDefaultPoints insertObject:[self.hisPoints lastObject] atIndex:0];
        //[self.forecastPoints insertObject:[self.hisPoints lastObject] atIndex:0];
        [self.hisPoints addObject:self.forecastPoints[0]];
        SAFE_RELEASE(mutableObj);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}



-(void)adjustChartDataForSaved:(NSString *)stockCode andToken:(NSString*)token{
    //NSLog(@"adjustChartDataForSaved");
    NSDictionary *params=@{@"stockcode": stockCode,@"token": token,@"from": @"googuu"};
    [Utiles getNetInfoWithPath:@"AdjustedData" andParams:params besidesBlock:^(id resObj){
        if(resObj!=nil){
            id saveData=resObj[@"data"];
            modelMainViewController.savedData=saveData;
            modelCapViewController.savedData=saveData;
            modelFeeViewController.savedData=saveData;
            for(id data in saveData){
                id tempChartData=data[@"data"];
                NSString *chartStr=[tempChartData JSONString];
                chartStr=[chartStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [Utiles getObjectDataFromJsFun:self.webView funName: @"chartCalu" byData:chartStr shouldTrans:NO];
            }
            if(self.wantSavedType==DiscountSaved){
                [self.discountBt sendActionsForControlEvents: UIControlEventTouchUpInside];
            }else{
                [self modelClassChanged:globalDriverId];
            }
                
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)setStockPrice{
    //NSLog(@"setStockPrice");
    NSString *jsonPrice=[self.forecastPoints JSONString];
    jsonPrice=[jsonPrice stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *backInfo=[Utiles getObjectDataFromJsFun:self.webView funName:@"chartCalu" byData:jsonPrice shouldTrans:NO];
    if(self.sourceType==MySavedType){
        //[self.myGGpriceLabel setText:@"我的估值"];
    }
    @try {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###0.##"];
        NSString *ggPrice = [numberFormatter stringFromNumber:[numberFormatter numberFromString:backInfo]];
        [self.priceLabel setText:ggPrice];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)viewPan:(UIPanGestureRecognizer *)tapGr
{
    //NSLog(@"viewPan");
    CGPoint now=[tapGr locationInView:self.view];
    CGPoint change=[tapGr translationInView:self.view];
    CGPoint coordinate=[self CoordinateTransformRealToAbstract:now];
    
    if(tapGr.state==UIGestureRecognizerStateBegan){
        [self.standard removeAllObjects];
        for(id obj in self.forecastPoints){
            [self.standard addObject:obj[@"v"]];
        }
        
    }else if(tapGr.state==UIGestureRecognizerStateEnded){
        [self.standard removeAllObjects];
        
        for(id obj in self.forecastPoints){
            double v = [obj[@"v"] doubleValue];
            [self.standard addObject:@(v)];
        }
        //结束拖动重绘坐标轴 适应新尺寸
        [self setXYAxis];
    }
    //手势变化并且接近折点旁边
    if([tapGr state]==UIGestureRecognizerStateChanged){
        
        coordinate.x=(int)(coordinate.x+0.5);
        
        int subscript=coordinate.x-[[self.hisPoints lastObject][@"y"] integerValue];
        
        subscript=subscript<0?0:subscript;
        subscript=subscript>=[self.forecastPoints count]-1?[self.forecastPoints count]-1:subscript;
        NSAssert(subscript<=[self.forecastPoints count]-1&&coordinate.x>=0,@"over bounds");
        
        if(linkage){
            double l4 = YRANGELENGTH*change.y/hostView.frame.size.height/ (1 - exp(-2));
            
            double l7 = 2 / ([(self.forecastPoints)[subscript][@"y"] doubleValue]);
            int i=0;
            for(id obj in self.forecastPoints){
                double v = [obj[@"v"] doubleValue];
                v =[(self.standard)[i] doubleValue]- l4 * (1 - exp(-l7 * (i+1)));
                obj[@"v"] = @(v);
                if(i==0){
                    [self.hisPoints lastObject][@"v"] = @(v);
                }
                i++;
            }
            
            [self setStockPrice];
            [graph reloadData];
            
        }else{
            
            double changeD=-YRANGELENGTH*change.y/hostView.frame.size.height;
            double v=[(self.standard)[subscript] doubleValue]+changeD;
            (self.forecastPoints)[subscript][@"v"] = @(v);
            if(subscript==0){
                [self.hisPoints lastObject][@"v"] = @(v);
            }
            [self setStockPrice];
            [graph reloadData];
            
        }
        [self.myGGpriceLabel setHidden:NO];
        [self.priceLabel setHidden:NO];
        if(_isSaved){
            [saveBt setEnabled:YES];
            [saveBt setBackgroundImage:[UIImage imageNamed:@"saveBt"] forState:UIControlStateNormal];
            _isSaved=NO;
        }
        [self addToDriverIds:globalDriverId];
    }
    
}

#pragma mark -
#pragma mark Line Data Source Delegate


// 添加数据标签
-( CPTLayer *)dataLabelForPlot:( CPTPlot *)plot recordIndex:( NSUInteger )index
{
    // 定义一个白色的 TextStyle
    static CPTMutableTextStyle *whiteText = nil ;
    if ( !whiteText ) {
        whiteText = [[ CPTMutableTextStyle alloc ] init ];
        whiteText.color=[CPTColor blackColor];
        whiteText.fontName=@"Heiti SC";
        whiteText.fontSize=10.0;
    }
    // 定义一个 TextLayer
    CPTTextLayer *newLayer = nil ;
    NSString * identifier=( NSString *)[plot identifier];
    if ([identifier isEqualToString : FORECAST_DATALINE_IDENTIFIER]) {
        newLayer=[[CPTTextLayer alloc] initWithText:[self formatTrans:index from:self.forecastPoints] style:whiteText];
    }else if([identifier isEqualToString : HISTORY_DATALINE_IDENTIFIER]){
        newLayer=[[CPTTextLayer alloc] initWithText:[self formatTrans:index from:self.hisPoints] style:whiteText];
    }
    return [newLayer autorelease];
}

-(NSString *)formatTrans:(NSUInteger)index from:(NSMutableArray *)arr{
    NSString *numberString =nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    if([self.trueUnit isEqualToString:@"%"]){
        [formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
        numberString = [formatter stringFromNumber:@([arr[index][@"v"] floatValue])];
        SAFE_RELEASE(formatter);
    }else{
        numberString=[arr[index][@"v"] stringValue];
        numberString=[Utiles unitConversionData:numberString andUnit:self.yAxisUnit trueUnit:self.trueUnit];
    }
    return numberString;
}



//散点数据源委托实现
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    
    if([(NSString *)plot.identifier isEqualToString:FORECAST_DEFAULT_DATALINE_IDENTIFIER]){
        return [self.forecastDefaultPoints count];
    }else if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        return [self.hisPoints count];
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DATALINE_IDENTIFIER]){
        return [self.forecastPoints count];
    }else{
        return [self.forecastPoints count];
    }
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.hisPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.hisPoints)[index] valueForKey:@"v"];
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.forecastPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastPoints)[index] valueForKey:@"v"];
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DEFAULT_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.forecastDefaultPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastDefaultPoints)[index] valueForKey:@"v"];
        }
    }else if([(NSString *)plot.identifier isEqualToString:COLUMNAR_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        if([key isEqualToString:@"x"]){
            num=@([[(self.forecastPoints)[index] valueForKey:@"y"] doubleValue]+0.5);
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastPoints)[index] valueForKey:@"v"];
        }
        
    }
    
    return  num;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}

//空间坐标转换:实际坐标转化自定义坐标
-(CGPoint)CoordinateTransformRealToAbstract:(CGPoint)point{
    
    float viewWidth=hostView.frame.size.width;
    float viewHeight=hostView.frame.size.height;
    
    point.y=point.y-HOSTVIEWTOPPAD;
    
    float coordinateX=(XRANGELENGTH*point.x)/viewWidth+XRANGEBEGIN;
    float coordinateY=YRANGELENGTH-((YRANGELENGTH*point.y)/(viewHeight-GRAPAHBOTTOMPAD-GRAPAHTOPPAD))+YRANGEBEGIN;
    
    return CGPointMake(coordinateX,coordinateY);
}
//空间坐标转换:自定义坐标转化实际坐标
-(CGPoint)CoordinateTransformAbstractToReal:(CGPoint)point{
    
    float viewWidth=hostView.frame.size.width;
    float viewHeight=hostView.frame.size.height;
    
    float coordinateX=(point.x-XRANGEBEGIN)*viewWidth/XRANGELENGTH;
    float coordinateY=(-1)*(point.y-YRANGEBEGIN-YRANGELENGTH)*(viewHeight-GRAPAHBOTTOMPAD-GRAPAHTOPPAD)/YRANGELENGTH;
    
    return CGPointMake(coordinateX,coordinateY);
    
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    if(axis.coordinate==CPTCoordinateX){
        
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
            //newStyle.color=[CPTColor colorWithComponentRed:129/255.0 green:122/255.0 blue:107/255.0 alpha:1.0];
            positiveStyle  = newStyle;
            
            theLabelTextStyle = positiveStyle;
            
            NSString * labelString      = [Utiles yearFilled:[formatter stringForObjectValue:tickLocation]];
            
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
            //[newLabelLayer sizeThatFits];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             =  3;
            newLabel.rotation     = 0;
            [newLabels addObject:newLabel];
        }
        
        axis.axisLabels = newLabels;
    }else{
        
        
    }
    return NO;
}


-(void)setXYAxis{
    //NSLog(@"setXYAxis");
    @try {
        NSMutableArray *xTmp=[[NSMutableArray alloc] init];
        NSMutableArray *yTmp=[[NSMutableArray alloc] init];
        for(id obj in self.hisPoints){
            [xTmp addObject:obj[@"y"]];
            [yTmp addObject:obj[@"v"]];
        }
        for(id obj in self.forecastPoints){
            [xTmp addObject:obj[@"y"]];
            [yTmp addObject:obj[@"v"]];
        }
        
        NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:DragabelModel screenWidth:205];
        XRANGEBEGIN=[xyDic[@"xBegin"] floatValue];
        XRANGELENGTH=[xyDic[@"xLength"] floatValue];
        XORTHOGONALCOORDINATE=[xyDic[@"xOrigin"] floatValue];
        XINTERVALLENGTH=[xyDic[@"xInterval"] floatValue];
        YRANGEBEGIN=[xyDic[@"yBegin"] floatValue];
        YRANGELENGTH=[xyDic[@"yLength"] floatValue];
        YORTHOGONALCOORDINATE=[[self.hisPoints lastObject][@"y"] floatValue];
        YINTERVALLENGTH=[xyDic[@"yInterval"] floatValue];
        DrawXYAxis;
        SAFE_RELEASE(xTmp);
        SAFE_RELEASE(yTmp);
        [graph reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)addBarChart{
    NSLog(@"addBarChart");
    if(![graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit=0.0f;
        lineStyle.lineWidth=0.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        
        barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:153/255.0 green:100/255.0 blue:49/255.0 alpha:0.3] horizontalBars:NO];
        barPlot.baseValue  = CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
        barPlot.dataSource = self;
        barPlot.barOffset  = CPTDecimalFromFloat(-0.5f);
        barPlot.lineStyle=lineStyle;
        barPlot.fill=[CPTFill fillWithColor:[CPTColor colorWithComponentRed:174/255.0 green:10/255.0 blue:148/255.0 alpha:0.3]];
        barPlot.identifier = COLUMNAR_DATALINE_IDENTIFIER;
        barPlot.barWidth=CPTDecimalFromFloat(0.5f);
        [graph addPlot:barPlot];
        lineStyle.lineWidth=0.0f;
        forecastLinePlot.dataLineStyle=lineStyle;
        linkage=NO;
        [barPlot release];
    }
    
}

-(void)addScatterChart{
    //NSLog(@"addScatterChart");
    linkage=YES;
    if([graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        [graph removePlot:barPlot];
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        forecastLinePlot.dataLineStyle=lineStyle;
    }
    
    if(!([graph plotWithIdentifier:FORECAST_DATALINE_IDENTIFIER]&&[graph plotWithIdentifier:FORECAST_DEFAULT_DATALINE_IDENTIFIER])){
        
        //y. labelingPolicy = CPTAxisLabelingPolicyNone ;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        //修改折线图线段样式,创建可调整数据线段
        forecastLinePlot=[[[CPTScatterPlot alloc] init] autorelease];
        lineStyle.miterLimit=2.0f;
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        forecastLinePlot.dataLineStyle=lineStyle;
        forecastLinePlot.identifier=FORECAST_DATALINE_IDENTIFIER;
        //forecastLinePlot.labelOffset=5;
        forecastLinePlot.dataSource=self;//需实现委托
        //forecastLinePlot.delegate=self;
        
        //创建默认对比数据线
        lineStyle.lineWidth=1.0f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#9B9689" andAlpha:0.8];
        forecastDefaultLinePlot = [[CPTScatterPlot alloc] init];
        forecastDefaultLinePlot.dataLineStyle = lineStyle;
        forecastDefaultLinePlot.identifier = FORECAST_DEFAULT_DATALINE_IDENTIFIER;
        forecastDefaultLinePlot.dataSource = self;
        
        
        //创建历史数据线段
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:144/255.0 green:142/255.0 blue:140/255.0 alpha:1.0];
        historyLinePlot = [[CPTScatterPlot alloc] init];
        historyLinePlot.dataLineStyle = lineStyle;
        historyLinePlot.identifier = HISTORY_DATALINE_IDENTIFIER;
        historyLinePlot.dataSource = self;
        
        // Add plot symbols: 表示数值的符号的形状
        //
        CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:207/255.0 green:175/255.0 blue:114/255.0 alpha:1.0];
        symbolLineStyle.lineWidth = 1.0;
        
        CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill          = [CPTFill fillWithColor: [CPTColor colorWithComponentRed:222/255.0 green:119/255.0 blue:47/255.0 alpha:1.0]];
        plotSymbol.lineStyle     = symbolLineStyle;
        plotSymbol.size          = CGSizeMake(13, 13);
        
        forecastLinePlot.plotSymbol = plotSymbol;
        symbolLineStyle.lineColor = [CPTColor whiteColor];
        plotSymbol.fill          = [CPTFill fillWithColor: [CPTColor whiteColor]];
        plotSymbol.size          = CGSizeMake(1, 1);
        historyLinePlot.plotSymbol=plotSymbol;
        
        [graph addPlot:forecastDefaultLinePlot];
        [graph addPlot:historyLinePlot];
        [graph addPlot:forecastLinePlot];
        
        [forecastLinePlot release];
        [forecastDefaultLinePlot release];
        [historyLinePlot release];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.hostView.frame=CGRectMake(5,110,SCREEN_HEIGHT-10,205);
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