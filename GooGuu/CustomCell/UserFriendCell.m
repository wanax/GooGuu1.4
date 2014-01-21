//
//  UserFriendCell.m
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "UserFriendCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    UIImageView *tempAva = [[[UIImageView alloc] initWithFrame:CGRectMake(8,8,40,40)] autorelease];
    self.avatarImg = tempAva;
    [self addSubview:self.avatarImg];
    [self.avatarImg setImageWithURL:[NSURL URLWithString:self.avaURL] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
    
    self.userNameLabel = [self createLabel:CGRectMake(56,20,200,15) font:[UIFont fontWithName:@"Heiti SC" size:14.0] color:[UIColor blackColor] content:self.userName];
    
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
