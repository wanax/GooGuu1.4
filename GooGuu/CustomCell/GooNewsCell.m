//
//  GooNewsCell.m
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooNewsCell.h"

@implementation GooNewsCell

@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeDiferLabel;
@synthesize readMarkImg;

@synthesize title;
@synthesize content;

- (void)dealloc
{
    [readMarkImg release];readMarkImg=nil;
    [timeDiferLabel release];timeDiferLabel=nil;
    [title release];title=nil;
    [content release];content=nil;
    
    [titleLabel release];titleLabel=nil;
    [contentLabel release];contentLabel=nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor grayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)setTitle:(NSString *)t {
    if (![t isEqualToString:title]) {
        title = [t copy];
        self.titleLabel.text = title;
    }
    
}

-(void)setContent:(NSString *)c{
    if (![c isEqualToString:content]) {
        content = [c copy];
        self.contentLabel.text = content;
    }
}























@end
