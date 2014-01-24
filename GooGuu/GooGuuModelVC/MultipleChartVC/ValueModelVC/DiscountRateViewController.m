//
//  DiscountRateViewController.m
//  估股
//
//  Created by Xcode on 13-8-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DiscountRateViewController.h"
#import "DrawChartTool.h"
#import "ChartViewController.h"


@interface DiscountRateViewController ()

@end

@implementation DiscountRateViewController

@synthesize isSaved;
@synthesize comInfo;
@synthesize disCountIsChanged;
@synthesize jsonData;
@synthesize valuesStr;
@synthesize defaultTransData;
@synthesize transData;
@synthesize webIsLoaded;
@synthesize dragChartChangedDriverIds;
@synthesize sourceType;

@synthesize resetBt;
@synthesize saveBt;
@synthesize backBt;

@synthesize companyNameLabel;
@synthesize marketPriceLabel;
@synthesize ggPriceLabel;
@synthesize suggestRateLabel;
@synthesize myRateLabel;
@synthesize unRiskRateLabel;
@synthesize marketBetaLabel;
@synthesize marketPremiumLabel;
@synthesize defaultUnRiskRateLabel;
@synthesize defaultMarketBetaLabel;
@synthesize defaultMarketPremiumLabel;
@synthesize unRiskRateMinLabel;
@synthesize unRiskRateMaxLabel;
@synthesize marketBetaMinLabel;
@synthesize marketBetaMaxLabel;
@synthesize marketPremiumMinLabel;
@synthesize marketPremiumMaxLabel;

@synthesize unRiskRateSlider;
@synthesize marketBetaSlider;
@synthesize marketPremiumSlider;

@synthesize webView;
@synthesize chartViewController;

- (void)dealloc
{
    SAFE_RELEASE(unRiskRateMinLabel);
    SAFE_RELEASE(unRiskRateMaxLabel);
    SAFE_RELEASE(marketBetaMinLabel);
    SAFE_RELEASE(marketBetaMaxLabel);
    SAFE_RELEASE(marketPremiumMinLabel);
    SAFE_RELEASE(marketPremiumMaxLabel);
    SAFE_RELEASE(defaultUnRiskRateLabel);
    SAFE_RELEASE(defaultMarketBetaLabel);
    SAFE_RELEASE(defaultMarketPremiumLabel);
    SAFE_RELEASE(dragChartChangedDriverIds);
    SAFE_RELEASE(chartViewController);
    SAFE_RELEASE(valuesStr);
    SAFE_RELEASE(defaultTransData);
    SAFE_RELEASE(comInfo);
    SAFE_RELEASE(transData);
    SAFE_RELEASE(webView);
    SAFE_RELEASE(companyNameLabel);
    SAFE_RELEASE(jsonData);
    SAFE_RELEASE(resetBt);
    SAFE_RELEASE(saveBt);
    SAFE_RELEASE(backBt);
    SAFE_RELEASE(marketPriceLabel);
    SAFE_RELEASE(ggPriceLabel);
    SAFE_RELEASE(suggestRateLabel);
    SAFE_RELEASE(myRateLabel);
    SAFE_RELEASE(unRiskRateLabel);
    SAFE_RELEASE(marketBetaLabel);
    SAFE_RELEASE(marketPremiumLabel);
    SAFE_RELEASE(unRiskRateSlider);
    SAFE_RELEASE(marketBetaSlider);
    SAFE_RELEASE(marketPremiumSlider);
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
    self.chartViewController.isShowDiscountView=NO;
    NSString *values=[Utiles getObjectDataFromJsFun:self.webView funName:@"getValues" byData:nil shouldTrans:NO];
    self.chartViewController.valuesStr=values;
    self.chartViewController.disCountIsChanged=self.disCountIsChanged;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webIsLoaded=NO;
    isSaved=NO;
    self.transData=[[NSMutableArray alloc] init];
    
    webView=[[UIWebView alloc] init];
    webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];

    [marketBetaSlider setMinimumTrackTintColor:[Utiles colorWithHexString:@"#EA7A1F"]];
    [marketBetaSlider setMaximumTrackTintColor:[Utiles colorWithHexString:@"#0B0B0B"]];
    [unRiskRateSlider setMinimumTrackTintColor:[Utiles colorWithHexString:@"#EA7A1F"]];
    [unRiskRateSlider setMaximumTrackTintColor:[Utiles colorWithHexString:@"#0B0B0B"]];
    [marketPremiumSlider setMinimumTrackTintColor:[Utiles colorWithHexString:@"#EA7A1F"]];
    [marketPremiumSlider setMaximumTrackTintColor:[Utiles colorWithHexString:@"#0B0B0B"]];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    webIsLoaded=YES;
    [Utiles getObjectDataFromJsFun:self.webView funName:@"initData" byData:self.jsonData shouldTrans:YES];

    id tempData=[Utiles getObjectDataFromJsFun:self.webView funName:@"returnDefaultWaccData" byData:@"" shouldTrans:YES];
    NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
    for(id obj in tempData){
        [tmpArr addObject:[obj mutableCopy]];
    }
    self.defaultTransData=tmpArr;
    SAFE_RELEASE(tmpArr);
    if(![Utiles isBlankString:self.valuesStr]){
        self.valuesStr=[self.valuesStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        [Utiles getObjectDataFromJsFun:self.webView funName:@"setValues" byData:self.valuesStr shouldTrans:NO];
        id tempData=[Utiles getObjectDataFromJsFun:self.webView funName:@"returnWaccData" byData:@"" shouldTrans:YES];
        NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
        for(id obj in tempData){
            [tmpArr addObject:[obj mutableCopy]];
        }
        self.transData=tmpArr;
        [self caluPriceWithData:self.transData];
        [self updateComponents];
        SAFE_RELEASE(tmpArr);
    }else{
        [self adjustChartDataForSaved:[comInfo objectForKey:@"stockcode"] andToken:[Utiles getUserToken]];
    }
}

#pragma mark -
#pragma mark Button Action

-(IBAction)btClick:(UIButton *)bt{
    bt.showsTouchWhenHighlighted=YES;
    if(bt.tag==ResetChart){
        self.disCountIsChanged=NO;
        [self.transData removeAllObjects];
        for(id obj in self.defaultTransData){
            [self.transData addObject:obj];
        }
        [self caluPriceWithData:self.transData];
        [self updateComponents];
    }else if(bt.tag==SaveData){
        
        id combinedData=[DrawChartTool changedDataCombinedWebView:self.webView comInfo:comInfo ggPrice:[self.ggPriceLabel text] dragChartChangedDriverIds:self.dragChartChangedDriverIds disCountIsChanged:self.disCountIsChanged];
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",[combinedData JSONString],@"data", nil];
        [Utiles postNetInfoWithPath:@"AddModelData" andParams:params besidesBlock:^(id resObj){
            if([resObj objectForKey:@"status"]){
                self.disCountIsChanged=NO;
                [saveBt setBackgroundImage:[UIImage imageNamed:@"savedBt"] forState:UIControlStateNormal];
                [saveBt setEnabled:NO];
                isSaved=YES;
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }else if(bt.tag==BackToSuperView){
        
        CATransition *transition=[CATransition animation];
        transition.duration=0.5f;
        transition.fillMode=kCAFillRuleNonZero;
        transition.type=kCATransitionFade;
        transition.subtype=kCATransitionFromTop;
        [self.view removeFromSuperview];
        [self.chartViewController.view.layer addAnimation:transition forKey:@"animation"];
        [self.chartViewController viewDidAppear:YES];

    }
}

-(IBAction)sliderChanged:(UISlider *)slider{
    if(isSaved){
        [saveBt setEnabled:YES];
        [saveBt setBackgroundImage:[UIImage imageNamed:@"saveBt"] forState:UIControlStateNormal];
        isSaved=NO;
    }
    self.disCountIsChanged=YES;
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"##0.##"];
    float progress = slider.value;
    if(slider.tag==1){
        unRiskRateLabel.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:[NSNumber numberWithFloat:progress]]];
        [self resetValue:progress index:0];
    }else if(slider.tag==2){
        marketBetaLabel.text = [NSString stringWithFormat:@"%.2f", progress];
        [self resetValue:progress index:1];
    }else if(slider.tag==3){
        marketPremiumLabel.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:[NSNumber numberWithFloat:progress]]];
        [self resetValue:progress index:2];
    }
    SAFE_RELEASE(formatter);
}

#pragma mark -
#pragma mark General Methods


-(void)adjustChartDataForSaved:(NSString *)stockCode andToken:(NSString*)token{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:stockCode,@"stockcode",token,@"token",@"googuu",@"from", nil];
    [Utiles getNetInfoWithPath:@"AdjustedData" andParams:params besidesBlock:^(id resObj){
        if(resObj){
            @try {
                NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
                for(id data in [resObj objectForKey:@"data"]){
                    if([[data objectForKey:@"data"] count]==1){
                        NSDictionary *pie=[NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"itemname"],@"name",[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"v"],@"data",[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"v"],@"datanew",[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"],@"id", nil];
                        [tmpArr addObject:pie];
                    }else{
                        NSString *jsonPrice=[[data objectForKey:@"data"] JSONString];
                        jsonPrice=[jsonPrice stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                        [Utiles getObjectDataFromJsFun:self.webView funName:@"chartCalu" byData:jsonPrice shouldTrans:NO];
                    }
                    
                }
                [self caluPriceWithData:tmpArr];
                [self updateComponents];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)caluPriceWithData:(id)obj{
    NSString *jsonForChart=[[obj JSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    id tempData=[Utiles getObjectDataFromJsFun:self.webView funName:@"chartCaluWacc" byData:jsonForChart shouldTrans:YES];
    
    [self.transData removeAllObjects];
    for(id obj in tempData){
        [self.transData addObject:obj];
    }
}

-(void)resetValue:(float)progress index:(NSInteger)index{
    NSMutableDictionary * temp=[[NSMutableDictionary alloc] initWithDictionary:[self.transData objectAtIndex:index]];
    if(index!=1){
        progress=progress/100;
    }
    [temp setObject:[NSNumber numberWithFloat:progress] forKey:@"datanew"];
    [self.transData setObject:temp atIndexedSubscript:index];
    [self caluPriceWithData:self.transData];
    
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"##0.##"];
    self.myRateLabel.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.transData objectAtIndex:5] objectForKey:@"datanew"] floatValue]*100]]];
    self.ggPriceLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.transData objectAtIndex:6] objectForKey:@"ggPrice"] floatValue]]]];
    SAFE_RELEASE(formatter);
    SAFE_RELEASE(temp);
}


-(void)updateComponents{

    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"##0.##"];
    
    [self.companyNameLabel setText:[NSString stringWithFormat:@"%@\n(%@.%@)",[comInfo objectForKey:@"companyname"],[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"market"]]];
    [self.marketPriceLabel setText:[[comInfo objectForKey:@"marketprice"] stringValue]];
    self.ggPriceLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.transData objectAtIndex:6] objectForKey:@"ggPrice"] floatValue]]]];
    ggPrice=[[[self.transData objectAtIndex:6] objectForKey:@"ggPrice"] floatValue];
 
    myRate=[[[self.transData objectAtIndex:5] objectForKey:@"datanew"] floatValue];
    unRisk=[[[self.transData objectAtIndex:0] objectForKey:@"datanew"] floatValue];
    marketBeta=[[[self.transData objectAtIndex:1] objectForKey:@"datanew"] floatValue];
    marketPremium=[[[self.transData objectAtIndex:2] objectForKey:@"datanew"] floatValue];
    float defaultunRisk=[[[self.transData objectAtIndex:0] objectForKey:@"data"] floatValue];
    float defaultmarketBeta=[[[self.transData objectAtIndex:1] objectForKey:@"data"] floatValue];
    float defaultmarketPremium=[[[self.transData objectAtIndex:2] objectForKey:@"data"] floatValue];

    self.defaultUnRiskRateLabel.text=[NSString stringWithFormat:@"无风险利率%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:defaultunRisk*100]]];
    self.defaultMarketBetaLabel.text=[NSString stringWithFormat:@"市场贝塔值%@",[formatter stringFromNumber:[NSNumber numberWithFloat:defaultmarketBeta]]];
    self.defaultMarketPremiumLabel.text=[NSString stringWithFormat:@"市场溢价%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:defaultmarketPremium*100]]];
    
    self.myRateLabel.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:myRate*100]]];
    self.suggestRateLabel.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.transData objectAtIndex:5] objectForKey:@"datanew"] floatValue]*100]]];
    self.unRiskRateLabel.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:unRisk*100]]];
    self.marketBetaLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:marketBeta]]];
    self.marketPremiumLabel.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:marketPremium*100]]];
    
    [self.marketPremiumMaxLabel setText:[NSString stringWithFormat:@"%.2f",[[[self.transData objectAtIndex:1] objectForKey:@"data"] floatValue]+1]];
    [self.marketPremiumMinLabel setText:[NSString stringWithFormat:@"%.2f",[[[self.transData objectAtIndex:1] objectForKey:@"data"] floatValue]-1]];
    [self.marketBetaSlider setMaximumValue:[[[self.transData objectAtIndex:1] objectForKey:@"data"] floatValue]+1];
    [self.marketBetaSlider setMinimumValue:[[[self.transData objectAtIndex:1] objectForKey:@"data"] floatValue]-1];
    [self.unRiskRateSlider setValue:unRisk*100 animated:YES];
    [self.marketBetaSlider setValue:marketBeta animated:YES];
    [self.marketPremiumSlider setValue:marketPremium*100 animated:YES];
    SAFE_RELEASE(formatter);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
    } else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.view.frame=CGRectMake(0,0,SCREEN_HEIGHT,SCREEN_WIDTH);
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

















@end
