//
//  TopCommentCell
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCommentCell : UITableViewCell

@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *artTitle;
@property (nonatomic,retain) NSString *updateTime;
@property (nonatomic,retain) NSString *avaURL;
@property (nonatomic,retain) NSArray *thumbnailsURL;
@property (nonatomic,retain) NSMutableArray *thumbnails;

@property (nonatomic,retain) UIImageView *avatarImg;
@property (nonatomic,retain) UIImageView *thumbnail1;
@property (nonatomic,retain) UIImageView *thumbnail2;
@property (nonatomic,retain) UIImageView *thumbnail3;
@property (nonatomic,retain) UIImageView *thumbnail4;
@property (nonatomic,retain) UIImageView *thumbnail5;
@property (nonatomic,retain) UILabel *userNameLabel;
@property (nonatomic,retain) UILabel *artTitleLabel;
@property (nonatomic,retain) UILabel *updateTimeLabel;
@property (nonatomic,retain) UILabel *contentLabel;

@end
