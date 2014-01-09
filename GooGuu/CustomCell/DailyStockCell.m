//
//  DailyStockCell.m
//  UIDemo
//
//  Created by Xcode on 13-7-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DailyStockCell.h"

@implementation DailyStockCell

@synthesize dailyStockImg;
@synthesize arrowImg;
@synthesize communityPriceLabel;
@synthesize companyNameLabel;
@synthesize gooGuuPriceLabel;
@synthesize marketLabel;
@synthesize tradeLabel;
@synthesize marketPriceLabel;
@synthesize outLookLabel;
@synthesize outLookTextLabel;

- (void)dealloc
{
    SAFE_RELEASE(arrowImg);
    [outLookTextLabel release];outLookTextLabel=nil;
    [outLookLabel release];outLookLabel=nil;
    [communityPriceLabel release];communityPriceLabel=nil;
    [companyNameLabel release];companyNameLabel=nil;
    [gooGuuPriceLabel release];gooGuuPriceLabel=nil;
    [marketPriceLabel release];marketPriceLabel=nil;
    [tradeLabel release];tradeLabel=nil;
    [marketLabel release];marketLabel=nil;
    [dailyStockImg release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
