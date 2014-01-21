//
//  IndicatorSearchView.m
//  googuu
//
//  Created by Xcode on 13-8-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "IndicatorSearchView.h"

@implementation IndicatorSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0,0,SCREEN_WIDTH,30);
        [self setBackgroundColor:[Utiles colorWithHexString:@"#412E1B"]];
        
        [self addLabelTitle:@"公司名称" frame:CGRectMake(20,3,55,21)];
        [self addLabelTitle:@"股票代码" frame:CGRectMake(115,3,55,21)];
        [self addLabelTitle:@"状态" frame:CGRectMake(190,3,55,21)];
        
        
    }
    return self;
}

-(void)addLabelTitle:(NSString *)title frame:(CGRect)rect{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    [label setTextColor:[Utiles colorWithHexString:@"#b7a491"]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
    SAFE_RELEASE(label);
}























@end
