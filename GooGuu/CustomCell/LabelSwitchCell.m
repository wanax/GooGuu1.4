//
//  LabelSwitchCell.m
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "LabelSwitchCell.h"

@implementation LabelSwitchCell

@synthesize titleLabel;
@synthesize controlSwitch;


- (void)dealloc
{
    [titleLabel release];titleLabel=nil;
    [controlSwitch release];controlSwitch=nil;
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
