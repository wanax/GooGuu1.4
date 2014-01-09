//
//  DiscountRateViewController.h
//  估股
//
//  Created by Xcode on 13-8-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartViewController;

@interface DiscountRateViewController : UIViewController<UIWebViewDelegate>{
    float ggPrice;
    float myRate;
    float unRisk;
    float marketBeta;
    float marketPremium;
}

@property BOOL isSaved;
@property BOOL webIsLoaded;
@property BOOL disCountIsChanged;
@property BrowseSourceType sourceType;
@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id jsonData;
@property (nonatomic,retain) NSString *valuesStr;
@property (nonatomic,retain) NSArray *defaultTransData;
@property (nonatomic,retain) NSMutableArray *transData;
@property (nonatomic,retain) NSArray *dragChartChangedDriverIds;

@property (nonatomic,retain) IBOutlet UIButton *resetBt;
@property (nonatomic,retain) IBOutlet UIButton *saveBt;
@property (nonatomic,retain) IBOutlet UIButton *backBt;

@property (nonatomic,retain) IBOutlet UILabel *companyNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *ggPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *suggestRateLabel;
@property (nonatomic,retain) IBOutlet UILabel *myRateLabel;
@property (nonatomic,retain) IBOutlet UILabel *defaultUnRiskRateLabel;
@property (nonatomic,retain) IBOutlet UILabel *defaultMarketBetaLabel;
@property (nonatomic,retain) IBOutlet UILabel *defaultMarketPremiumLabel;
@property (nonatomic,retain) IBOutlet UILabel *unRiskRateLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketBetaLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPremiumLabel;
@property (nonatomic,retain) IBOutlet UILabel *unRiskRateMinLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketBetaMinLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPremiumMinLabel;
@property (nonatomic,retain) IBOutlet UILabel *unRiskRateMaxLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketBetaMaxLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPremiumMaxLabel;

@property (nonatomic,retain) IBOutlet UISlider *unRiskRateSlider;
@property (nonatomic,retain) IBOutlet UISlider *marketBetaSlider;
@property (nonatomic,retain) IBOutlet UISlider *marketPremiumSlider;

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) ChartViewController *chartViewController;

-(IBAction)btClick:(UIButton *)bt;
-(IBAction)sliderChanged:(UISlider *)slider;








@end
