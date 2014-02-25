//
//  ClientCommentCell.m
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ClientCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ClientCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *temp1 = [[[UIImageView alloc] init] autorelease];
        self.thumbnail1 = temp1;
        UIImageView *temp2 = [[[UIImageView alloc] init] autorelease];
        self.thumbnail2 = temp2;
        UIImageView *temp3 = [[[UIImageView alloc] init] autorelease];
        self.thumbnail3 = temp3;
        UIImageView *temp4 = [[[UIImageView alloc] init] autorelease];
        self.thumbnail4 = temp4;
        UIImageView *temp5 = [[[UIImageView alloc] init] autorelease];
        self.thumbnail5 = temp5;
        
        self.thumbnails = [NSMutableArray arrayWithObjects:self.thumbnail1,self.thumbnail2,self.thumbnail3,self.thumbnail4,self.thumbnail5, nil];
        self.contentTextView.userInteractionEnabled = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    UIImageView *tempAva = [[[UIImageView alloc] initWithFrame:CGRectMake(15,5,40,40)] autorelease];
    self.avatarImg = tempAva;
    [self addSubview:self.avatarImg];
    [self.avatarImg setImageWithURL:[NSURL URLWithString:self.avaURL] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];

    self.userNameLabel = [self createLabel:CGRectMake(60,7,200,15) font:[UIFont fontWithName:@"Heiti SC" size:14.0] color:[UIColor blackColor] content:self.userName];
    
    self.artTitleLabel = [self createLabel:CGRectMake(60,25,250,15) font:[UIFont fontWithName:@"Heiti SC" size:12.0] color:[UIColor peterRiverColor] content:self.artTitle];
    
    self.updateTimeLabel = [self createLabel:CGRectMake(250,7,60,15) font:[UIFont fontWithName:@"Heiti SC" size:10.0] color:[UIColor pumpkinColor] content:self.updateTime];
    self.updateTimeLabel.textAlignment = NSTextAlignmentRight;
    
    CGSize size = [Utiles getLabelSizeFromString:self.content font:[UIFont fontWithName:@"Heiti SC" size:14.0] width:310];
    //添加行间距计算控件整体高度
    float height = [self.content sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:14.0]}].height;
    int lines = size.height/height + 3;
    size.height = size.height + 8*lines;
    self.contentTextView = [self createTextView:CGRectMake(10,48,300, size.height) font:[UIFont fontWithName:@"Heiti SC" size:14.0] color:[UIColor blackColor] content:self.content];
    
    if (self.thumbnailsURL) {
        [self addThumbnail:size];
    }

}

-(void)addThumbnail:(CGSize)size {
    
    for (int n = 0;n < [self.thumbnailsURL count];n ++) {

        UIImageView *temp = self.thumbnails[n];
        temp.frame = CGRectMake(15+60*n,35+size.height,50,50);
        [self addSubview:temp];
        [temp setImageWithURL:[NSURL URLWithString:self.thumbnailsURL[n]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
    }
    
}

-(UILabel *)createLabel:(CGRect)frame font:(UIFont *)font color:(UIColor *)color content:(NSString *)str{
    
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.font = font;
    label.textColor = color;
    label.text = str;
    [self addSubview:label];
    return label;
    
}

-(UITextView *)createTextView:(CGRect)frame font:(UIFont *)font color:(UIColor *)color content:(NSString *)str{
    
    UITextView *view = [[[UITextView alloc] initWithFrame:frame] autorelease];
    view.layoutManager.delegate = self;
    view.editable = NO;
    view.scrollEnabled = NO;
    view.font = font;
    view.textColor = color;
    view.text = str;
    [self addSubview:view];
    return view;
    
}

#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
