//
//  tipViewController.h
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-04-10.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-04-10 | Wanax | 初次使用引导界面

#import <UIKit/UIKit.h>


@interface TipViewController : UIViewController<UIScrollViewDelegate>
{
    
}

@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UIImageView * left;
@property(nonatomic,strong) UIImageView * right;

@property(retain,nonatomic) UIScrollView * pageScroll;
@property(retain,nonatomic) UIPageControl * pageControl;

@property(retain,nonatomic) UIButton * gotoMainViewBtn;

-(void)gotoMainView:(id)sender;







@end
