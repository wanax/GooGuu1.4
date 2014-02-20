//
//  ChatCell.m
//  GooGuu
//
//  Created by Xcode on 14-2-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ChatCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        id info = [GetUserDefaults(@"UserInfo") objectFromJSONString];
        self.belong = info[@"username"];
    }
    return self;
}

-(BOOL)isSelfMsg:(NSString *)target {
    return [self.belong isEqual:target];
}

-(void)drawRect:(CGRect)rect {
    
    bool isSelf = [self isSelfMsg:self.chatInfo[@"username"]];
    CGSize size = [Utiles getLabelSizeFromString:self.chatInfo[@"cotent"] font:[UIFont fontWithName:@"Heiti SC" size:12.0] width:200];

    //背影图片
	UIImage *bubble = nil;
    UIImageView *tempAva = nil;
    if (isSelf) {
        tempAva = [[[UIImageView alloc] initWithFrame:CGRectMake(270,10,40,40)] autorelease];
        
        bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myMsgBack" ofType:@"png"]];
        UIImageView *bubbleImageView = [[[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]] autorelease];
        self.bubbleImg = bubbleImageView;
        self.bubbleImg.frame = CGRectMake(240-size.width, 10.0f, size.width+30.0f, size.height+25.0f);
        [self addSubview:self.bubbleImg];
        
        self.contentLabel = [self createLabel:CGRectMake(250-size.width,18,size.width, size.height) font:[UIFont fontWithName:@"Heiti SC" size:12.0] color:[UIColor blackColor] content:self.chatInfo[@"cotent"]];
    } else {
        tempAva = [[[UIImageView alloc] initWithFrame:CGRectMake(5,10,40,40)] autorelease];
        
        bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"targetMsgBack" ofType:@"png"]];
        UIImageView *bubbleImageView = [[[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]] autorelease];
        self.bubbleImg = bubbleImageView;
        self.bubbleImg.frame = CGRectMake(45.0f, 10.0f, size.width+30.0f, size.height+25.0f);
        [self addSubview:self.bubbleImg];
        
        self.contentLabel = [self createLabel:CGRectMake(60,18,size.width, size.height) font:[UIFont fontWithName:@"Heiti SC" size:12.0] color:[UIColor blackColor] content:self.chatInfo[@"cotent"]];
    }
    
    self.avatarImg = tempAva;
    [self addSubview:self.avatarImg];
    [self.avatarImg setImageWithURL:[NSURL URLWithString:self.chatInfo[@"userheaderimg"]] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];

    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;

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
