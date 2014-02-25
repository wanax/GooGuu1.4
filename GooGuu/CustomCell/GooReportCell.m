//
//  GooReportCell.m
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooReportCell.h"

@implementation GooReportCell

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
        self.backgroundColor=[UIColor grayColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    self.contentTextView.layoutManager.delegate = self;
    self.contentTextView.text = self.content;
}

#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
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
