//
//  StockCell.m
//  UIDemo
//
//  Created by Xcode on 13-7-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "StockCell.h"
#import "CommonlyMacros.h"

@implementation StockCell

@synthesize stockNameLabel;
@synthesize concernBt;

@synthesize belongLabel;
@synthesize gPriceLabel;
@synthesize priceLabel;

@synthesize gooGuuPriceLabel;
@synthesize marketPriceLabel;
@synthesize percentLabel;

- (void)dealloc
{
    SAFE_RELEASE(percentLabel);
    SAFE_RELEASE(gooGuuPriceLabel);
    SAFE_RELEASE(marketPriceLabel);
    SAFE_RELEASE(belongLabel);
    SAFE_RELEASE(gPriceLabel);
    SAFE_RELEASE(priceLabel);
    SAFE_RELEASE(stockNameLabel);
    SAFE_RELEASE(concernBt);
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
