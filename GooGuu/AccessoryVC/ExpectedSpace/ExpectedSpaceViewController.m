//
//  ExpectedSpaceViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-23.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ExpectedSpaceViewController.h"

@interface ExpectedSpaceViewController ()

@end

static NSString * UPBAR_IDENTIFIER =@"看多";
static NSString * DOWNBAR_IDENTIFIER =@"看空";

@implementation ExpectedSpaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backwwww {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initComponents];
    [self getExceptData];
}

-(void)initComponents {
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0,0,55,44);
    [bt setTitle:@"返回" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [bt addTarget:self action:@selector(backwwww) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBt = [[[UIBarButtonItem alloc] initWithCustomView:bt] autorelease];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60,0,SCREEN_HEIGHT-120,44)] autorelease];
    titleLabel.text = @"多空统计(历史四周)";
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_HEIGHT,44)] autorelease];
    [toolBar setItems:@[barBt]];
    [toolBar addSubview:titleLabel];
    [self.view addSubview:toolBar];
    
}

-(void)getExceptData {
    
    NSDictionary *params = @{
                             @"stockcode":self.stockCode
                             };
    [Utiles getNetInfoWithPath:@"ExpectedSpaceHisData" andParams:params besidesBlock:^(id obj) {

        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        for (id model in obj){
            [temp addObject:model];
        }
        NSComparator cmpSec = ^(id obj1, id obj2){
            if ([obj1[@"start"] longLongValue] > [obj2[@"start"] longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1[@"start"] longLongValue] < [obj2[@"start"] longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.expects = [temp sortedArrayUsingComparator:cmpSec];
        [self initBarChart];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)initBarChart{
    
    self.graph=[[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    self.graph.fill=[CPTFill fillWithColor:[CPTColor whiteColor]];
    
    self.hostView=[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(5,49,SCREEN_HEIGHT-10,265)];
    [self.view addSubview:self.hostView];
    [self.hostView setHostedGraph : self.graph ];
    self.graph . paddingLeft = 0.0f ;
    self.graph . paddingRight = 0.0f ;
    self.graph . paddingTop = 0 ;
    self.graph . paddingBottom = 0 ;
    self.graph.plotAreaFrame.paddingBottom += 10.0;
    self.graph.plotAreaFrame.paddingLeft += 40.0;

    [self initPlotSpace];
    [self initAxis];
    [self initBarPlot];
}

-(void)initAxis {

    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.6f;
    majorGridLineStyle.lineColor = [Utiles cptcolorWithHexString:@"#BDC3C7" andAlpha:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    {
        x.delegate = self;
        x.majorIntervalLength         = CPTDecimalFromInteger(1);
        x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
        //x.axisLineStyle               = nil;
        x.minorTickLineStyle          = nil;
        x.visibleRange   = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(4.0f)];
        x.plotSpace = self.plotSpace;
    }
    
    CPTXYAxis *y = axisSet.yAxis;
    {
        y.delegate = self;
        y.majorIntervalLength         = CPTDecimalFromFloat(0.2);
        y.minorTicksPerInterval       = 0;
        y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(-0.5);

        y.majorGridLineStyle          = majorGridLineStyle;
        y.minorGridLineStyle          = minorGridLineStyle;
        //y.axisLineStyle               = nil;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.labelOffset                 = 5.0;
        y.visibleRange   = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(1.2f)];

        y.plotSpace = self.plotSpace;
    }

}

-(void)initPlotSpace {

    CPTXYPlotSpace *barPlotSpace = [[[CPTXYPlotSpace alloc] init] autorelease];
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(4.0f)];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.06) length:CPTDecimalFromFloat(1.2f)];
    self.plotSpace = barPlotSpace;
    [self.graph addPlotSpace:self.plotSpace];
}

-(void)initBarPlot{

    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth = 0.65;
    barLineStyle.lineColor = [CPTColor blackColor];
    
    CPTBarPlot *barPlot = [[[CPTBarPlot alloc] init] autorelease];
    barPlot.lineStyle       = barLineStyle;
    barPlot.fill            = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#E74C3C" andAlpha:1.0]];
    barPlot.barWidth        = CPTDecimalFromFloat(0.5f);
    barPlot.delegate   = self;
    barPlot.dataSource = self;
    barPlot.identifier = DOWNBAR_IDENTIFIER;
    self.downBarPlot = barPlot;

    CPTBarPlot *barPlot2 = [[[CPTBarPlot alloc] init] autorelease];
    barPlot2.lineStyle = barLineStyle;
    barPlot2.fill = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#27AE60" andAlpha:1.0]];
    barPlot2.barWidth=CPTDecimalFromFloat(0.5f);
    barPlot2.identifier = UPBAR_IDENTIFIER;
    barPlot2.dataSource = self ;
    barPlot2.delegate = self;
    self.upBarPlot = barPlot2;
    
    
    [self.graph addPlot :barPlot2 toPlotSpace:self.plotSpace];
    [self.graph addPlot :barPlot toPlotSpace :self.plotSpace];
    
    // Add legend
    self.graph.legend                    = [CPTLegend legendWithGraph:self.graph];
    self.graph.legend.fill               = self.graph.plotAreaFrame.fill;
    self.graph.legend.borderLineStyle    = self.graph.plotAreaFrame.borderLineStyle;
    self.graph.legend.cornerRadius       = 5.0;
    self.graph.legend.swatchSize         = CGSizeMake(15.0, 15.0);
    self.graph.legend.swatchCornerRadius = 3.0;
    self.graph.legendAnchor              = CPTRectAnchorTopLeft;
    self.graph.legendDisplacement        = CGPointMake(40.0, 0.0);
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.expects count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num=nil;
    NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
    
    if([(NSString *)plot.identifier isEqualToString:UPBAR_IDENTIFIER]){

        if([key isEqualToString:@"x"]){
            num = [NSDecimalNumber numberWithInt:index];
        }else if([key isEqualToString:@"y"]){
            num = [NSDecimalNumber numberWithFloat:1.0];
        }
        
    }else {

        if([key isEqualToString:@"x"]){
            num = [NSDecimalNumber numberWithInt:index];
        }else if([key isEqualToString:@"y"]){
            float up = [self.expects[index][@"up"] floatValue];
            float down = [self.expects[index][@"down"] floatValue];
            float percent = down/(up+down);
            num = [NSDecimalNumber numberWithFloat:percent];
        }
        
    }
    
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx{
    if ([plot.identifier isEqual:UPBAR_IDENTIFIER]) {
        NSString *str = [NSString stringWithFormat:@"该周看多得票数为%@",self.expects[idx][@"up"]];
        [Utiles showToastView:self.view withTitle:nil andContent:str duration:1.0];
    } else {
        NSString *str = [NSString stringWithFormat:@"该周看空得票数为%@",self.expects[idx][@"down"]];
        [Utiles showToastView:self.view withTitle:nil andContent:str duration:1.0];
    }
}

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    if(axis.coordinate == CPTCoordinateX){

        NSMutableSet * newLabels        = [NSMutableSet set];
        for (NSDecimalNumber * tickLocation in locations) {
            
            NSString * labelString = @"";
            if ([tickLocation integerValue] > [self.expects count] -1 || [self.expects count] == 0) {
               labelString = @" ";
            } else {
                NSString *start = [Utiles secondToDate:[self.expects[[tickLocation integerValue]][@"start"] longLongValue]/1000];
                //NSString *end = [Utiles secondToDate:[self.expects[[tickLocation integerValue]][@"end"] longLongValue]/1000];
                labelString = [NSString stringWithFormat:@"%@",start];
            }
            
            CPTTextStyle *theLabelTextStyle;
            
            CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
            newStyle.fontSize=10.0;
            newStyle.fontName=@"Heiti SC";
            theLabelTextStyle  = newStyle;
            
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 3.0;
            newLabel.rotation     = 0;
            [newLabels addObject:newLabel];
            SAFE_RELEASE(newLabel);
            SAFE_RELEASE(newLabelLayer);
            
        }
        axis.axisLabels = newLabels;
    }else{
        NSMutableSet * newLabels        = [NSMutableSet set];
        for (NSDecimalNumber * tickLocation in locations) {
            NSString * labelString      = [NSString stringWithFormat:@"%.0f%%",[tickLocation floatValue]*100];
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 3.0;
            newLabel.rotation     = 0;
            [newLabels addObject:newLabel];
            SAFE_RELEASE(newLabel);
            SAFE_RELEASE(newLabelLayer);
        }
        axis.axisLabels = newLabels;
    }
    
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
