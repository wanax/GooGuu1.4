//
//  UserFriendCell.h
//  GooGuu
//
//  Created by Xcode on 14-1-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFriendCell : UITableViewCell

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *avaURL;

@property (nonatomic,retain) UIImageView *avatarImg;
@property (nonatomic,retain) UILabel *userNameLabel;

@end
