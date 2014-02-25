//
//  ImageLongPressGestureRecognizer.m
//  GooGuu
//
//  Created by Xcode on 14-2-21.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ImageLongPressGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ImageLongPressGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageview = nil;
    
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [self locationInView:self.view];
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && CGRectContainsPoint(view.frame, location))
        {
            self.imageview = (UIImageView *)view;
            return;
        }
    }
    
    self.state = UIGestureRecognizerStateFailed;
}

@end
