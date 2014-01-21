//
//  CompanyCell.h
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *comNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPriLable;
@property (nonatomic,retain) IBOutlet UILabel *googuuPriLable;
@property (nonatomic,retain) IBOutlet UIImageView *indicatorImg;
@property (nonatomic,retain) IBOutlet UILabel *percentLable;
@property (nonatomic,retain) IBOutlet UIButton *attentionBt;

@end
