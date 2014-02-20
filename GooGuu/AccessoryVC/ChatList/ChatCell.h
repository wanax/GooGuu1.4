//
//  ChatCell.h
//  GooGuu
//
//  Created by Xcode on 14-2-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic,retain) id chatInfo;
@property (nonatomic,retain) NSString *belong;

@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) UIImageView *avatarImg;
@property (nonatomic,retain) UIImageView *bubbleImg;

@end
