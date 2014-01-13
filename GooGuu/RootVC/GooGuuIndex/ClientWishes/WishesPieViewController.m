//
//  WishesPieViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-13.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "WishesPieViewController.h"
#import "XYPieChart.h"

@interface WishesPieViewController ()

@end

@implementation WishesPieViewController

- (id)initWithComList:(NSArray *)coms
{
    self = [super init];
    if (self) {
        self.sliceColors =[NSArray arrayWithObjects:
                           [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                           [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                           [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                           [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                           [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
        
        self.slices = [NSMutableArray arrayWithCapacity:10];
        self.comList = coms;
        for (id obj in coms) {
            [self.slices addObject:obj[@"count"]];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"心愿榜投票结果";
	[self initComponents];
}

-(void)back:(UIButton *)bt {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initComponents {

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt setFrame:CGRectMake(10,10,50,30)];
    [bt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    XYPieChart *chartPie = [[[XYPieChart alloc] initWithFrame:CGRectMake(8,60,300,300)] autorelease];
    self.pieChart = chartPie;
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
    
    self.pieChart.showLabel = YES;
    self.pieChart.labelRadius = 80.0;
    self.pieChart.selectedSliceOffsetRadius = 10.0;
    self.pieChart.selectedSliceStroke = 8.0;
    //[self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //[self.pieChart setLabelShadowColor:[UIColor blackColor]];
    
    self.pieChart = chartPie;
    [self.view addSubview:self.pieChart];
    
    for (int i = 0;i < [self.comList count];i ++) {
        NSString *comName = self.comList[i][@"companyname"];
        UILabel *indicator = [[[UILabel alloc] initWithFrame:CGRectMake(60,380+35*i,250,20)] autorelease];
        indicator.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
        indicator.text = comName;
        
        UILabel *colorBlock = [[[UILabel alloc] initWithFrame:CGRectMake(20,380+35*i,15,15)] autorelease];
        colorBlock.backgroundColor = self.sliceColors[i];
    
        [self.view addSubview:colorBlock];
        [self.view addSubview:indicator];
    }
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate


- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    [Utiles showToastView:self.view withTitle:self.comList[index][@"companyname"] andContent:[NSString stringWithFormat:@"得票数%@",self.comList[index][@"count"]] duration:1.0];
}



-(BOOL)shouldAutorotate{
    return NO;
}













- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
