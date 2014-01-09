//
//  HelpViewController.h
//  googuu
//
//  Created by Xcode on 13-9-3.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController{
    CGPoint standard;
}

@property HelpType type;
@property (nonatomic,retain) UIImageView *imageView;

@end
