//
//  ValueViewCell.h
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValueViewCell : UITableViewCell<NSLayoutManagerDelegate>

@property (nonatomic,retain) IBOutlet UIImageView *titleImgView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *updateTimeLabel;
@property (nonatomic,retain) IBOutlet UIWebView *conciseWebView;
@property (nonatomic,retain) IBOutlet UITextView *conciseTextView;
@property (nonatomic,retain) IBOutlet UIImageView *readMarkImg;

@property (retain, nonatomic) NSString *content;

@end
