//
//  AddCell.m
//  welcom_demo_1
//
//  Created by Xcode on 13-5-7.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-07 | Wanax | 添加股票自定义cell

#import "AddCell.h"

@implementation AddCell

@synthesize image;
@synthesize addIconView;

- (void)dealloc
{
    [image release];
    [addIconView release];
    [super dealloc];
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:image]) {
        image = [img copy];
        self.addIconView.image=image;
    }
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
