//
//  UIButton+BGColor.m
//  UIDemo
//
//  Created by Xcode on 13-7-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UIButton+BGColor.h"


@implementation UIButton(BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect buttonSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *bgView = [[[UIView alloc] initWithFrame:buttonSize] autorelease];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = true;
    bgView.backgroundColor = color;
    UIGraphicsBeginImageContext(self.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:screenImage forState:state];
}

- (void)setBackgroundColorString:(NSString *)colorStr forState:(UIControlState)state {
    UIColor *color = [Utiles colorWithHexString:colorStr];
    [self setBackgroundColor:color forState:state];
}

@end
