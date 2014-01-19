//
//  TopCommentCell.m
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "TopCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TopCommentCell

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
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    UIImageView *tempAva = [[[UIImageView alloc] initWithFrame:CGRectMake(5,10,40,40)] autorelease];
    self.avatarImg = tempAva;
    [self addSubview:self.avatarImg];
    [self.avatarImg setImageWithURL:[NSURL URLWithString:self.avaURL] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];

    self.userNameLabel = [self createLabel:CGRectMake(50,7,200,15) font:[UIFont fontWithName:@"Heiti SC" size:14.0] color:[UIColor blackColor] content:self.userName];
    
    self.artTitleLabel = [self createLabel:CGRectMake(50,25,250,15) font:[UIFont fontWithName:@"Heiti SC" size:12.0] color:[UIColor peterRiverColor] content:self.artTitle];
    
    self.updateTimeLabel = [self createLabel:CGRectMake(250,7,60,15) font:[UIFont fontWithName:@"Heiti SC" size:10.0] color:[UIColor pumpkinColor] content:self.updateTime];
    self.updateTimeLabel.textAlignment = NSTextAlignmentRight;
    
    CGSize size = [Utiles getLabelSizeFromString:self.content font:[UIFont fontWithName:@"Heiti SC" size:12.0] width:265];
    self.contentLabel = [self createLabel:CGRectMake(50,45,size.width, size.height) font:[UIFont fontWithName:@"Heiti SC" size:12.0] color:[UIColor blackColor] content:self.content];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (self.thumbnailsURL) {
        [self addThumbnail:size];
    }

}

-(void)addThumbnail:(CGSize)size {
    
    for (int n = 0;n < [self.thumbnailsURL count];n ++) {

        UIImageView *temp = self.thumbnails[n];
        temp.frame = CGRectMake(55,50+size.height,50,50);
        [self addSubview:temp];
        [temp setImageWithURL:[NSURL URLWithString:self.thumbnailsURL[n]] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
