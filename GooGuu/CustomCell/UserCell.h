//
//  CustomCell.h
//  Custom Cell
//
//  Created by Yang on 13-05-07.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-07 | Wanax | 用户评论中自定义cell
//  2013-08-05 | Wanax | 废弃

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell

+ (UINib *)nib;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *decLabel;
@property (nonatomic,retain) IBOutlet UITextView *decTextView;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dec;
@property (copy, nonatomic) NSString *loc;

@end
