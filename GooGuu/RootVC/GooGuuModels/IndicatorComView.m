//
//  IndicatorComView.m
//  估股
//
//  Created by Xcode on 13-8-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "IndicatorComView.h"

@implementation IndicatorComView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0,0,SCREEN_WIDTH,30);
        [self setBackgroundColor:[UIColor cloudsColor]];
        
        UILabel *companyNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(29,3,55,21)];
        [companyNameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
        [companyNameLabel setTextAlignment:NSTextAlignmentCenter];
        [companyNameLabel setText:@"公司名称"];
        [companyNameLabel setTextColor:[Utiles colorWithHexString:@"#B9B9B6"]];
        [companyNameLabel setBackgroundColor:[UIColor cloudsColor]];
        [self addSubview:companyNameLabel];
        [companyNameLabel release];
        
        UILabel *marketPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(102,3,55,21)];
        [marketPriceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
        [marketPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [marketPriceLabel setText:@"市场价"];
        [marketPriceLabel setTextColor:[Utiles colorWithHexString:@"#B9B9B6"]];
        [marketPriceLabel setBackgroundColor:[UIColor cloudsColor]];
        [self addSubview:marketPriceLabel];
        [marketPriceLabel release];
        
        UILabel *googuuPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(147,3,55,21)];
        [googuuPriceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
        [googuuPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [googuuPriceLabel setText:@"估股价"];
        [googuuPriceLabel setTextColor:[Utiles colorWithHexString:@"#B9B9B6"]];
        [googuuPriceLabel setBackgroundColor:[UIColor cloudsColor]];
        [self addSubview:googuuPriceLabel];
        [googuuPriceLabel release];
        
        UILabel *outLookingLabel=[[UILabel alloc] initWithFrame:CGRectMake(208,3,55,21)];
        [outLookingLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
        [outLookingLabel setTextAlignment:NSTextAlignmentCenter];
        [outLookingLabel setText:@"潜在空间"];
        [outLookingLabel setTextColor:[Utiles colorWithHexString:@"#B9B9B6"]];
        [outLookingLabel setBackgroundColor:[UIColor cloudsColor]];
        [self addSubview:outLookingLabel];
        [outLookingLabel release];
    }
    return self;
}


@end
