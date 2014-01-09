//
//  SearchStockCell.m
//  googuu
//
//  Created by Xcode on 13-8-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "SearchStockCell.h"

@implementation SearchStockCell

@synthesize companyNameLabel;
@synthesize stockCodeLabel;
@synthesize comBriefImg;
@synthesize comModelImg;
@synthesize requestValuationsBt;

- (void)dealloc
{
    SAFE_RELEASE(companyNameLabel);
    SAFE_RELEASE(stockCodeLabel);
    SAFE_RELEASE(comBriefImg);
    SAFE_RELEASE(comModelImg);
    SAFE_RELEASE(requestValuationsBt);
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
