//
//  Chart3ViewController.m
//  Chart1.3
//
//  Created by Xcode on 13-4-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  公司详细页图表绘制

#import "ChartViewController.h"
#import "ModelViewController.h"
#import "DrawChartTool.h"
#import "DiscountRateViewController.h"



@interface ChartViewController ()

@end

@implementation ChartViewController

static NSString * FORECAST_DATALINE_IDENTIFIER =@"forecast_dataline_identifier";
static NSString * FORECAST_DEFAULT_DATALINE_IDENTIFIER =@"forecast_default_dataline_identifier";
static NSString * HISTORY_DATALINE_IDENTIFIER =@"history_dataline_identifier";
static NSString * COLUMNAR_DATALINE_IDENTIFIER =@"columnar_dataline_identifier";


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
        if(!self.isShowDiscountView){
            self.isShowDiscountView=YES;
            [self.discountBt setEnabled:NO];
            [self.view addSubview:self.rateViewController.view];
        }
    }else{
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
}
-(void)removeDiscountView{
    if(self.isShowDiscountView){
        self.isShowDiscountView=NO;
        [self.discountBt setEnabled:YES];
        [self.rateViewController.view removeFromSuperview];
    }
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if(self.webIsLoaded){
        if(![Utiles isBlankString:self.valuesStr]){
            self.valuesStr=[self.valuesStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            [Utiles getObjectDataFromJsFun:self.webView funName:@"setValues" byData:self.valuesStr shouldTrans:NO];
            [self modelClassChanged:self.globalDriverId];
        }
    }
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.discountBt setEnabled:NO];
 
    [self initVariable];
    
    UIWebView *tempWeb = [[[UIWebView alloc] init] autorelease];
    self.webView = tempWeb;
    self.webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    
    [self initPlotSpace];
}
-(void)initVariable{

    self.changedDriverIds=[[NSMutableArray alloc] init];
    self.linkage=YES;
    self.isSaved=YES;
    self.webIsLoaded=NO;
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
    
    NSMutableArray *temp1 = [[[NSMutableArray alloc] init] autorelease];
    self.forecastPoints = temp1;
    NSMutableArray *temp2 = [[[NSMutableArray alloc] init] autorelease];
    self.hisPoints = temp2;
    NSMutableArray *temp3 = [[[NSMutableArray alloc] init] autorelease];
    self.forecastDefaultPoints = temp3;
    NSMutableArray *temp4 = [[[NSMutableArray alloc] init] autorelease];
    self.standard = temp4;
    
    //初始化图形视图
    CPTXYGraph *tempG = [[[CPTXYGraph alloc] initWithFrame:CGRectZero] autorelease];
    self.graph = tempG;
    self.graph.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#F0F8FF" andAlpha:1.0]];

    CPTGraphHostingView *tempHost = [[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(0,40,SCREEN_WIDTH,270)] autorelease];
    self.hostView = tempHost;
    [self.view addSubview:self.hostView];
    [self.hostView setHostedGraph : self.graph ];
    
    self.graph . paddingLeft = 0.0f ;
    self.graph . paddingRight = 0.0f ;
    self.graph . paddingTop = 0 ;
    self.graph . paddingBottom = GRAPAHBOTTOMPAD ;
    
    //绘制图形空间
    self.plotSpace=(CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    DrawXYAxis;
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

-(void)initChartViewComponents{

    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_HEIGHT,44)] autorelease];
    
    UIBarButtonItem *backButton = [self addBarButton:@"返回" tag:BackToSuperView];
    UIBarButtonItem *mainIncomeButton = [self addBarButton:@"主营收入" tag:MainIncome];
    UIBarButtonItem *operaFeeButton = [self addBarButton:@"运营费用" tag:OperaFee];
    UIBarButtonItem *operaCapButton = [self addBarButton:@"运营资本" tag:OperaCap];
    UIBarButtonItem *discountRateButton = [self addBarButton:@"折现率" tag:DiscountRate];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    [toolBar setItems:@[backButton,flexibleSpace,mainIncomeButton,operaFeeButton,operaCapButton,discountRateButton]];
    [self.view addSubview:toolBar];
    
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;

    self.saveBt=[tool addButtonToView:self.view withTitle:@"保存" Tag:SaveData frame:CGRectMake(SCREEN_HEIGHT-62,49,54,26) andFun:@selector(chartAction:)];
    
    self.linkBt=[tool addButtonToView:self.view withTitle:@"点动" Tag:DragChartType frame:CGRectMake(SCREEN_HEIGHT-180,49,54,26) andFun:@selector(chartAction:)];
    
    self.resetBt=[tool addButtonToView:self.view withTitle:@"复位" Tag:ResetChart frame:CGRectMake(SCREEN_HEIGHT-121,49,54,26) andFun:@selector(chartAction:)];

    UILabel *comNameLabel=[tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"%@\n(%@.%@)",self.netComInfo[@"CompanyName"],self.netComInfo[@"StockCode"],self.netComInfo[@"Market"]] frame:CGRectMake(0,44,SCREEN_HEIGHT-300,45) fontSize:15.0 textColor:@"#63573d" location:NSTextAlignmentCenter];
    comNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    comNameLabel.numberOfLines = 0;
    
    //市场价label
    [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"市场价::%.2f",[self.netComInfo[@"MarketPrice"] floatValue]] frame:CGRectMake(SCREEN_HEIGHT-300,44,110,22) fontSize:12.0 textColor:@"#817a6b" location:NSTextAlignmentLeft];
    //估值数值label
    [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"估股估值::%.2f",[self.netComInfo[@"GooguuValuation"] floatValue]] frame:CGRectMake(SCREEN_HEIGHT-300,67,100,22) fontSize:11.0 textColor:@"#817a6b" location:NSTextAlignmentLeft];
    
    self.myGGpriceLabel=[tool addLabelToView:self.view withTitle:@"我的估值:" frame:CGRectMake(80,0,60,44) fontSize:14.0 textColor:@"#817a6b" location:NSTextAlignmentCenter];
    self.priceLabel=[tool addLabelToView:self.view withTitle:@"" frame:CGRectMake(140,0,SCREEN_HEIGHT-400,44) fontSize:18.0 textColor:@"#e18e14" location:NSTextAlignmentCenter];
    if(self.sourceType!=MySavedType){
        [self.myGGpriceLabel setHidden:YES];
        [self.priceLabel setHidden:YES];
    }

    [self addScatterChart];
    if ([Utiles isNetConnected]) {
        [self.discountBt setEnabled:YES];
    }

    SAFE_RELEASE(tool);
}

#pragma mark -
#pragma Button Clicked Methods
-(void)chartAction:(UIButton *)bt{

    if(bt.tag==SaveData){
        
        id combinedData=[DrawChartTool changedDataCombinedWebView:self.webView comInfo:self.comInfo ggPrice:self.priceLabel.text dragChartChangedDriverIds:self.changedDriverIds disCountIsChanged:self.disCountIsChanged];
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",[combinedData JSONString],@"data", nil];

        [Utiles postNetInfoWithPath:@"AddModelData" andParams:params besidesBlock:^(id resObj){
            if([resObj[@"status"] isEqual:@"1"]){
                [bt setBackgroundColor:[UIColor grayColor]];
                [bt setEnabled:NO];
                self.isSaved=YES;
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
        if(self.linkage){
            [bt setTitle:@"联动" forState:UIControlStateNormal];
            [self addBarChart];
            self.linkage=NO;
        }else{
            [bt setTitle:@"点动" forState:UIControlStateNormal];
            [self addScatterChart];
            self.linkage=YES;
        }
    }else if(bt.tag==ResetChart){
        [self.forecastPoints removeAllObjects];
        for(id obj in self.forecastDefaultPoints){
            [self.forecastPoints addObject:[obj mutableCopy]];
        }
        [self.forecastPoints removeObjectAtIndex:0];
        [self.hisPoints lastObject][@"v"] = (self.forecastDefaultPoints)[1][@"v"];
        [self addToDriverIds:self.globalDriverId];
        [self setStockPrice];
        [self setXYAxis];
    }
}



-(void)toolBarAction:(UIBarButtonItem *)bt{
    
    if (bt.tag == MainIncome) {
        
        self.modelMainViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:self.modelMainViewController animated:YES completion:nil];
    } else if(bt.tag == OperaFee) {
        
        self.modelFeeViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:self.modelFeeViewController animated:YES completion:nil];
    } else if(bt.tag == OperaCap) {
        
        self.modelCapViewController.isShowDiscountView=self.isShowDiscountView;
        [self presentViewController:self.modelCapViewController animated:YES completion:nil];
    } else if(bt.tag == DiscountRate) {
        
        NSString *values = [Utiles getObjectDataFromJsFun:self.webView funName:@"getValues" byData:nil shouldTrans:NO];
        if (SCREEN_HEIGHT > 500) {
            self.rateViewController = [[DiscountRateViewController alloc] initWithNibName:@"DiscountRateView5" bundle:nil];
            self.rateViewController.view.frame = CGRectMake(0,60,SCREEN_HEIGHT,SCREEN_WIDTH-60);
        } else {
            self.rateViewController = [[DiscountRateViewController alloc] initWithNibName:@"DiscountRateView" bundle:nil];
            self.rateViewController.view.frame = CGRectMake(0,60,SCREEN_HEIGHT,SCREEN_WIDTH-60);
        }
        self.rateViewController.comInfo = self.comInfo;
        self.rateViewController.jsonData = self.jsonForChart;
        self.rateViewController.valuesStr = values;
        self.rateViewController.dragChartChangedDriverIds = self.changedDriverIds;
        self.rateViewController.chartViewController = self;
        self.rateViewController.sourceType = ChartViewType;
        [self addDiscountView];
    } else if (bt.tag == BackToSuperView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"webViewDidFinishLoad");
    self.webIsLoaded=YES;
    [ProgressHUD show:nil];
    NSDictionary *params=@{@"stockCode": self.comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        
        self.netComInfo=resObj[@"info"];
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
        
        if(self.globalDriverId==0){
            self.globalDriverId=self.industryClass[@"listMain"][0][@"id"];
        }
        if(self.sourceType==MySavedType){
            [self adjustChartDataForSaved:self.comInfo[@"stockcode"] andToken:[Utiles getUserToken]];
        }else{
            [self modelClassChanged:self.globalDriverId];
        }
    
        [ProgressHUD dismiss];
        if(!self.isAddGesture){
            //手势添加
            UIPanGestureRecognizer *panGr=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPan:)];
            [self.hostView addGestureRecognizer:panGr];
            [panGr release];
            self.isAddGesture=YES;
        }
     
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [ProgressHUD dismiss];
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
    self.globalDriverId=driverId;
    
    [self divideData:chartData];
 
    self.trueUnit=chartData[@"unit"];
    NSArray *sort=[Utiles arrSort:self.forecastPoints];
    self.yAxisUnit=[Utiles getUnitFromData:[[[sort lastObject] objectForKey:@"v"] stringValue] andUnit:self.trueUnit];
    
    self.graph.title=[NSString stringWithFormat:@"%@(单位:%@)",chartData[@"title"],self.yAxisUnit];
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
            self.modelMainViewController.savedData=saveData;
            self.modelCapViewController.savedData=saveData;
            self.modelFeeViewController.savedData=saveData;
            for(id data in saveData){
                id tempChartData=data[@"data"];
                NSString *chartStr=[tempChartData JSONString];
                chartStr=[chartStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [Utiles getObjectDataFromJsFun:self.webView funName: @"chartCalu" byData:chartStr shouldTrans:NO];
            }
            if(self.wantSavedType==DiscountSaved){
                [self.discountBt sendActionsForControlEvents: UIControlEventTouchUpInside];
            }else{
                [self modelClassChanged:self.globalDriverId];
            }
                
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [ProgressHUD dismiss];
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
        
        if(self.linkage){
            double l4 = YRANGELENGTH*change.y/self.hostView.frame.size.height/ (1 - exp(-2));
            
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
            [self.graph reloadData];
            
        }else{
            
            double changeD=-YRANGELENGTH*change.y/self.hostView.frame.size.height;
            double v=[(self.standard)[subscript] doubleValue]+changeD;
            (self.forecastPoints)[subscript][@"v"] = @(v);
            if(subscript==0){
                [self.hisPoints lastObject][@"v"] = @(v);
            }
            [self setStockPrice];
            [self.graph reloadData];
            
        }
        [self.myGGpriceLabel setHidden:NO];
        [self.priceLabel setHidden:NO];
        if(self.isSaved){
            [self.saveBt setEnabled:YES];
            [self.saveBt setBackgroundColor:[UIColor tangerineColor]];
            self.isSaved=NO;
        }
        [self addToDriverIds:self.globalDriverId];
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
    
    float viewWidth=self.hostView.frame.size.width;
    float viewHeight=self.hostView.frame.size.height;
    
    point.y=point.y-HOSTVIEWTOPPAD;
    
    float coordinateX=(XRANGELENGTH*point.x)/viewWidth+XRANGEBEGIN;
    float coordinateY=YRANGELENGTH-((YRANGELENGTH*point.y)/(viewHeight-GRAPAHBOTTOMPAD-GRAPAHTOPPAD))+YRANGEBEGIN;
    
    return CGPointMake(coordinateX,coordinateY);
}
//空间坐标转换:自定义坐标转化实际坐标
-(CGPoint)CoordinateTransformAbstractToReal:(CGPoint)point{
    
    float viewWidth=self.hostView.frame.size.width;
    float viewHeight=self.hostView.frame.size.height;
    
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
        
        NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:DragabelModel screenHeight:205];
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
        [self.graph reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)addBarChart{

    if(![self.graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit=0.0f;
        lineStyle.lineWidth=0.0f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:1.0];
        
        self.barPlot = [CPTBarPlot tubularBarPlotWithColor:[Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:1.0] horizontalBars:NO];
        self.barPlot.baseValue  = CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
        self.barPlot.dataSource = self;
        self.barPlot.barOffset  = CPTDecimalFromFloat(-0.5f);
        self.barPlot.lineStyle=lineStyle;
        self.barPlot.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:0.5]];
        self.barPlot.identifier = COLUMNAR_DATALINE_IDENTIFIER;
        self.barPlot.barWidth=CPTDecimalFromFloat(0.3f);
        [self.graph addPlot:self.barPlot];
        lineStyle.lineWidth=0.0f;
        self.forecastLinePlot.dataLineStyle=lineStyle;
        self.linkage=NO;
    }
    
}

-(void)addScatterChart{
    //NSLog(@"addScatterChart");
    self.linkage=YES;
    if([self.graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        [self.graph removePlot:self.barPlot];
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:1.0];
        self.forecastLinePlot.dataLineStyle=lineStyle;
    }
    
    if(!([self.graph plotWithIdentifier:FORECAST_DATALINE_IDENTIFIER]&&[self.graph plotWithIdentifier:FORECAST_DEFAULT_DATALINE_IDENTIFIER])){
        
        //y. labelingPolicy = CPTAxisLabelingPolicyNone ;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        //修改折线图线段样式,创建可调整数据线段
        self.forecastLinePlot=[[[CPTScatterPlot alloc] init] autorelease];
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:1.0];
        self.forecastLinePlot.dataLineStyle=lineStyle;
        self.forecastLinePlot.identifier=FORECAST_DATALINE_IDENTIFIER;
        self.forecastLinePlot.labelOffset=5;
        self.forecastLinePlot.dataSource=self;//需实现委托
        //forecastLinePlot.delegate=self;
        
        //创建默认对比数据线
        lineStyle.lineWidth=0.8f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#9B9689" andAlpha:0.8];
        self.forecastDefaultLinePlot = [[CPTScatterPlot alloc] init];
        self.forecastDefaultLinePlot.dataLineStyle = lineStyle;
        self.forecastDefaultLinePlot.identifier = FORECAST_DEFAULT_DATALINE_IDENTIFIER;
        self.forecastDefaultLinePlot.dataSource = self;
        
        
        //创建历史数据线段
        lineStyle.lineWidth=1.5f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:144/255.0 green:142/255.0 blue:140/255.0 alpha:1.0];
        self.historyLinePlot = [[CPTScatterPlot alloc] init];
        self.historyLinePlot.dataLineStyle = lineStyle;
        self.historyLinePlot.identifier = HISTORY_DATALINE_IDENTIFIER;
        self.historyLinePlot.dataSource = self;
        self.historyLinePlot.labelOffset = 5;
        
        // Add plot symbols: 表示数值的符号的形状
        CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineColor = [Utiles cptcolorWithHexString:@"#1C6BA0" andAlpha:1.0];
        symbolLineStyle.lineWidth = 2;
        CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.lineStyle     = symbolLineStyle;
        plotSymbol.fill = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#F0F8FF" andAlpha:1.0]];
        plotSymbol.size          = CGSizeMake(13, 13);
        
        self.forecastLinePlot.plotSymbol = plotSymbol;
        symbolLineStyle.lineColor = [CPTColor whiteColor];
        plotSymbol.fill          = [CPTFill fillWithColor: [CPTColor whiteColor]];
        plotSymbol.size          = CGSizeMake(1, 1);
        self.historyLinePlot.plotSymbol=plotSymbol;
        
        [self.graph addPlot:self.forecastDefaultLinePlot];
        [self.graph addPlot:self.historyLinePlot];
        [self.graph addPlot:self.forecastLinePlot];
        
        [self.forecastLinePlot release];
        [self.forecastDefaultLinePlot release];
        [self.historyLinePlot release];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.hostView.frame=CGRectMake(5,90,SCREEN_HEIGHT-10,225);
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