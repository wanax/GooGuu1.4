//
//  DoubleLabelCell.h
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 双label cell
//  2013-08-05 | Wanax | 废弃

#import <UIKit/UIKit.h>

@interface DoubleLabelCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *detailLabel;

@end
