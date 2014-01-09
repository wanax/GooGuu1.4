//
//  LabelSwitchCell.h
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 个人设置中心带switch选项卡的cell

#import <UIKit/UIKit.h>

@interface LabelSwitchCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UISwitch *controlSwitch;

@end
